import 'package:buga/matchscreen.dart';
import 'package:buga/styles/style.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final int amount;
  final String guid;
  final String point;
  final AnimationController animationController;
  final Animation<double> animation;
  const Button(
      {super.key,
      required this.amount,
      required this.guid,
      required this.point,
      required this.animationController,
      required this.animation});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          side: BorderSide(color: Colors.white.withOpacity(0.5), width: 1.0),
          shadowColor: Colors.black,
          backgroundColor:
              mainColor,
          elevation: 6.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          minimumSize: const Size(250, 60),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MatchScreen(
                guid: guid,
                point: point,
                animation: animation,
                animationController: animationController,
                amount: amount,
              ),
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$amount TOKEN",
              style: profilechoises,
            ),
          ],
        ),
      ),
    );
  }
}
