import 'package:flutter/material.dart';

class ProgressPainter extends CustomPainter {
  final double? value;

  ProgressPainter({this.value});

  Paint backgroundPaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 10;

  Paint valuePaint = Paint()
    ..color = Colors.deepPurple
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 10;

  @override
  void paint(Canvas canvas, Size size) {
    Path backgroundPath = Path();
    Path valuePath = Path();

    backgroundPath.moveTo(0, size.height / 2);
    backgroundPath.lineTo(size.width, size.height / 2);

    valuePath.moveTo(0, size.height / 2);
    valuePath.lineTo(size.width * value!, size.height / 2);

    canvas.drawPath(backgroundPath, backgroundPaint);
    canvas.drawPath(valuePath, valuePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}