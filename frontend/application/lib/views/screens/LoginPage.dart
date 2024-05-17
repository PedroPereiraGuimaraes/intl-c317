// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, depend_on_referenced_packages, unrelated_type_equality_checks, use_build_context_synchronously, file_names

import 'package:application/views/widgets/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:application/views/screens/ChatsPage.dart';
import 'package:application/database/services/userservice.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> login(
      BuildContext context, String email, String password) async {
    try {
      final Map<String, dynamic> response = await loginUser(email, password);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatsPage(
            userId: response['id'].toString(),
          ),
        ),
      );
    } on Exception catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              'ERRO',
              style: text(20, FontWeight.w400, Color.fromARGB(255, 214, 99, 0),
                  TextDecoration.none),
            ),
            content: Text(
              e.toString(),
              style: text(17, FontWeight.w300, Color.fromARGB(0, 0, 0, 0),
                  TextDecoration.none),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'OK',
                  style: text(15, FontWeight.w300,
                      Color.fromARGB(255, 214, 99, 0), TextDecoration.none),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Color.fromARGB(255, 214, 99, 0),
            size: 25,
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      'assets/logo.png',
                      width: 120,
                      height: 120,
                    ),
                  ),
                  SizedBox(height: 40),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Continue com seu',
                      style: text(22, FontWeight.w300, Colors.black,
                          TextDecoration.none),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'LOGIN',
                      style: text(25, FontWeight.w900,
                          Color.fromARGB(255, 214, 99, 0), TextDecoration.none),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                      title: "EMAIL",
                      hint: "user@email.com",
                      controller: _emailController,
                      icon: Icons.email_outlined),
                  const SizedBox(height: 20),
                  CustomTextField(
                    title: "PASSWORD",
                    hint: "'*****************'",
                    controller: _passwordController,
                    icon: Icons.remove_red_eye_outlined,
                    isPassword: true,
                  ),
                  const SizedBox(height: 80),
                  ElevatedButton(
                    onPressed: () {
                      login(context, _emailController.text,
                          _passwordController.text);
                    },
                    style: button(Color.fromARGB(255, 214, 99, 0)),
                    child: Text(
                      'LOGIN',
                      style: text(20, FontWeight.w300, Colors.white,
                          TextDecoration.none),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      //implementar ação de redefinir senha
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'Esqueci minha senha',
                        style: text(
                            20,
                            FontWeight.normal,
                            Color.fromARGB(255, 214, 99, 0),
                            TextDecoration.underline),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
