// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors

import 'package:application/views/screens/LoginPage.dart';
import 'package:application/views/widgets/TextField.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordCheckController =
      TextEditingController();

  RegisterCheck() {
    String email = _emailController.text;
    String password = _passwordController.text;
    String passwordCheck = _passwordCheckController.text;

    if (email == '' && password == '' && passwordCheck == '') {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    } else if (password != passwordCheck) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              'ERRO',
              style: TextStyle(
                color: Color.fromARGB(255, 214, 99, 0),
                fontFamily: GoogleFonts.josefinSans().fontFamily,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
            content: Text(
              'Senhas inseridas não são iguais. Por favor, tente novamente.',
              style: TextStyle(
                color: Colors.black,
                fontFamily: GoogleFonts.josefinSans().fontFamily,
                fontSize: 17,
                fontWeight: FontWeight.w300,
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: Color.fromARGB(255, 214, 99, 0),
                    fontFamily: GoogleFonts.josefinSans().fontFamily,
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              'ERRO',
              style: TextStyle(
                color: Color.fromARGB(255, 214, 99, 0),
                fontFamily: GoogleFonts.josefinSans().fontFamily,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
            content: Text(
              'Email ou senha incorretos. Por favor, tente novamente.',
              style: TextStyle(
                color: Colors.black,
                fontFamily: GoogleFonts.josefinSans().fontFamily,
                fontSize: 17,
                fontWeight: FontWeight.w300,
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: Color.fromARGB(255, 214, 99, 0),
                    fontFamily: GoogleFonts.josefinSans().fontFamily,
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                  ),
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
            padding: const EdgeInsets.all(30.0),
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
                SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Continue com seu',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: GoogleFonts.josefinSans().fontFamily,
                      fontSize: 22,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Cadastro',
                    style: TextStyle(
                      color: Color.fromARGB(255, 214, 99, 0),
                      fontFamily: GoogleFonts.josefinSans().fontFamily,
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
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
                    icon: Icons.key),
                const SizedBox(height: 20),
                CustomTextField(
                    title: "PASSWORD",
                    hint: "**************",
                    controller: _passwordCheckController,
                    icon: Icons.key),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    RegisterCheck();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 214, 99, 0),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  child: const Text(
                    'REGISTRAR',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Josefin Sans',
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
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
                      style: TextStyle(
                        color: Color.fromARGB(255, 214, 99, 0),
                        fontFamily: GoogleFonts.josefinSans().fontFamily,
                        fontSize: 15,
                        decoration: TextDecoration.underline,
                      ),
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
