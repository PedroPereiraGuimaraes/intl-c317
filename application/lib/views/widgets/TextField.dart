// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController controller;
  final IconData icon;
  final bool isPassword;

  const CustomTextField({
    Key? key,
    required this.title,
    required this.hint,
    required this.controller,
    required this.icon,
    this.isPassword = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: title,
        labelStyle: TextStyle(
          color: Color.fromARGB(255, 214, 99, 0),
          fontFamily: GoogleFonts.josefinSans().fontFamily,
          fontSize: 14,
        ),
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontFamily: GoogleFonts.josefinSans().fontFamily,
          fontSize: 15,
        ),
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
