import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final void Function()? onTap;
  const MyListTile({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
    });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListTile(
        leading: Icon(
          icon,
          color: Color.fromRGBO(240, 240, 240, 1),
          size: 30
        ),
      onTap: onTap,
      title:Text(
          text,
          style: TextStyle(
            color: Color.fromRGBO(240, 240, 240, 1),
            fontSize: 18
          ),
        ),
      ),
    );
  }
}