import 'package:flutter/material.dart';


class AnimCardd extends StatefulWidget {
  final Color color;
  final String num;
  final String numEng;
  final String content;

  const AnimCardd(this.color, this.num, this.numEng, this.content, {super.key});

  @override
  State<AnimCardd> createState() => _AnimCardState();
}

class _AnimCardState extends State<AnimCardd> {
  // var padding = 200.0;
  var bottomPadding = 10.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 20, left: 20, top: 100),
          child: AnimatedPadding(
            padding: EdgeInsets.only(top: bottomPadding),
            duration: const Duration(milliseconds: 1000),
            curve: Curves.fastEaseInToSlowEaseOut,
            child: CardItem(
              widget.color,
              widget.num,
              widget.numEng,
              widget.content,
              () {
                setState(() {
                  // padding = padding == 0 ? 220.0 : 0.0;
                  bottomPadding = bottomPadding == 10 ? 60 : 10.0;
                });
              },
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: const EdgeInsets.only(right: 20, left: 20, top: 00),
            height: 160,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.2), blurRadius: 30)
              ],
              color: Colors.grey.shade200.withOpacity(1.0),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Center(
                child: Icon(Icons.favorite,
                    color: const Color.fromARGB(255, 27, 25, 139).withOpacity(1.0), size: 70)),
          ),
        ),
      ],
    );
  }
}

class CardItem extends StatelessWidget {
  final Color color;
  final String num;
  final String numEng;
  final String content;
  final Function() onTap;

  const CardItem(this.color, this.num, this.numEng, this.content, this.onTap, {super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 0),
        height: 100,
        width: width,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: const Color(0xffFF6594).withOpacity(0.2), blurRadius: 25),
          ],
          color: const Color.fromARGB(255, 210, 209, 215).withOpacity(1.0),
          borderRadius: const BorderRadius.vertical(
            bottom:Radius.circular(30),
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Widgets that have global keys reparent their subtrees when ',
                style: TextStyle(),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Cevaplar',
                style: TextStyle(
                    fontFamily: 'Jost',
                    color: Color.fromARGB(255, 22, 20, 20),
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
