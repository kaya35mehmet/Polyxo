import 'package:flutter/material.dart';
import 'dart:math';

class ShiningStar extends StatefulWidget {
  @override
  _ShiningStarState createState() => _ShiningStarState();
}

class _ShiningStarState extends State<ShiningStar> with SingleTickerProviderStateMixin {
 late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: StarPainter(_animation.value),
          size: Size(200, 200),
        );
      },
    );
  }
}

class StarPainter extends CustomPainter {
  final double scale;

  StarPainter(this.scale);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.yellow.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2) * scale;
    final innerRadius = radius / 2.5;

    for (int i = 0; i < 10; i++) {
      final angle = (i * 36) * pi / 180;
      final x = center.dx + (i.isEven ? radius : innerRadius) * cos(angle);
      final y = center.dy + (i.isEven ? radius : innerRadius) * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}