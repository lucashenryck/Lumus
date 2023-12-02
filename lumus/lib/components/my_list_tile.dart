import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        leading: Icon(
          icon,
          color: Color.fromRGBO(240, 240, 240, 1),
          size: 30
        ),
      onTap: onTap,
      title:Text(
          text,
          style: GoogleFonts.dmSans(
                    color: Color.fromRGBO(240, 240, 240, 1),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
        ),
      ),
    );
  }
}