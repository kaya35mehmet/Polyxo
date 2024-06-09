import 'dart:async';
import 'dart:convert';
import 'package:buga/homescreen.dart';
import 'package:buga/models/user.dart';
import 'package:buga/resultpage.dart';
import 'package:buga/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:buga/widgets/gamewidgets/gesture.dart';
import 'package:buga/models/answer.dart';
import 'package:buga/models/dictionary.dart';
import 'package:wakelock/wakelock.dart';
// import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class GameScreen extends StatefulWidget {
  final List<Dictionary> dlist;
  final User user;
  final String guid;
  final String point;
  final AnimationController animationController;
  final Animation<double> animation;
  final WebSocketChannel channel;
  final Stream broadcastStream;
  final int amount;
  const GameScreen(
      {super.key,
      required this.dlist,
      required this.user,
      required this.guid,
      required this.point,
      required this.animationController,
      required this.animation,
      required this.channel,
      required this.broadcastStream,
      required this.amount});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _animationController;

  late List<String> letters = [];
  late List<String> shuffleletters = [];
  List<Dictionary> list = [];
  List<String> pathArr = [];
  final items = [];
  int lindex = 0;
  String question = "";
  List<Answers> answers = [];
  int _secondsRemaining = 59;
  late Timer _timer;
  late Future<bool> ftstart;
  bool start = false;
  double _progress = 1.0;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
          if (_progress > 0) {
            _progress -= 1 / 60;
            if (_progress < 0) {
              _progress = 0;
            }
          }
        } else {
          _stopTimer();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ResultScreen(
                answers: answers,
                remainingtime: _secondsRemaining,
                user: widget.user,
                point: widget.point,
                animation: widget.animation,
                animationController: widget.animationController,
                channel: widget.channel,
                broadcastStream: widget.broadcastStream,
                amount: widget.amount,
              ),
            ),
          );
        }
      });
    });
  }

  void _stopTimer() {
    _timer.cancel();
  }

  bool areListsEqual(List<dynamic> list1, List<dynamic> list2) {
    if (list1.length != list2.length) {
      return false;
    }

    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) {
        return false;
      }
    }
    return true;
  }

  Future<void> checkRival() async {
    widget.channel.sink.add(jsonEncode({
      "page": "game",
      "guid": widget.guid,
      "username": widget.user.displayname,
      "rivalguid": widget.user.guid,
      "rivalisbot": widget.user.rivalisbot,
    }));
  }

  @override
  void initState() {
    startgame();
    list = widget.dlist;
    siradaki();
    super.initState();
    answers = List<Answers>.generate(
      10,
      (index) => Answers(answer: false, question: list[index].word),
    );
    Wakelock.enable();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    checkRival();
    // WidgetsBinding.instance.addObserver(this);
    widget.broadcastStream.listen((message) {
      final data = jsonDecode(message);

      if (data == "abandon") {
        widget.channel.sink.close();
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.black.withOpacity(0.7),
                title: const Text('KAZANDINIZ'),
                content: const Text('Rakibiniz oyunu terk etti.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil<void>(
                        context,
                        MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const HomeScreen()),
                        ModalRoute.withName('/'),
                      );
                    },
                    child: const Text('Kapat'),
                  ),
                ],
              );
            });
      } else {
        setState(() {
          _secondsRemaining = data;
          start = true;
        });
      }
    });
  }

  startgame() async {
    ftstart = getData();
  }

  siradaki() async {
    if (lindex == 10) {
      if (_secondsRemaining == 0) {
        await Future<dynamic>.delayed(
                Duration(milliseconds: _secondsRemaining * 1000))
            .then((value) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ResultScreen(
                answers: answers,
                remainingtime: _secondsRemaining,
                user: widget.user,
                point: widget.point,
                animation: widget.animation,
                animationController: widget.animationController,
                channel: widget.channel,
                broadcastStream: widget.broadcastStream,
                amount: widget.amount,
              ),
            ),
          );
        });
      } else {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return  AlertDialog(
                backgroundColor: Colors.black.withOpacity(0.7),
                content: Text('Rakibinizin oyunu bitirmesi bekleniyor.', style: title28w, textAlign: TextAlign.center,),
              );
            });
      }
    } else {
      pathArr.clear();
      setState(() {
        letters = list[lindex].word.toUpperCase().split("").toList();
        shuffleletters = list[lindex].word.toUpperCase().split("").toList();
        question = list[lindex].meaning;
        shuffleletters.shuffle();

        for (var element in letters) {
          for (var i = 0; i < element.length; i++) {
            pathArr.add("");
          }
        }
      });
    }
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 500));
    _startTimer();
    return true;
  }

  @override
  void dispose() {
    // WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);
  //   if (state == AppLifecycleState.inactive) {
  //     // channel.stream.listen((message) {});
  //     widget.channel.sink.close();
  //   } else if (state == AppLifecycleState.resumed) {
  //     Navigator.pop(context);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          bool confirm = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Uyarı'),
              content:
                  const Text('Yarışmadan çıkmak istediğinize emin misiniz?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Hayır'),
                ),
                TextButton(
                  onPressed: () {
                    widget.channel.sink.close();
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Evet'),
                ),
              ],
            ),
          );
          return confirm;
        },
        child: FutureBuilder<Object>(
            future: ftstart,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Stack(
                  children: [
                    Image.asset(
                      "assets/images/views/9.jpg",
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      fit: BoxFit.cover,
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              LinearProgressIndicator(),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                );
              } else {
                return Stack(
                  children: [
                    Image.asset(
                      "assets/images/views/12.jpg",
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      fit: BoxFit.cover,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          margin: const EdgeInsets.all(40),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color.fromARGB(255, 11, 10, 10)
                                .withOpacity(0.8),
                          ),
                          child: Center(
                            child: Text(
                              "$_secondsRemaining",
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 235, 233, 233),
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: screenWidth * 0.92,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Stack(
                                        children: [
                                          Container(
                                            alignment: Alignment.topCenter,
                                            margin:
                                                const EdgeInsets.only(top: 0),
                                            width: screenWidth * 0.5,
                                            height: 24,
                                            decoration:  BoxDecoration(
                                              color: mainColor,
                                              borderRadius: const BorderRadius.only(
                                                bottomRight:
                                                    Radius.circular(10),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "SORULAR   ",
                                                  style: answer14,
                                                ),
                                                Text(
                                                  "${lindex + 1}/10",
                                                  style: answer14,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Center(
                                            child: Text(
                                              question.toUpperCase(),
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 26,
                                                  fontFamily: 'Jost'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 0,
                            ),
                          ],
                        ),
                        Stack(
                          children: [
                            pathArr[0] != ""
                                ? Container(
                                    margin: const EdgeInsets.only(top: 0),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF1fb109),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                          ),
                                          padding: const EdgeInsets.all(10),
                                          height: 60,
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: shuffleletters.length,
                                            itemBuilder: (context, index) {
                                              _animationController.forward();
                                              return FadeTransition(
                                                opacity: _animationController,
                                                child: Center(
                                                  child: pathArr[index] == ""
                                                      ? Text(
                                                          pathArr[index],
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 30,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontFamily:
                                                                      "",
                                                                  color: Colors
                                                                      .white),
                                                        )
                                                      : FadeTransition(
                                                          opacity:
                                                              _animationController,
                                                          child: Text(
                                                            pathArr[index],
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 30,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  "Jost",
                                                              color:
                                                                  Colors.white,
                                                              shadows: <Shadow>[
                                                                Shadow(
                                                                  offset:
                                                                      Offset(
                                                                          0.5,
                                                                          0.5),
                                                                  blurRadius:
                                                                      2.0,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : const Center(),
                            Center(
                              child: Container(
                                width: screenWidth * 0.65,
                                margin: const EdgeInsets.only(left: 0, top: 30),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                                child: Column(
                                  children: [
                                    shuffleletters.length == 7
                                        ? GestureView(
                                            width: screenWidth - 80,
                                            height: screenWidth,
                                            letters: shuffleletters,
                                            listener2: (val) {
                                              if (val == false) {
                                                setState(() {
                                                  for (var i = 0;
                                                      i < shuffleletters.length;
                                                      i++) {
                                                    pathArr[i] = "";
                                                  }
                                                });
                                              }
                                            },
                                            listener: (arr, index) {
                                              setState(() {
                                                switch (arr) {
                                                  case 1:
                                                    pathArr[index] =
                                                        shuffleletters[
                                                            arr - 1]; //0
                                                    break;
                                                  case 5:
                                                    pathArr[index] =
                                                        shuffleletters[
                                                            arr - 4]; //1
                                                    break;
                                                  case 7:
                                                    pathArr[index] =
                                                        shuffleletters[
                                                            arr - 5]; //2
                                                    break;
                                                  case 9:
                                                    pathArr[index] =
                                                        shuffleletters[
                                                            arr - 6]; //3
                                                    break;
                                                  case 11:
                                                    pathArr[index] =
                                                        shuffleletters[
                                                            arr - 7]; //4
                                                    break;
                                                  case 13:
                                                    pathArr[index] =
                                                        shuffleletters[
                                                            arr - 8]; //5
                                                  case 14:
                                                    pathArr[index] =
                                                        shuffleletters[
                                                            arr - 8]; //6
                                                    break;
                                                }
                                              });
                                              bool check = areListsEqual(
                                                  letters, pathArr);

                                              if (index == 6) {
                                                setState(() {
                                                  lindex++;
                                                });
                                                Future.delayed(
                                                    const Duration(
                                                        milliseconds: 500), () {
                                                  siradaki();
                                                  if (check) {
                                                    setState(() {
                                                      answers[lindex - 1]
                                                          .answer = true;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      answers[lindex - 1]
                                                          .answer = false;
                                                    });
                                                  }
                                                });
                                              }
                                            },
                                          )
                                        : const Center(),
                                    shuffleletters.length == 6
                                        ? GestureView(
                                            width: screenWidth - 80,
                                            height: screenWidth,
                                            letters: shuffleletters,
                                            listener2: (val) {
                                              if (val == false) {
                                                setState(() {
                                                  for (var i = 0;
                                                      i < shuffleletters.length;
                                                      i++) {
                                                    pathArr[i] = "";
                                                  }
                                                });
                                              }
                                            },
                                            listener: (arr, index) {
                                              setState(() {
                                                _animationController.forward();
                                                // pathArr2.add(index);
                                                switch (arr) {
                                                  case 3:
                                                    pathArr[index] =
                                                        shuffleletters[arr - 1];
                                                    break;
                                                  case 5:
                                                  case 6:
                                                  case 7:
                                                    pathArr[index] =
                                                        shuffleletters[arr - 2];
                                                    break;
                                                  default:
                                                    pathArr[index] =
                                                        shuffleletters[arr];
                                                }
                                              });
                                              bool check = areListsEqual(
                                                  letters, pathArr);
                                              if (index == 5) {
                                                setState(() {
                                                  lindex++;
                                                });
                                                Future.delayed(
                                                    const Duration(
                                                        milliseconds: 500), () {
                                                  siradaki();
                                                  if (check) {
                                                    setState(() {
                                                      answers[lindex - 1]
                                                          .answer = true;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      answers[lindex - 1]
                                                          .answer = false;
                                                    });
                                                  }
                                                });
                                              }
                                            },
                                          )
                                        : const Center(),
                                    shuffleletters.length == 5
                                        ? GestureView(
                                            width: screenWidth - 80,
                                            height: screenWidth,
                                            letters: shuffleletters,
                                            listener2: (val) {
                                              if (val == false) {
                                                setState(() {
                                                  for (var i = 0;
                                                      i < shuffleletters.length;
                                                      i++) {
                                                    pathArr[i] = "";
                                                  }
                                                });
                                              }
                                            },
                                            listener: (arr, index) {
                                              setState(() {
                                                // pathArr2.add(index);
                                                switch (arr) {
                                                  case 1:
                                                  case 2:
                                                  case 3:
                                                    pathArr[index] =
                                                        shuffleletters[arr - 2];
                                                    break;
                                                  case 5:
                                                  case 6:
                                                  case 7:
                                                    pathArr[index] =
                                                        shuffleletters[arr - 3];
                                                    break;
                                                  default:
                                                    pathArr[index] =
                                                        shuffleletters[arr];
                                                }
                                              });
                                              bool check = areListsEqual(
                                                  letters, pathArr);

                                              if (index == 4) {
                                                setState(() {
                                                  lindex++;
                                                });
                                                Future.delayed(
                                                    const Duration(
                                                        milliseconds: 500), () {
                                                  siradaki();
                                                  if (check) {
                                                    setState(() {
                                                      answers[lindex - 1]
                                                          .answer = true;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      answers[lindex - 1]
                                                          .answer = false;
                                                    });
                                                  }
                                                });
                                              }
                                            },
                                          )
                                        : const Center(),
                                    shuffleletters.length == 4
                                        ? GestureView(
                                            width: screenWidth - 80,
                                            height: screenWidth,
                                            letters: shuffleletters,
                                            listener2: (val) {
                                              if (val == false) {
                                                setState(() {
                                                  for (var i = 0;
                                                      i < shuffleletters.length;
                                                      i++) {
                                                    pathArr[i] = "";
                                                  }
                                                });
                                              }
                                            },
                                            listener: (arr, index) {
                                              setState(() {
                                                // pathArr2.add(index);
                                                switch (arr) {
                                                  case 1:
                                                  case 2:
                                                  case 3:
                                                    pathArr[index] =
                                                        shuffleletters[arr - 2];
                                                    break;
                                                  case 5:
                                                  case 6:
                                                    pathArr[index] =
                                                        shuffleletters[arr - 3];
                                                    break;
                                                  default:
                                                    pathArr[index] =
                                                        shuffleletters[arr];
                                                }
                                              });
                                              bool check = areListsEqual(
                                                  letters, pathArr);

                                              if (index == 3) {
                                                setState(() {
                                                  lindex++;
                                                });
                                                Future.delayed(
                                                    const Duration(
                                                        milliseconds: 500), () {
                                                  siradaki();
                                                  if (check) {
                                                    setState(() {
                                                      answers[lindex - 1]
                                                          .answer = true;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      answers[lindex - 1]
                                                          .answer = false;
                                                    });
                                                  }
                                                });
                                              }
                                            },
                                          )
                                        : const Center(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: screenWidth * 0.65,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(0),
                            side: BorderSide(
                                color: Colors.white.withOpacity(0.5),
                                width: 1.0),
                            shadowColor: Colors.black,
                            backgroundColor:
                                const Color.fromARGB(255, 25, 28, 25)
                                    .withOpacity(0.4),
                            elevation: 6.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            minimumSize: const Size(60, 60),
                          ),
                          onPressed: () async {
                            setState(() {
                              shuffleletters.shuffle();
                            });
                          },
                          child: const Icon(
                            Icons.shuffle,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: screenWidth * 0.65,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(0),
                            side: BorderSide(
                                color: Colors.white.withOpacity(0.5),
                                width: 1.0),
                            shadowColor: Colors.black,
                            backgroundColor:
                                const Color.fromARGB(255, 25, 28, 25)
                                    .withOpacity(0.4),
                            elevation: 6.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            minimumSize: const Size(60, 60),
                          ),
                          onPressed: () async {
                            setState(() {
                              if (lindex < 10) {
                                lindex++;
                              }
                              siradaki();
                              answers[lindex - 1].answer = false;
                              answers[lindex - 1].question =
                                  list[lindex - 1].word;
                            });
                          },
                          child: const Icon(
                            Icons.next_plan_outlined,
                            size: 60,
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
                            IconButton(
                              onPressed: () async {
                                await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Uyarı'),
                                    content: const Text(
                                        'Yarışmadan çıkmak istediğinize emin misiniz?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: const Text('Hayır'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          widget.channel.sink.close();
                                          Navigator.pushAndRemoveUntil<void>(
                                            context,
                                            MaterialPageRoute<void>(
                                                builder:
                                                    (BuildContext context) =>
                                                        const HomeScreen()),
                                            ModalRoute.withName('/'),
                                          );
                                        },
                                        child: const Text('Evet'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              iconSize: 50,
                              icon: Image.asset(
                                "assets/images/icons/previous.png",
                                width: 50,
                              ),
                            ),
                            Container(
                              width: 90,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset(
                                    "assets/images/icons/gold.png",
                                    width: 30,
                                  ),
                                  Text(
                                    widget.point,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      width: screenWidth,
                      height: 10,
                      bottom: 0,
                      child: LinearProgressIndicator(
                        color: mainColor,
                        backgroundColor: Colors.grey[200],
                        value: _progress,
                      ),
                    ),
                  ],
                );
              }
            }),
      ),
    );
  }
}
