import 'dart:async';
import 'dart:convert';
import 'package:Buga/homescreen.dart';
import 'package:Buga/matchscreen.dart';
import 'package:Buga/models/answer.dart';
import 'package:Buga/models/results.dart';
import 'package:Buga/models/user.dart' as u;
import 'package:Buga/styles/style.dart';
import 'package:Buga/widgets/letter.dart';
import 'package:Buga/widgets/roundbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({
    super.key,
    required this.answers,
    required this.remainingtime,
    required this.user,
    required this.point,
    required this.animationController,
    required this.animation,
    required this.channel,
    required this.broadcastStream,
    required this.amount,
  });
  final List<Answers> answers;
  final int remainingtime;
  final u.User user;
  final String point;
  final AnimationController animationController;
  final Animation<double> animation;
  final WebSocketChannel channel;
  final Stream broadcastStream;
  final int amount;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late StreamController<Results> _streamController;
  // final WebSocketChannel channel =
  //     IOWebSocketChannel.connect('ws://213.142.151.21:3000/message');

  int trueCount = 0;
  int falseCount = 0;
  String? guid;
  String username = "";
  int point = 0;
  int rivalpoint = 0;

  @override
  void initState() {
    point = int.parse(widget.point);
    username = FirebaseAuth.instance.currentUser!.email!;
    _streamController = StreamController<Results>();
    trueCount = widget.answers
        .where((element) => element.answer == true)
        .toList()
        .length;
    falseCount = widget.answers
        .where((element) => element.answer == false)
        .toList()
        .length;
    super.initState();
    getguid();
    getanswers();
    Wakelock.enable();
    widget.broadcastStream.listen((message) {
      final data = jsonDecode(message);
      Results results = Results.fromJson(data);
      if (results.page == "result") {
        setState(() {
          _streamController.add(results);
        });
        var rivaltrueCount = results.answers!
            .where((element) => element.answer == true)
            .toList()
            .length;
        calc(trueCount, widget.remainingtime, rivaltrueCount,
            int.parse(results.remainingtime!));
        widget.channel.sink.close();
      }
    });
  }

  getguid() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? action = prefs.getString('guid');
    guid = action;
  }

  getanswers() async {
    await Future<dynamic>.delayed(
            Duration(milliseconds: widget.remainingtime * 1000))
        .then((value) {
      List<Map<String, dynamic>> answerlist =
          widget.answers.map((x) => x.toMap()).toList();
      var json = jsonEncode({
        "page": "result",
        "guid": guid,
        "rivalguid": widget.user.guid,
        "remainingtime": widget.remainingtime.toString(),
        'answers': answerlist,
      });
      widget.channel.sink.add(json);
    });
  }

  calc(tcount, rtime, rtcount, rrtime) {
    var result = "";
    if (tcount > rtcount) {
      result = "KAZANDINIZ";
      setState(() {
        point = point + widget.amount;
        rivalpoint = rivalpoint - widget.amount;
      });
    } else if (tcount == rtcount) {
      if (rtime > rrtime) {
        result = "KAZANDINIZ";
        setState(() {
          point = point + widget.amount;
          rivalpoint = rivalpoint - widget.amount;
        });
      } else if (rtime == rrtime) {
        result = "BERABERE KALDINIZ";
      } else {
        result = "KAYBETTİNİZ";
        setState(() {
          point = point - widget.amount;
          rivalpoint = rivalpoint + widget.amount;
        });
      }
    } else {
      result = "KAYBETTİNİZ";
      setState(() {
        point = point - widget.amount;
        rivalpoint = rivalpoint + widget.amount;
      });
    }
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(result),
            content: Text(result),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Kapat'),
              ),
            ],
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentuser = FirebaseAuth.instance.currentUser;
    var screenWidth = MediaQuery.of(context).size.width;
    // var screenHeight = MediaQuery.of(context).size.height;
    // var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      body: StreamBuilder<Results>(
          stream: _streamController.stream,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Stack(
                children: [
                  Opacity(
                    opacity: 0.8,
                    child: Image.asset(
                      "assets/images/views/4.jpg",
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const LinearProgressIndicator(),
                          const SizedBox(
                            height: 10,
                          ),
                          Text("Sonuçlar yükleniyor", style: resultstylewhite)
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              var rivaltrueCount = snapshot.data!.answers!
                  .where((element) => element.answer == true)
                  .toList()
                  .length;
              var rivalfalseCount = snapshot.data!.answers!
                  .where((element) => element.answer == false)
                  .toList()
                  .length;
              rivalpoint = widget.user.point!;
              return Stack(
                children: [
                  Opacity(
                    opacity: 0.8,
                    child: Image.asset(
                      "assets/images/views/4.jpg",
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    color: Colors.black12,
                    padding: const EdgeInsets.all(0),
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 00),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            AnimCard(
                                currentuser!.photoURL!,
                                trueCount,
                                falseCount,
                                widget.remainingtime.toString(),
                                widget.answers,
                                200,
                                100),
                            const SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                        width:
                                            MediaQuery.of(context).size.width / 2 -
                                                50,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: const Color.fromARGB(115, 250, 250, 250)),
                                        ),
                                      ),
                                  Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey[800]!,
                                            blurRadius: 10.0,
                                          ),
                                        ]),
                                    child: Image.asset(
                                      "assets/images/icons/vs.png",
                                      width: 50,
                                    ),
                                  ),
                                  Container(
                                        width:
                                            MediaQuery.of(context).size.width / 2 -
                                                50,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: const Color.fromARGB(115, 250, 250, 250)),
                                        ),
                                      ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            AnimCard(
                                widget.user.photopath!,
                                rivaltrueCount,
                                rivalfalseCount,
                                snapshot.data!.remainingtime!,
                                snapshot.data!.answers!,
                                100,
                                0),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 20,
                    child: SizedBox(
                      width: screenWidth - 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RoundIconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(),
                                ),
                              );
                            },
                            size: 40,
                            icon: Icons.close,
                          ),
                          Container(
                            width: 90,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset(
                                  "assets/images/icons/coin.png",
                                  width: 30,
                                ),
                                Text(
                                  "$point",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 40,
                    left: 20,
                    child: SizedBox(
                      width: screenWidth - 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey[800]!,
                                    blurRadius: 10.0,
                                  ),
                                ]),
                            child: IconButton(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil<void>(
                                  context,
                                  MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          MatchScreen(
                                            guid: guid!,
                                            point: widget.point,
                                            animation: widget.animation,
                                            animationController:
                                                widget.animationController,
                                            amount: widget.amount,
                                          )),
                                  ModalRoute.withName('/'),
                                );
                              },
                              iconSize: 60,
                              icon:
                                  Image.asset("assets/images/icons/reload.png"),
                            ),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey[800]!,
                                    blurRadius: 5.0,
                                  ),
                                ]),
                            child: IconButton(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil<void>(
                                  context,
                                  MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          const HomeScreen()),
                                  ModalRoute.withName('/'),
                                );
                              },
                              iconSize: 60,
                              icon: Image.asset("assets/images/icons/home.png"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          }),
    );
  }
}
