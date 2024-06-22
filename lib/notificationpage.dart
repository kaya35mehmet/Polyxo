import 'package:buga/models/notifications.dart';
import 'package:buga/styles/style.dart';
import 'package:buga/widgets/profileheader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final user = FirebaseAuth.instance.currentUser;
  final List<Notifications> notifications = [
    Notifications(
        title: 'Hoş Geldiniz!',
        body: 'Uygulamamıza hoş geldiniz.',
        date: DateTime.now().subtract(const Duration(days: 1))),
    Notifications(
        title: 'Güncelleme',
        body: 'Yeni özellikler eklendi.',
        date: DateTime.now().subtract(const Duration(days: 2))),
    Notifications(
        title: 'Bildirim',
        body: 'Size özel tekliflerimiz var.',
        date: DateTime.now().subtract(const Duration(days: 3))),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5286e1),
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Bildirimler", style: title28w,),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Ink(
            height: 200,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black,
                  Colors.black87,
                  Colors.black54,
                  Color(0xFF5286e1)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              color: Colors.black38,
            ),
          ),
          ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return Card(
                margin: const EdgeInsets.all(6),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.notifications,
                    color: Colors.blue,
                    size: 30,
                  ),
                  title: Text(
                    notification.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        fontFamily: "Jost"),
                  ),
                  subtitle: Text(
                    '${notification.body}\n${DateFormat('dd MMM yyyy - hh:mm a').format(notification.date)}',
                    style: const TextStyle(fontSize: 14, fontFamily: "Jost"),
                  ),
                  isThreeLine: true,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
