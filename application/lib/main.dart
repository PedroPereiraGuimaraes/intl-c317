// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:application/views/screens/ChatsPage.dart';
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
      title: "Coffe Application",
      initialRoute: '/chats',
      routes: {
        '/init': (context) => InitPage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/chats': (context) => ChatsPage(userId: "661817d42629a1ecf0f0febd"),
      },
      theme: ThemeData(primaryColor: Colors.blue, primarySwatch: Colors.blue),
    );
  }
}
