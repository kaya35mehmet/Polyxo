import 'package:flutter/material.dart';

var resultstyle = const TextStyle(
  color: Color.fromARGB(255, 0, 0, 0),
  fontWeight: FontWeight.bold,
  fontSize: 16,
  fontFamily: 'Jost'
);

var resultstylewhite = const TextStyle(
  color: Color.fromARGB(255, 248, 248, 248),
  fontWeight: FontWeight.bold,
  fontSize: 16,
  fontFamily: 'Jost'
);

var profiletitle = const TextStyle(
  color: Color.fromARGB(255, 255, 255, 255),
  fontWeight: FontWeight.bold,
  fontSize: 24,
  fontFamily: 'Jost'
);

var profilechoises = const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Jost",
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(0.5, 0.5),
                              blurRadius: 2.0,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ],
                        );