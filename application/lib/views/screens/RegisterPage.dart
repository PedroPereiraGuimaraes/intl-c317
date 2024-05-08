// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors, use_build_context_synchronously, file_names

import 'package:application/database/services/userservice.dart';
import 'package:application/model/User.dart';
import 'package:application/views/screens/InitPage.dart';
import 'package:application/views/screens/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:application/views/widgets/TextStyles.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordCheckController = TextEditingController();

  Future<void> register(String username, String email, String password,
      String passwordCheck) async {
    try {
      final User newUser =
          User(0, username: username, email: email, password: password);
      await createUser(newUser);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => InitPage()),
      );
    } on Exception catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              'ERRO',
              style: text(20, FontWeight.w400, Color.fromARGB(255, 214, 99, 0), TextDecoration.none),
            ),
            content: Text(
              e.toString(),
              style: text(17, FontWeight.w300, Colors.black, TextDecoration.none),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'OK',
                  style: text(15, FontWeight.w300, Color.fromARGB(255, 214, 99, 0), TextDecoration.none),
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
    return Scaffold(
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
            padding: const EdgeInsets.only(bottom: 30, left: 30, right: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Image.asset(
                    'assets/logo.png',
                    width: 120,
                    height: 120,
                  ),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Continue com seu',
                    style: text(22, FontWeight.w300, Colors.black, TextDecoration.none),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Cadastro',
                    style: text(25, FontWeight.w900, Color.fromARGB(255, 214, 99, 0), TextDecoration.none),
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                    title: "USERNAME",
                    hint: "USER123",
                    controller: _usernameController,
                    icon: Icons.person_outline),
                const SizedBox(height: 20),
                CustomTextField(
                    title: "EMAIL",
                    hint: "user@gmail.com",
                    controller: _emailController,
                    icon: Icons.email_outlined),
                const SizedBox(height: 20),
                CustomTextField(
                  title: "PASSWORD",
                  hint: "**************",
                  controller: _passwordController,
                  icon: Icons.key,
                  isPassword: true,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  title: "CONFIRM PASSWORD",
                  hint: "**************",
                  controller: _passwordCheckController,
                  icon: Icons.key,
                  isPassword: true,
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    register(
                      _usernameController.text,
                      _emailController.text,
                      _passwordController.text,
                      _passwordCheckController.text,
                    );
                  },
                  style: button(Color.fromARGB(255, 214, 99, 0)),
                  child: Text(
                    'REGISTRAR',
                    style: text(20, FontWeight.w300, Colors.white, TextDecoration.none),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Já tem uma conta?',
                      style: text(20, FontWeight.normal, Color.fromARGB(255, 214, 99, 0), TextDecoration.underline),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
