import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Hero(
                tag: 'logo',
                child: Text(
                  "WORD\nDUEL",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 70,
                    fontWeight: FontWeight.bold,
                    fontFamily: "ProtestRiot",
                    color: Colors.white,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(4.0, 2.0),
                        blurRadius: 3.0,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                      Shadow(
                        offset: Offset(4.0, 2.0),
                        blurRadius: 8.0,
                        color: Color.fromARGB(125, 0, 0, 255),
                      ),
                    ],
                  ),
                ),
              );
  }
}