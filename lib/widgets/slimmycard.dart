
import 'package:flutter/material.dart';
import 'package:flutter_slimy_card/flutter_slimy_card.dart';

class SlimmyCard extends StatelessWidget {
  const SlimmyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: <Widget>[
        FlutterSlimyCard(
          topCardHeight: 160,
          bottomCardHeight: 120,
          topCardWidget: topWidget(),
          bottomCardWidget: bottomWidget(),
        ),
      ],
    ));
  }

  topWidget() {
    return Container(
      child: SafeArea(
        child: Column(
          children: [
            Container(height: 75, child: Image(image: AssetImage('assets/run_horse.png'))),
            SizedBox(
              height: 5,
            ),
            Text(
              'A Horse',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }

  bottomWidget() {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Column(
        children: [
          SizedBox(height: 10),
          Flexible(
              child: Text(
            'A horse is a large animal which people can ride. Some horses are used for pulling ploughs and carts. Say Hello to a Funny Hourse.',
            style: TextStyle(color: Colors.white),
          ))
        ],
      ),
    );
  }
}