import 'dart:async';

import 'package:Buga/styles/style.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class FortuneWheel extends StatefulWidget {
  final DateTime date;
  const FortuneWheel({super.key, required this.date});

  @override
  State<FortuneWheel> createState() => _FortuneWheelState();
}

class _FortuneWheelState extends State<FortuneWheel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _angle = 0;
  final List<String> _items = ["0", "100", "250", "50", "20", "500"];
  final Random _random = Random();
  bool btnDisable = false;
  bool disable = false;
  DateTime? targetDate;
  Duration remainingTime = const Duration();
  Timer? timer;

  @override
  void initState() {
    targetDate = widget.date.add(const Duration(hours: 24));
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _controller.addListener(() {
      setState(() {
        _angle = _animation.value;
      });
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _showResult();
      }
    });

    bool dd = is24HoursPassed(widget.date);
    if (!dd) {
      setState(() {
        btnDisable = true;
        disable = true;
      });
    }
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        remainingTime = targetDate!.difference(DateTime.now());
        if (remainingTime.isNegative) {
          timer?.cancel();
        }
      });
    });
  }

  bool is24HoursPassed(DateTime pastDate) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(pastDate);
    return difference.inHours >= 24;
  }

  String differenceHours(DateTime pastDate) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(pastDate);
    return difference.inHours.toString();
  }

  @override
  void dispose() {
    timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _spinWheel() {
    setState(() {
      btnDisable = true;
    });
    final startAngle = _angle;
    final randomTargetAngle = _random.nextDouble() * 8 * pi + 16 * pi;
    _animation =
        Tween<double>(begin: startAngle, end: startAngle + randomTargetAngle)
            .animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.decelerate,
      ),
    );
    _controller.reset();
    _controller.forward();
  }

  void _showResult() {
    final itemAngle = 2 * pi / _items.length;
    final adjustedAngle = (_angle % (2 * pi));
    final index =
        ((_items.length - ((adjustedAngle + (pi / 2)) % (2 * pi)) / itemAngle)
                .floor() %
            _items.length);
    final selectedItem = _items[index];

    Navigator.pop(context, int.parse(selectedItem));

  }

  String formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    String formattedRemainingTime = formatDuration(remainingTime);
    return AlertDialog(
      backgroundColor: Colors.black.withOpacity(0.7),
      icon: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(0),
              side:
                  BorderSide(color: Colors.white.withOpacity(0.5), width: 1.0),
              shadowColor: Colors.black,
              backgroundColor:
                  const Color.fromARGB(255, 25, 28, 25).withOpacity(0.4),
              elevation: 6.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              minimumSize: const Size(50, 50),
            ),
            onPressed: () async {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.close,
              size: 30,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              SizedBox(
                height: 300,
                width: 300,
                child: CustomPaint(
                  painter: WheelPainter(_angle, _items),
                ),
              ),
              const Positioned(
                top: 0,
                child:
                    Icon(Icons.arrow_drop_down, size: 50, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Column(
              children: [
              disable ?  Text(
                  formattedRemainingTime,
                  style: const TextStyle(fontSize: 24, color: Colors.white),
                ) : const Center(),
               disable ? const Text(
                  "saat sonra yeniden çevir", textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ): const Center(),
                 const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.black,
                      backgroundColor: !btnDisable ? mainColor : Colors.grey,
                      elevation: 6.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      minimumSize: const Size(120, 60),
                    ),
                    onPressed: !btnDisable ? _spinWheel : () {},
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "ÇEVİR",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Jost",
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(0.5, 0.5),
                                blurRadius: 2.0,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WheelPainter extends CustomPainter {
  final double angle;
  final List<String> items;
  final List<Color> _colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    const Color.fromARGB(255, 203, 183, 1),
    Colors.orange,
    Colors.purple
  ];

  WheelPainter(this.angle, this.items);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);
    final itemAngle = 2 * pi / items.length;

    for (int i = 0; i < items.length; i++) {
      paint.color = _colors[i % _colors.length];
      final startAngle = angle + (i * itemAngle);
      canvas.drawArc(rect, startAngle, itemAngle, true, paint);

      final textPainter = TextPainter(
        text: TextSpan(
          text: items[i],
          style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Jost'),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      final textAngle = startAngle + itemAngle / 2;
      final textOffset = Offset(
        center.dx + radius * 0.7 * cos(textAngle) - textPainter.width / 2,
        center.dy + radius * 0.7 * sin(textAngle) - textPainter.height / 2,
      );
      textPainter.paint(canvas, textOffset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
