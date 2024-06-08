import 'dart:async';
import 'dart:developer' as developer;
import 'package:buga/homescreen.dart';
import 'package:buga/loginpage.dart';
import 'package:buga/models/firebase_auth.dart';
import 'package:buga/widgets/logo.dart';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> connectivitySubscription;
  String status = "Yükleniyor";
  @override
  void initState() {
    super.initState();
    initConnectivity();
    connectivitySubscription =
        connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
    if (_connectionStatus == ConnectivityResult.none) {
      setState(() {
        status = "İnternet bağlantısı yok";
      });
      await Future<dynamic>.delayed(
          const Duration(milliseconds: 2000), () => SystemNavigator.pop());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BUGA',
      home: FlutterSplashScreen.fadeIn(
        animationDuration: const Duration(milliseconds: 1000),
        animationCurve : Curves.easeInCubic,
        backgroundColor: Colors.white,
        onInit: () {
          debugPrint("On Init");
        },
        onEnd: () {
          debugPrint("On End");
        },
        childWidget: SizedBox(
          child: Stack(
            children: [
              Opacity(
                opacity: 0.8,
                child: Image.asset(
                  "assets/images/views/9.jpg",
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(
                    height: 0,
                  ),
                  const Logo(),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      Text(
                        status,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Jost",
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(0.5, 0.5),
                              blurRadius: 20.0,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: LinearProgressIndicator(
                          color: Color(0xFF1fb109),
                          backgroundColor: Color(0xFF1fb109),
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Color.fromARGB(255, 129, 244, 111)),
                          minHeight: 10,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ],
          ),
        ),
        onAnimationEnd: () => debugPrint("On Fade In End"),
        nextScreen: ChangeNotifierProvider(
          create: (context) => GoogleSignInProvider(),
          child: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (kDebugMode) {
                print(snapshot);
              }
              final provider = Provider.of<GoogleSignInProvider>(context);
              if (provider.isSigningIn) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                if (kDebugMode) {
                  print(snapshot);
                }
                return const HomeScreen();
              } else {
                return const LoginPage();
              }
            },
          ),
        ),
      ),
    );
  }
}