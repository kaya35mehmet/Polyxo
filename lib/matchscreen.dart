import 'dart:async';
import 'dart:convert';
import 'package:Buga/models/dictionary.dart';
import 'package:Buga/models/user.dart';
import 'package:Buga/gamescreen.dart';
import 'package:Buga/widgets/raipple.dart';
import 'package:firebase_auth/firebase_auth.dart' as f;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:web_socket_channel/io.dart';

class MatchScreen extends StatefulWidget {
  final String guid;
  final String point;
  final int amount;
  final AnimationController animationController;
  final Animation<double> animation;
  const MatchScreen(
      {super.key,
      required this.guid,
      required this.point,
      required this.animationController,
      required this.animation,
      required this.amount});

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late StreamController<User> _streamController;
  late WebSocketChannel channel;
  late Stream broadcastStream;
  int _secondsRemaining = 3;
  late Timer _timer;
  List<Dictionary> list = [];
  late User user;
  String username = "";
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    String url = 'ws://213.142.151.21:3${widget.amount}/message';

    Wakelock.enable();
    username = f.FirebaseAuth.instance.currentUser!.email!;
    _streamController = StreamController<User>();
    getData();
    super.initState();
    channel = WebSocketChannel.connect(
      Uri.parse(url),
    );
    broadcastStream = channel.stream.asBroadcastStream();
    broadcastStream.listen((message) {
      if (kDebugMode) {
        print('Received: $message');
      }
      if (message == 'match_found') {}
    });
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
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
    WidgetsBinding.instance.addObserver(this);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _stopTimer();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => GameScreen(
                dlist: list,
                user: user,
                guid: widget.guid,
                point: widget.point,
                animation: widget.animation,
                animationController: widget.animationController,
                channel: channel,
                broadcastStream: broadcastStream,
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
    setState(() {
      _secondsRemaining = 3;
    });
  }

  Future<void> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 1000));
    channel.sink.add(jsonEncode({
      "page": "match",
      "username": username,
      'guid': widget.guid,
    }));

    broadcastStream.listen((message) {
      final data = jsonDecode(message);

      if (data != null) {
        user = User(
            email: data["player"]["email"].toString(),
            guid: data["player"]["guid"].toString(),
            id: 0,
            photopath: data["player"]["photopath"].toString(),
            point: data["player"]["point"],
            rivalisbot: data["player"]["rivalisbot"],
            displayname: data["player"]["displayname"] ??
                data["player"]["email"].toString());
          
        Iterable res = data["words"];
        list = res.map((e) => Dictionary.fromMap(e)).toList();

        setState(() {
          _streamController.add(user);
        });
        // channel.sink.close();
        _startTimer();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      channel.sink.close();
    } else if (state == AppLifecycleState.resumed) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          channel.sink.close();
          return true;
        },
        child: Stack(
          children: [
            Opacity(
              opacity: 0.8,
              child: Image.asset(
                "assets/images/views/11.jpg",
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.black12,
              child: StreamBuilder<User>(
                  stream: _streamController.stream,
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 100,
                              ),
                              Stack(
                                children: [
                                  Center(
                                    child: CustomPaint(
                                      painter: RipplePainter(_animation.value),
                                      child: Center(
                                        child: CircleAvatar(
                                          radius: 50,
                                          backgroundImage: NetworkImage(f
                                              .FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .photoURL!),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 100,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "Rakip bekleniyor..",
                                style: TextStyle(
                                  fontFamily: 'Jost',
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  shadows: <Shadow>[
                                    Shadow(
                                      offset: Offset(4.0, 4.0),
                                      blurRadius: 5.0,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    } else {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: Stack(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                   Center(
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundImage: NetworkImage(f.FirebaseAuth
                                            .instance.currentUser!.photoURL!),
                                      ),
                                    ),
                                  
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  Row(
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
                                  const SizedBox(
                                    height: 40,
                                  ),
                                   Center(
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundImage: NetworkImage(
                                          snapshot.data!.photopath!,
                                        ),
                                      ),
                                    ),
                                  
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width - 40,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Yarışma Başlıyor",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        shadows: <Shadow>[
                                          Shadow(
                                            offset: Offset(4.0, 4.0),
                                            blurRadius: 5.0,
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          ),
                                        ],
                                      ),
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
                                            color: const Color.fromARGB(
                                                    255, 11, 10, 10)
                                                .withOpacity(0.8),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "$_secondsRemaining",
                                              style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 235, 233, 233),
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
