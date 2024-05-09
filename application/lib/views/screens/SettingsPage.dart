// ignore: file_names
import 'package:flutter/material.dart';
import 'package:application/views/widgets/TextStyles.dart';

void main() async {
  runApp(const SettingsPage());
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/icone.png',
                          width: 50,
                          height: 50,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                      'Pedro Pereira Guimarães',
                      style: text(20, FontWeight.w300, Color.fromARGB(255,0,55,111), TextDecoration.underline), 
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {}, 
                        child: Icon(Icons.edit),
                      ),
                    ],
                  ),

                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                      'Ativar notificações',
                      style: text(20, FontWeight.w300, Color.fromARGB(255,0,55,111), TextDecoration.none), 
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {}, 
                        child: Icon(Icons.toggle_on_sharp),
                      ),
                    ],
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
