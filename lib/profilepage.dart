import 'package:buga/functions/users.dart';
import 'package:buga/loginpage.dart';
import 'package:buga/styles/style.dart';
import 'package:buga/widgets/confirmdialog.dart';
import 'package:buga/widgets/profileheader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final AudioPlayer audioPlayer;
  final String? guid;
  const ProfilePage({super.key, required this.audioPlayer, required this.guid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser;

  bool music = true;
  IconData musicon = Icons.music_note;
  IconData musicoff = Icons.music_off;

  bool volume = false;
  IconData volumeon = Icons.volume_up;
  IconData volumeoff = Icons.volume_off;

  bool vibration = false;
  IconData vibrationon = Icons.vibration;
  IconData vibrationoff = Icons.vibration_outlined;

  @override
  void initState() {
    musiconoff();
    super.initState();
  }

  Future<LoginPage> _signOut() async {
    await FirebaseAuth.instance.signOut();
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
    return const LoginPage();
  }

  Future<void> musiconoff() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool msc = prefs.getBool('music') ?? true;
    setState(() {
      music = msc;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5286e1),
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              ProfileHeader(
                avatar: NetworkImage(user!.photoURL!),
                title: user!.displayName!,
                actions: <Widget>[
                  MaterialButton(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    elevation: 0,
                    child: const Icon(Icons.logout),
                    onPressed: () => _signOut(),
                  )
                ],
              ),
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
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
                            minimumSize: const Size(75, 75),
                          ),
                          onPressed: () async {
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();

                            setState(() {
                              music = !music;
                            });
                            await prefs.setBool('music', music);
                            if (music) {
                              await widget.audioPlayer
                                  .setAsset('assets/sounds/sound.mp3');
                              widget.audioPlayer.play();
                              widget.audioPlayer.setLoopMode(LoopMode.one);
                            } else {
                              widget.audioPlayer.stop();
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                music ? musicon : musicoff,
                                size: 30,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "MÜZİK",
                          style: profilechoises,
                        )
                      ],
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
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
                            minimumSize: const Size(75, 75),
                          ),
                          onPressed: () {
                            setState(() {
                              volume = !volume;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                volume ? volumeoff : volumeon,
                                size: 30,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "SES",
                          style: profilechoises,
                        )
                      ],
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
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
                            minimumSize: const Size(75, 75),
                          ),
                          onPressed: () {
                            setState(() {
                              vibration = !vibration;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                vibration ? vibrationoff : vibrationon,
                                size: 30,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "TİTREŞİM",
                          style: profilechoises,
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 80,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(
                        color: Colors.white.withOpacity(0.5), width: 1.0),
                    shadowColor: Colors.black,
                    backgroundColor:
                        const Color.fromARGB(255, 25, 28, 25).withOpacity(0.4),
                    elevation: 6.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    minimumSize: const Size(250, 60),
                  ),
                  onPressed: () {},
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.language_outlined,
                        size: 30,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        "Dil",
                        style: TextStyle(
                          fontSize: 20,
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
                      Center(),
                      Center(),
                      Center(),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(
                        color: Colors.white.withOpacity(0.5), width: 1.0),
                    shadowColor: Colors.black,
                    backgroundColor:
                        const Color.fromARGB(255, 25, 28, 25).withOpacity(0.4),
                    elevation: 6.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    minimumSize: const Size(250, 60),
                  ),
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.contacts,
                        size: 30,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        "Bize Ulaş",
                        style: profilechoises,
                      ),
                      const Center(),
                      const Center(),
                      const Center(),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(
                        color: Colors.white.withOpacity(0.5), width: 1.0),
                    shadowColor: Colors.black,
                    backgroundColor:
                        const Color.fromARGB(255, 25, 28, 25).withOpacity(0.4),
                    elevation: 6.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    minimumSize: const Size(250, 60),
                  ),
                  onPressed: _signOut,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.exit_to_app,
                        size: 30,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        "Çıkış Yap",
                        style: profilechoises,
                      ),
                      const Center(),
                      const Center(),
                      const Center(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 80,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () => showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return const ConfirmDialog();
                        },
                      ).then((value) {
                        if (value == 1) {
                          deleteaccount(widget.guid).then(
                            (value) => Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                              (Route<dynamic> route) => false,
                            ).then((value) async {
                              final SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.remove('music');
                              await prefs.remove('guid');
                            }),
                          );
                        }
                      }),
                      child: Text(
                        "Hesabı Sil",
                        style: resultstylewhite,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Kodu Kullan",
                          style: resultstylewhite,
                        ),
                        Text(
                          "Versiyon 1.0.0",
                          style: resultstylewhite,
                        ),
                        Text(
                          "Gizlilik",
                          style: resultstylewhite,
                        ),
                      ],
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
