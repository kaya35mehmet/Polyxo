import 'package:buga/models/answer.dart';
import 'package:buga/styles/style.dart';
import 'package:flutter/material.dart';


class AnimCard extends StatefulWidget {
  final String photoURL;
  final int trueCount;
  final int falseCount;
  final String remainingtime;
  final List<Answers> answers;
  final double margintop1;
  final double margintop2;
  const AnimCard(this.photoURL, this.trueCount, this.falseCount,
      this.remainingtime, this.answers, this.margintop1, this.margintop2,
      {super.key});

  @override
  State<AnimCard> createState() => _AnimCardState();
}

class _AnimCardState extends State<AnimCard> {
  var bottomPadding = 10.0;
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: EdgeInsets.only(right: 20, left: 20, top: widget.margintop1),
          child: AnimatedPadding(
            padding: EdgeInsets.only(top: bottomPadding),
            duration: const Duration(milliseconds: 1000),
            curve: Curves.fastEaseInToSlowEaseOut,
            child: Column(
              children: [
                CardItem(
                  widget.answers,
                  () {
                    setState(() {
                      // padding = padding == 0 ? 220.0 : 0.0;
                      bottomPadding = bottomPadding == 10 ? 60 : 10.0;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin:  EdgeInsets.only(right: 20, left: 20, top: widget.margintop2),
            height: 160,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 30)
              ],
              color: Colors.grey.shade200.withOpacity(1.0),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          boxShadow: [
                            BoxShadow(
                            offset: Offset(2.5, 2.5),
                            blurRadius: 4.0,
                            color: Color.fromARGB(255, 62, 62, 62),
                          ),
                          ]
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                            widget.photoURL,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Doğru : ${widget.trueCount}",
                            style: resultstyle,
                          ),
                          Text(
                            "Yanlış : ${widget.falseCount}",
                            style: resultstyle,
                          ),
                          Text(
                            "Kalan Süre : ${widget.remainingtime}",
                            style:  resultstyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
               
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CardItem extends StatelessWidget {
  final List<Answers> answers;
  final Function() onTap;
   
  const CardItem(this.answers,this.onTap,  {super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    var screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 0),
        height: 100,
        width: width,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: const Color(0xffFF6594).withOpacity(0.2),
                blurRadius: 25),
          ],
          color: const Color.fromARGB(255, 210, 209, 215).withOpacity(1.0),
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: screenWidth,
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: answers.length,
                  itemBuilder: (context, index) {
                    return Card(
                        color: answers[index].answer!
                            ? Colors.green
                            : Colors.red,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              answers[index].question!.toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ));
                  },
                ),
              ),
             
              Text(
                'Cevaplar',
                style: TextStyle(
                    fontFamily: 'Jost',
                    color: const Color.fromARGB(255, 22, 20, 20),
                    fontSize: 20 * textScaleFactor,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
