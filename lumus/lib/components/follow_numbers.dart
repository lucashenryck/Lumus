import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NumberWidget extends StatelessWidget {
  const NumberWidget({super.key});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget> [
      buildButton(text: 'Seguindo', number: 77),
      buildDivider(),
      buildButton(text: 'Seguidores', number: 177),
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
    required int number
  }) =>
      MaterialButton(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 20),
        onPressed: (){},
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget> [
            Text(
              '$number ',
              style: GoogleFonts.dmSans(
                color: Color.fromRGBO(240, 240, 240, 1),
                fontSize: 25,
              ),
            ),
            const SizedBox(width: 2),
            Text(
              text,
              style: GoogleFonts.dmSans(
                color: Color.fromRGBO(240, 240, 240, 1),
                fontSize: 20,
              ),
            ),
          ],
        ),
      );
}