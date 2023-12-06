// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Color.fromRGBO(240, 240, 240, 1),
      controller: widget.controller,
      obscureText: widget.obscureText,
      style: GoogleFonts.dmSans(
        color: Color.fromRGBO(240, 240, 240, 1),
      ),
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(240, 240, 240, 1)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(240, 240, 240, 1)),
        ),
        fillColor: Color.fromRGBO(3, 21, 37, 1),
        filled: true,
        hintText: widget.hintText,
        hintStyle: GoogleFonts.dmSans(
          color: Color.fromRGBO(240, 240, 240, 1),
          fontWeight: FontWeight.bold,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 17),
      ),
    );
  }
}