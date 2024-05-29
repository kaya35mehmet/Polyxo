
import 'package:flutter/material.dart';
import 'package:Buga/widgets/gamewidgets/point.dart';

class GestureDotsPanel extends StatelessWidget {
  final double width, height;
  final List<GesturePoint> points;
  final List<String> letters;
  const GestureDotsPanel(this.width, this.height, this.points, this.letters, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _PanelPainter(points, letters),
      ),
    );
  }
}

class _PanelPainter extends CustomPainter {
  final List<GesturePoint> points;
  final List<String> letters;
  _PanelPainter(this.points, this.letters );

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isNotEmpty) {
      double fontsize = letters.length == 7 ? 45: 50;
      for (var i = 0; i < points.length; i++) {

        points[i].drawCircle(canvas,letters[i], fontsize);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

}