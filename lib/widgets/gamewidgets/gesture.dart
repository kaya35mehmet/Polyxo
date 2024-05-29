import 'package:flutter/material.dart';
import 'package:Buga/widgets/gamewidgets/path.dart';
import 'package:Buga/widgets/gamewidgets/point.dart';
import 'package:Buga/widgets/gamewidgets/panel.dart';

typedef OnGestureCompleteListener = void Function(int, int);
typedef OnGestureCompleteListenerOther = void Function(bool);

class GestureView extends StatefulWidget {
  final List<String> letters;
  final double width, height;
  final OnGestureCompleteListener listener;
  final OnGestureCompleteListenerOther listener2;

  const GestureView(
      {super.key,
      required this.width,
      required this.height,
      required this.listener,
      required this.letters,
      required this.listener2});

  @override
  State<StatefulWidget> createState() => _GestureViewState();
}

class _GestureViewState extends State<GestureView> {
  final List<GesturePoint> _points = [];
  final List<int> list = [];

  @override
  void initState() {
    super.initState();
    checkletters();
  }

  checkletters() {
    if (widget.letters.length == 8) {
      for (int row = 0; row < 4; row++) {
        for (int col = 0; col < 4; col++) {
          double deltaW = widget.width / 4;
          double deltaH = widget.height / 5.2;
          int index = row * 4 + col;
          switch (index) {
            case 1:
              deltaW = widget.width / 5.5;
              break;
            case 3:
              deltaW = widget.width / 6;
              break;
            case 5:
              deltaW = widget.width / 12;
              break;
            case 7:
              deltaW = widget.width / 4.7;
              break;
            case 9:
              deltaW = widget.width / 12;
              break;
            case 11:
              deltaW = widget.width / 4.7;
              break;
            case 13:
              deltaW = widget.width / 5.5;
              break;
            case 14:
              deltaW = widget.width / 4.5;
              break;
            default:
          }

          if (index != 0 &&
              index != 2 &&
              index != 4 &&
              index != 6 &&
              index != 8 &&
              index != 10 &&
              index != 12 &&
              index != 15) {
          var p = GesturePoint(index, (col + 1) * deltaW, (row + 1) * deltaH);
            _points.add(p); list.add(index);
          }
        }
      }
    } else if (widget.letters.length == 7) {
      for (int row = 0; row < 4; row++) {
        for (int col = 0; col < 4; col++) {
          double deltaW = widget.width / 4;
          double deltaH = widget.height / 5.5;
          int index = row * 4 + col;
          switch (index) {
            case 1:
              deltaW = widget.width / 5;
              deltaH = widget.height / 3.8;
              break;
            case 5:
              deltaW = widget.width / 13;
              deltaH = widget.height / 5.2;
              break;
            case 7:
              deltaW = widget.width / 5.9;
              deltaH = widget.height / 5.2;
              break;
            case 9:
              deltaW = widget.width / 14;
              deltaH = widget.height / 5.2;
              break;
            case 11:
              deltaW = widget.width / 5.7;
              deltaH = widget.height / 5.2;
              break;
            case 13:
              deltaW = widget.width / 6.5;
              break;
            case 14:
              deltaW = widget.width / 5.6;
              break;
            default:
          }

          if (index != 0 &&
              index != 2 &&
              index != 3 &&
              index != 4 &&
              index != 6 &&
              index != 8 &&
              index != 10 &&
              index != 12 &&
              index != 15) {
          var p = GesturePoint(index, (col + 1) * deltaW, (row + 1) * deltaH);
            _points.add(p); list.add(index);
          }
        }
      }
    } else if (widget.letters.length == 6) {
      
      for (int row = 0; row < 3; row++) {
        for (int col = 0; col < 3; col++) {
          double deltaW = widget.width / 4;
          double deltaH = widget.height / 4.2;
          int index = row * 3 + col;

           switch (index) {
            case 0:
              deltaW = widget.width / 3.75;
              deltaH = widget.height / 3.3;
              break;
            case 1:
              deltaW = widget.width / 3.6;
              deltaH = widget.height / 3.3;
              break;
            case 3:
              deltaW = widget.width / 7.5;
              deltaH = widget.height / 4;
              break;
            case 5:
              deltaW = widget.width / 4.2;
              deltaH = widget.height / 4;
              break;
            case 6:
              deltaW = widget.width / 3.75;
              break;
            case 7:
              deltaW = widget.width / 3.6;
              break;
            default:
          }

          var p = GesturePoint(index, (col + 1) * deltaW, (row + 1) * deltaH);
          if (index != 4 && index != 2 && index != 8) {
            _points.add(p);
          }
        }
      }
    } else if (widget.letters.length == 5) {
      for (int row = 0; row < 3; row++) {
        for (int col = 0; col < 3; col++) {
          double deltaW = widget.width / 4;
          double deltaH = widget.height / 4.3;
          int index = row * 3 + col;

          switch (index) {
            case 0:
              deltaW = widget.width / 2.5;
              deltaH = widget.height / 3.5;
              break;
            case 3:
              deltaW = widget.width / 6.9;
              break;
            case 5:
              deltaW = widget.width / 4.4;
              break;
            case 6:
              deltaW = widget.width / 3.75;
              break;
            case 7:
              deltaW = widget.width / 3.5;
              break;
            default:
          }

          var p = GesturePoint(index, (col + 1) * deltaW, (row + 1) * deltaH);
          if (index != 1 && index != 2 && index != 4 && index != 8) {
            _points.add(p);
          }
        }
      }
    } else if (widget.letters.length == 4) {
      for (int row = 0; row < 3; row++) {
        for (int col = 0; col < 3; col++) {
          double deltaW = widget.width / 4;
          double deltaH = widget.height / 4;
          int index = row * 3 + col;

          switch (index) {
            case 0:
              deltaW = widget.width / 2.45;
              deltaH = widget.height / 3.4;
              break;
            case 6:
              deltaW = widget.width / 2.45;
              deltaH = widget.height / 4.2;
              break;
            case 3:
              deltaW = widget.width / 6.6;
              break;
            case 5:
              deltaW = widget.width / 4.5;
              break;
            default:
          }

          var p = GesturePoint(index, (col + 1) * deltaW, (row + 1) * deltaH);
          if (index != 1 &&
              index != 2 &&
              index != 4 &&
              index != 7 &&
              index != 8) {
            _points.add(p);
          }
        }
      }
    } else if (widget.letters.length == 3) {
      for (int row = 0; row < 2; row++) {
        for (int col = 0; col < 3; col++) {
          double deltaW = widget.width / 3.2;
          double deltaH = widget.height / 3.2;
          int index = row * 3 + col;

          switch (index) {
            case 0:
              deltaW = widget.width / 2;
              break;
            case 3:
              deltaW = widget.width / 3.75;
              break;
            case 5:
              deltaW = widget.width / 3.75;
              break;
            default:
          }

          var p = GesturePoint(index, (col + 1) * deltaW, (row + 1) * deltaH);
          if (index != 1 &&
              index != 2 &&
              index != 4 &&
              index != 6 &&
              index != 7 &&
              index != 8) {
            _points.add(p);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDotsPanel(
            widget.width, widget.height, _points, widget.letters),
        GesturePathView(widget.width, widget.height, _points, widget.listener,
            widget.listener2)
      ],
    );
  }
}
