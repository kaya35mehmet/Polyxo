import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

class FlipCards extends StatefulWidget {

  const FlipCards({super.key});

  @override
  State<FlipCards> createState() => _FlipCardsState();
}

class _FlipCardsState extends State<FlipCards> {
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      key: cardKey,
      flipOnTouch: false,
      front: ElevatedButton(
        onPressed: () => cardKey.currentState!.toggleCard(),
        child: const Text('Toggle'),
      ),
      back: const Text('Back'),
    );
  }
}
