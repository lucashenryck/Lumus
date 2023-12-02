import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NumberWidget extends StatefulWidget {
  NumberWidget({super.key, required this.followers, required this.following});

  int followers = 0;
  int following = 0;

  @override
  State<NumberWidget> createState() => _NumberWidgetState();
}

class _NumberWidgetState extends State<NumberWidget> {
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget> [
      buildButton(text: 'Seguindo', number: widget.following),
      buildButton(text: 'Seguidores', number: widget.followers),
    ],
  );

  Widget buildButton({
    required String text,
    required int number
  }) =>
      TextButton(
          onPressed: (){},
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget> [
              Text(
                '$number ',
                style: GoogleFonts.dmSans(
                  color: Color.fromRGBO(240, 240, 240, 1),
                  fontSize: 15,
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(width: 2),
              Text(
                text,
                style: GoogleFonts.dmSans(
                  color: Color.fromRGBO(240, 240, 240, 1),
                  fontSize: 15,
                ),
              ),
            ],
          ),
      );
}