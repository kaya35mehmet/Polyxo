import 'package:flutter/material.dart';

class CircleNumber extends StatelessWidget {
  final int number;
  final bool answer;
  const CircleNumber(this.number, this.answer, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      width: 50.0,
      height: 50.0,
      decoration:  BoxDecoration(
        shape: BoxShape.circle,
        color: !answer ? Colors.red : const Color(0xFF1fb109),
      ),
      child: Center(
        child: Text(
          number.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }
}