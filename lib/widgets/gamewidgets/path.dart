import 'package:flutter/material.dart';
import 'package:Buga/widgets/gamewidgets/gesture.dart';
import 'package:Buga/widgets/gamewidgets/point.dart';

class GesturePathView extends StatefulWidget {
  final double width;
  final double height;
  final List<GesturePoint> points;
  final OnGestureCompleteListener listener;
  final OnGestureCompleteListenerOther listener2;

  const GesturePathView(this.width, this.height, this.points, this.listener, this.listener2, {super.key});

  @override
  State<StatefulWidget> createState() => _GesturePathViewState();
}

class _GesturePathViewState extends State<GesturePathView> {
  GesturePoint? lastPoint;
  Offset? movePos;
  List<GesturePoint> pathPoints = [];
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: _onPanDown,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: CustomPaint(
        size: Size(widget.width, widget.height),
        painter: _PathPainter(movePos, pathPoints),
      ),
    );
  }

  _onPanDown(DragDownDetails e) {
    final x = e.localPosition.dx;
    final y = e.localPosition.dy;
    for (var p in widget.points) {
      if (p.checkInside(x, y)) {
        lastPoint = p;
      }
    }
    pathPoints.clear();
  }

  _onPanUpdate(DragUpdateDetails e) {
    if (lastPoint == null) {
      return;
    }
    final x = e.localPosition.dx;
    final y = e.localPosition.dy;
    GesturePoint? passPoint;
    for (var p in widget.points) {
      if (p.checkInside(x, y) && !pathPoints.contains(p)) {
        passPoint = p;
        break;
      }
    }
    setState(() {
      if (passPoint != null) {
        lastPoint = passPoint;
        pathPoints.add(passPoint);
        if (passPoint.index != 4 && passPoint.index != 2 && passPoint.index != 8) {
            widget.listener(passPoint.index,index);
            index++;
        }
      
      }
      movePos = Offset(x, y);
    });
      
  }

  _onPanEnd(DragEndDetails e) {
    setState(() {
      movePos = null;
      index = 0;
    });
    List<int> arr = [];
    if (pathPoints.isNotEmpty) {
      for (var value in pathPoints) {
        arr.add(value.index);
      }
    }
    if (index < 6) {
      widget.listener2(false);
      pathPoints.clear();
    }else{widget.listener2(true);}
    
  }
}

class _PathPainter extends CustomPainter {
  final Offset? movePos;
  final List<GesturePoint> pathPoints;

  final pathPainter = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10
    ..strokeCap = StrokeCap.round
    ..color = Colors.red;

  _PathPainter(this.movePos, this.pathPoints);

  @override
  void paint(Canvas canvas, Size size) {
    _drawPassPath(canvas);
    _drawRTPath(canvas);
  }

  _drawPassPath(Canvas canvas) {
    if (pathPoints.length <= 1) {
      return;
    }
    for (int i = 0; i < pathPoints.length - 1; i++) {
      var start = pathPoints[i];
      var end = pathPoints[i + 1];
      canvas.drawLine(Offset(start.centerX, start.centerY),
          Offset(end.centerX, end.centerY), pathPainter);
    }
  }

  _drawRTPath(Canvas canvas) {
    if (pathPoints.isNotEmpty && movePos != null) {
      var lastPoint = pathPoints.last;
      canvas.drawLine(Offset(lastPoint.centerX, lastPoint.centerY), movePos!, pathPainter);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}