// ignore: file_names
// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:application/views/screens/AboutPage.dart';
import 'package:application/views/screens/ChatsPage.dart';
import 'package:application/views/screens/InitPage.dart';
import 'package:flutter/material.dart';
import 'package:application/views/widgets/CustomTextField.dart';

class SettingsPage extends StatefulWidget {
  final String userId;
  const SettingsPage({super.key, required this.userId});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Configurações',
            style: text(20, FontWeight.w900, Colors.white, TextDecoration.none),
          ),
          backgroundColor: const Color.fromARGB(255, 0, 55, 111),
          centerTitle: true,
          automaticallyImplyLeading: false,
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatsPage(userId: widget.userId),
                ),
              );
            },
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(height: 20),
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage('assets/user.png'),
                    radius: 30,
                    backgroundColor: Colors.black,
                  ),
                  title: Text(
                    'Pedro Pereira Guimarães',
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 0, 55, 111),
                    ),
                  ),
                  trailing: Icon(
                    Icons.edit,
                    color: Color.fromARGB(255, 214, 99, 0),
                  ),
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => AdminPage(),
                    //   ),
                    // );
                  },
                ),
                SizedBox(height: 20),
                SwitchListTile(
                  title: Text(
                    'Ativar notificações',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 0, 55, 111),
                    ),
                  ),
                  value: _notificationsEnabled,
                  activeColor: Color.fromARGB(255, 214, 99, 0),
                  onChanged: (value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                  },
                ),
                ListTile(
                  title: Text(
                    'Deletar todos os chats',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 0, 55, 111),
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Color.fromARGB(255, 214, 99, 0),
                  ),
                  onTap: _showDeleteChatsDialog,
                ),
                ListTile(
                  title: Text(
                    'Sobre',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 0, 55, 111),
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Color.fromARGB(255, 214, 99, 0),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AboutPage(userId: widget.userId),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: Text(
                    'Sair',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 0, 55, 111),
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Color.fromARGB(255, 214, 99, 0),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InitPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteChatsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Tem certeza de que deseja apagar todos os chats?",
            style: text(
              17,
              FontWeight.w300,
              Color.fromARGB(255, 0, 55, 111),
              TextDecoration.none,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                "Cancelar",
                style: text(
                  17,
                  FontWeight.w400,
                  Color.fromARGB(255, 214, 99, 0),
                  TextDecoration.none,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                "Apagar",
                style: text(
                  17,
                  FontWeight.w400,
                  Color.fromARGB(255, 214, 99, 0),
                  TextDecoration.none,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
