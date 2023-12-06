import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  const MyButton({
    super.key, 
    required this.onTap, 
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 150,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Color.fromRGBO(240, 240, 240, 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              text, 
              style: GoogleFonts.dmSans(
                color: Color.fromRGBO(3, 21, 37, 1),
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            )
          ),
        ),
      ),
    );
  }
}