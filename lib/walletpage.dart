import 'package:buga/styles/style.dart';
import 'package:flutter/material.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5286e1),
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Cüzdanım",
          style: title28w,
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Ink(
            height: 200,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black,
                  Colors.black87,
                  Colors.black54,
                  Color(0xFF5286e1)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              color: Colors.black38,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  "Pek Yakında",
                  style: title28w,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}