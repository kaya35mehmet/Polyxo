import 'package:buga/styles/style.dart';
import 'package:flutter/material.dart';

class StarPoint extends StatelessWidget {
  final int questionpoint;
  const StarPoint({super.key, required this.questionpoint});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          "assets/images/icons/star.png",
          width: 60,
        ),
        Text(
          "$questionpoint",
          style: title28w,
        ),
      ],
    );
  }
}
