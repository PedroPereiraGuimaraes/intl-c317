// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:application/views/screens/InitPage.dart';
import 'package:application/views/screens/LoginPage.dart';
import 'package:application/views/screens/RegisterPage.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "ChatBot App",
      initialRoute: '/init',
      routes: {
        '/init': (context) => InitPage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
      },
      theme: ThemeData(
        primaryColor: Colors.blue,
        hintColor: Colors.orange,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blue,
        hintColor: Colors.orange,
      ),
    );
  }
}
