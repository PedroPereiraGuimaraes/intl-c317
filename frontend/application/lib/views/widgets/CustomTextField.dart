// ignore_for_file: file_names, depend_on_referenced_packages, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController controller;
  final IconData icon;
  final bool isPassword;

  const CustomTextField({
    super.key,
    required this.title,
    required this.hint,
    required this.controller,
    required this.icon,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: title,
        labelStyle: text(14, FontWeight.normal, Color.fromARGB(255, 214, 99, 0),
            TextDecoration.none),
        hintText: hint,
        hintStyle: text(15, FontWeight.normal,
            Color.fromARGB(255, 158, 158, 158), TextDecoration.none),
        suffixIcon: Icon(
          icon,
          color: Color.fromARGB(255, 214, 99, 0),
        ),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 214, 99, 0),
            width: 3.0,
          ),
        ),
      ),
    );
  }
}

TextStyle text(double fontSize, FontWeight fontWeight, Color color,
    TextDecoration decoration) {
  return TextStyle(
    fontFamily: GoogleFonts.josefinSans().fontFamily,
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    decoration: decoration,
  );
}

ButtonStyle button(Color backgroundColor) {
  return ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
    minimumSize: MaterialStateProperty.all<Size>(
      const Size(double.infinity, 50),
    ),
    shape: MaterialStateProperty.all<OutlinedBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
    ),
  );
}
