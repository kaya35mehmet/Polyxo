import 'dart:async';
import 'package:Buga/styles/style.dart';
import 'package:flutter/material.dart';

class GiftScreen extends StatefulWidget {
  final DateTime date;
  const GiftScreen({super.key, required this.date});

  @override
  State<GiftScreen> createState() => _GiftScreenState();
}

class _GiftScreenState extends State<GiftScreen> {
  bool btnDisable = false;
  bool disable = false;
  DateTime? targetDate;
  Duration remainingTime = const Duration();
  Timer? timer;

  String formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
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

  bool is36HoursPassed(DateTime pastDate) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(pastDate);
    return difference.inHours >= 36;
  }

  @override
  void initState() {
    targetDate = widget.date.add(const Duration(hours: 36));
    super.initState();
    bool dd = is36HoursPassed(widget.date);
    if (!dd) {
      setState(() {
        btnDisable = true;
        disable = true;
      });
    }
    startTimer();
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset("assets/images/icons/coins.png"),
                    const Text(
                      "100",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Jost'),
                    )
                  ],
                ),
                const SizedBox(height: 50),
                disable
                    ? Text(
                        formattedRemainingTime,
                        style:
                            const TextStyle(fontSize: 24, color: Colors.white),
                      )
                    : const Center(),
                disable
                    ? const Text(
                        "saat sonra hediyeni alabilirsin!",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      )
                    : const Center(),
                 SizedBox(height: disable ? 20:0),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.black,
                      backgroundColor: !btnDisable ? mainColor : Colors.grey,
                      elevation: 6.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      minimumSize: const Size(100, 50),
                    ),
                    onPressed: !btnDisable
                        ? () {
                            Navigator.pop(context, 100);
                          }
                        : () {},
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "TOPLA",
                          style: TextStyle(
                            fontSize: 20,
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
