import 'package:buga/functions/login.dart';
import 'package:buga/functions/users.dart';
import 'package:buga/leaderboard.dart';
import 'package:buga/loginpage.dart';
import 'package:buga/profilepage.dart';
import 'package:buga/shopscreen.dart';
import 'package:buga/styles/style.dart';
import 'package:buga/widgets/button.dart';
import 'package:buga/widgets/fortunewheel.dart';
import 'package:buga/widgets/gift.dart';
import 'package:buga/widgets/logo.dart';
import 'package:buga/widgets/raipple.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  List<int>? pathArr;
  String? guid;
  String? point;
  late AudioPlayer _audioPlayer;
  DateTime? gift;
  DateTime? fortunewheel;

  Future<void> _playAudio() async {
    try {
      await _audioPlayer.setAsset('assets/sounds/sound.mp3');
      _audioPlayer.play();
      _audioPlayer.setLoopMode(LoopMode.one);
    } catch (e) {
      if (kDebugMode) {
        print("An error occurred $e");
      }
    }
  }

  void playAudio() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool music = prefs.getBool('music') ?? true;
    if (music) {
      _playAudio();
    }
  }

  @override
  void initState() {
    getguid();
    getpoint();
    super.initState();
    _audioPlayer = AudioPlayer();
    playAudio();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _animation = Tween<double>(begin: 0, end: 3).animate(_animationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          _animationController.forward();
        } else if (status == AnimationStatus.completed) {
          _animationController.repeat();
        }
      });

    _animationController.forward();
  }

  getpoint() async {
    var data = await getuser();
    setState(() {
      point = data.point!.toString();
      gift = data.gift;
      fortunewheel = data.fortunewheel;
    });
  }

  getguid() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? action = prefs.getString('guid');

    if (action == null) {
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
        (Route<dynamic> route) => false,
      );
    } else {
      setState(() {
        guid = action;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> showFortuneWheel() async {
    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return FortuneWheel(
          date: fortunewheel!,
        );
      },
    ).then((value) async {
      int val = value as int;
      int point2 = int.parse(point!);
      for (var i = 0; i <= val; i++) {
        await Future<dynamic>.delayed(const Duration(milliseconds: 5), () {
          setState(() {
            point = (point2++).toString();
            fortunewheel = DateTime.now();
          });
        });
      }
      if (kDebugMode) {
        print(point);
      }
      updatefortunewheel(guid, point).then((value) => getpoint());
      // getpoint();
    });
  }

  Future<void> showGift() async {
    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return GiftScreen(
          date: gift!,
        );
      },
    ).then((value) async {
      int val = value as int;
      int point2 = int.parse(point!);
      for (var i = 0; i <= val; i++) {
        await Future<dynamic>.delayed(const Duration(milliseconds: 5), () {
          setState(() {
            point = (point2++).toString();
            gift = DateTime.now();
          });
        });
      }
      updategift(guid, point).then((value) => getpoint());
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Logo(),
              const SizedBox(
                height: 50,
              ),
              Stack(
                children: [
                  Center(
                    child: CustomPaint(
                      painter: RipplePainter(_animation.value),
                      child: Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(user!.photoURL!),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 80,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80.0),
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.black,
                      backgroundColor: const Color(0xFF1fb109),
                      elevation: 6.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      minimumSize: const Size(250, 60),
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                "RİSK",
                                textAlign: TextAlign.center,
                                style: title24,
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Button(
                                    amount: 100,
                                    guid: guid!,
                                    point: point!,
                                    animation: _animation,
                                    animationController: _animationController,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Button(
                                    amount: 200,
                                    guid: guid!,
                                    point: point!,
                                    animation: _animation,
                                    animationController: _animationController,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Button(
                                    amount: 500,
                                    guid: guid!,
                                    point: point!,
                                    animation: _animation,
                                    animationController: _animationController,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.play_arrow,
                          size: 40,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          "OYNA",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Jost",
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(0.5, 0.5),
                                blurRadius: 2.0,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
          Positioned(
            top: 50,
            left: 20,
            child: SizedBox(
              width: screenWidth - 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ShopScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
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
                          const SizedBox(
                            width: 6,
                          ),
                          Text(
                            point ?? "Loading",
                            style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                                fontFamily: 'Jost'),
                          )
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                      side: BorderSide(
                          color: Colors.white.withOpacity(0.5), width: 1.0),
                      shadowColor: Colors.black,
                      backgroundColor: const Color.fromARGB(255, 25, 28, 25)
                          .withOpacity(0.4),
                      elevation: 6.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      minimumSize: const Size(50, 50),
                    ),
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(
                            audioPlayer: _audioPlayer,
                            guid: guid!,
                          ),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.settings,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            child: SizedBox(
              width: screenWidth,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(0),
                          side: BorderSide(
                              color: Colors.white.withOpacity(0.5), width: 1.0),
                          shadowColor: Colors.black,
                          backgroundColor: const Color.fromARGB(255, 25, 28, 25)
                              .withOpacity(0.4),
                          elevation: 6.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          minimumSize: const Size(50, 50),
                        ),
                        onPressed: () async {
                          showGift();
                        },
                        child: Image.asset(
                          "assets/images/icons/gift.png",
                          width: 30,
                        )),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                        side: BorderSide(
                            color: Colors.white.withOpacity(0.5), width: 1.0),
                        shadowColor: Colors.black,
                        backgroundColor: const Color.fromARGB(255, 25, 28, 25)
                            .withOpacity(0.4),
                        elevation: 6.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        minimumSize: const Size(50, 50),
                      ),
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ShopScreen(),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.shopping_cart,
                        size: 30,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                        side: BorderSide(
                            color: Colors.white.withOpacity(0.5), width: 1.0),
                        shadowColor: Colors.black,
                        backgroundColor: const Color.fromARGB(255, 25, 28, 25)
                            .withOpacity(0.4),
                        elevation: 6.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        minimumSize: const Size(50, 50),
                      ),
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LeaderBoard(),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.leaderboard,
                        size: 30,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showFortuneWheel().then((value) {
                          // updatefortunewheel(guid, point).then((value) => getpoint());
                        });
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
                          "assets/images/icons/fortunewheel.png",
                          width: 50,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
