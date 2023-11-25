import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class PostUI extends StatelessWidget {
  final String name;
  final String username;
  final String content;
  const PostUI({
    super.key,
    required this.name,
    required this.username,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    DateTime postDateTime = DateTime.now();
    String formattedDateTime = DateFormat('dd/MM/yyyy HH:mm').format(postDateTime);

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Material(
        elevation: 20,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(19, 32, 67, 1),
            borderRadius: BorderRadius.circular(8)
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Color.fromRGBO(240, 240, 240, 1),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          color: Color.fromRGBO(240, 240, 240, 1),
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                        ),
                      ),
                      Text(
                        username,
                        style: TextStyle(
                          color: Color.fromRGBO(240, 240, 240, 1),
                          fontSize: 15
                        ),
                      ),
                    ],
                  )
                ],
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Carol', 
                      style: GoogleFonts.dmSans(
                        color: Color.fromRGBO(240, 240, 240, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: ' (2015)', 
                      style: GoogleFonts.dmSans(
                        color: Color.fromRGBO(240, 240, 240, 1),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  content,
                  style: GoogleFonts.dmSans(
                    color: Color.fromRGBO(240, 240, 240, 1),
                    fontSize: 18,
                    fontStyle: FontStyle.normal,
                  ),
                textAlign: TextAlign.justify,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      formattedDateTime,
                      style: GoogleFonts.dmSans(
                        color: Color.fromRGBO(240, 240, 240, 1),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}