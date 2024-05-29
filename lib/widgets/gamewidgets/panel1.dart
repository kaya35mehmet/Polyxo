
import 'package:flutter/material.dart';
import 'package:Buga/widgets/gamewidgets/point.dart';

class GestureDotsPanel1 extends StatelessWidget {
  final double width, height;
  final List<GesturePoint> points;
  final List<String> letters;
  final List<int> list;
  const GestureDotsPanel1(this.width, this.height, this.points, this.letters, this.list, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _PanelPainter(points, letters, list),
      ),
    );
  }
}

class _PanelPainter extends CustomPainter {
  final List<GesturePoint> points;
  final List<String> letters;
   final List<int> list;
  _PanelPainter(this.points, this.letters, this.list );

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isNotEmpty) {
      double fontsize = letters.length == 7 ? 48: 50;
      for (var i = 0; i < points.length; i++) {
        points[i].drawCircle(canvas,list[i].toString(), fontsize);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

}