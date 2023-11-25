import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyStatistics extends StatelessWidget {
  const MyStatistics({super.key});

  @override
  Widget build(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget> [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: buildButton(text: 'Assistidos', number: 124),
          ),
          buildDivider(),
          Expanded(
            child: buildButton(text: 'Watchlist', number: 24),
          ),
          buildDivider(),
          Expanded(
            child: buildButton(text: 'Listas', number: 7),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: buildButton(text: 'Reviews', number: 85),
          ),
          buildDivider(),
          Expanded(
            child: buildButton(text: 'Curtidos', number: 120),
          ),
        ],
      ),
    ],
  );

  Widget buildDivider() => Container(
    height: 40,
    child: VerticalDivider(
      width: 1,
    ),
    color: Color.fromRGBO(240, 240, 240, 1),
  );

  Widget buildButton({
    required String text,
    required int number,
  }) =>
      MaterialButton(
        padding: EdgeInsets.symmetric(vertical: 4),
        onPressed: (){},
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget> [
            Text(
              '$number ',
              style: GoogleFonts.dmSans(
                color: Color.fromRGBO(240, 240, 240, 1),
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              text,
              style: GoogleFonts.dmSans(
                color: Color.fromRGBO(240, 240, 240, 1),
                fontSize: 17,
              ),
            ),
          ],
        ),
      );
}