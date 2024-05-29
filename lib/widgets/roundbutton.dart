import 'package:flutter/material.dart';


class RoundIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final double size;

  const RoundIconButton({super.key, required this.onPressed, required this.icon, required this.size});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white, // Arkaplan rengi beyaz
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Container(
          width: size,
          height: size,
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
