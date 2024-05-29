import 'package:Buga/functions/users.dart';
import 'package:Buga/models/user.dart';
import 'package:Buga/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class LeaderBoard extends StatefulWidget {
  const LeaderBoard({super.key});

  @override
  State<LeaderBoard> createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  Future<List<User>> getdata() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 500));
    var data = await getleaders();
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Hero(
          tag: 'background',
          child: Opacity(
            opacity: 0.8,
            child: Image.asset(
              "assets/images/views/9.jpg",
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
            ),
          ),
        ),
        FutureBuilder<List<User>>(
            future: getdata(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                    child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: LinearProgressIndicator(),
                ));
              } else {
                return Container(
                    margin: const EdgeInsets.only(top: 100),
                    child: SlideAnimation4(
                      userlist: snapshot.data!,
                    ));
              }
            }),
        Positioned(
          top: 30,
          left: 0,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    iconSize: 50,
                    icon: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(2.5, 2.5),
                            blurRadius: 2.0,
                            color: Color.fromARGB(255, 62, 62, 62),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        "assets/images/icons/previous.png",
                        width: 50,
                      ),
                    ),
                  ),
                  const Text(
                    "LİDER TABLOSU",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Jost",
                      color: Colors.white,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(0.5, 0.5),
                          blurRadius: 2.0,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ],
                    ),
                  ),
                  const Center(),
                  const Center(),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class SlideAnimation4 extends StatelessWidget {
  final List<User> userlist;
  const SlideAnimation4({super.key, required this.userlist});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return AnimationLimiter(
      child: ListView.builder(
        padding: EdgeInsets.all(w / 30),
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        itemCount: userlist.length,
        itemBuilder: (BuildContext context, int index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            delay: const Duration(milliseconds: 100),
            child: SlideAnimation(
              duration: const Duration(milliseconds: 2500),
              curve: Curves.fastLinearToSlowEaseIn,
              verticalOffset: -250,
              child: ScaleAnimation(
                duration: const Duration(milliseconds: 1500),
                curve: Curves.fastLinearToSlowEaseIn,
                child: Container(
                  margin: EdgeInsets.only(bottom: w / 40),
                  height: w / 4,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "${index + 1}.",
                              style: resultstyle,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            CircleAvatar(
                              child: userlist[index].photopath!.isNotEmpty
                                  ? Image.network(userlist[index].photopath!)
                                  : Image.asset("assets/images/icons/logo.png"),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              userlist[index].displayname!.toUpperCase(),
                              style: resultstyle,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/icons/coin.png",
                              width: 20,
                            ),
                            Text(
                              userlist[index].point.toString(),
                              style: resultstyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
