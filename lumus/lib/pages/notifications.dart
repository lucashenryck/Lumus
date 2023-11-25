import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(19, 32, 67, 1),
      appBar: AppBar(
        leading: const BackButton(),
        backgroundColor: Color.fromRGBO(19, 32, 67, 1),
        elevation: 0,
      ),
    );
  }
}