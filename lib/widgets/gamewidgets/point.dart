// ignore_for_file: hash_and_equals

import 'package:flutter/material.dart';
import 'dart:math';

class GesturePoint {
  static final pointPainter = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.fill
    ..color = Colors.amber;

  static final linePainter = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.stroke
    ..strokeWidth = 4
    ..color = Colors.transparent;

  final int index;
  final double centerX;
  final double centerY;
  final double radius = 4;
  final double padding = 30;

  GesturePoint(this.index, this.centerX, this.centerY);

  void drawCircle(Canvas canvas, String letter, double fontsize) {
    Size size = const Size(400, 400);
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: letter,
        style: TextStyle(
          color: Colors.black,
          fontSize: fontsize,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(minWidth: 0, maxWidth: size.width);
    textPainter.paint(
        canvas,
        Offset(
            centerX - textPainter.width / 2, centerY - textPainter.height / 2));

    canvas.drawOval(
        Rect.fromCircle(center: Offset(centerX, centerY), radius: padding),
        linePainter);
  }

  bool checkInside(double x, double y) {
    var distance = sqrt(pow((x - centerX), 2) + pow((y - centerY), 2));
    return distance <= padding;
  }

  @override
  bool operator == (Object other) {
    if (other is GesturePoint) {
      return index == other.index &&
          centerX == other.centerX &&
          centerY == other.centerY;
    }
    return false;
  }

}
