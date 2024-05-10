// ignore: file_names
import 'package:application/views/screens/ChatsPage.dart';
import 'package:flutter/material.dart';
import 'package:application/views/widgets/TextStyles.dart';
// ignore: depend_on_referenced_packages
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

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
                  builder: (context) => const ChatsPage(userId: ''),
                ),
              );
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                          border: Border.all(
                            color: const Color.fromARGB(
                                255, 0, 55, 111), // Cor do contorno
                            width: 1.7, // Largura do contorno
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/icone.png',
                            width: 30, // Largura da imagem
                            height: 30, // Altura da imagem
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Pedro Pereira Guimarães',
                        style: text(
                            20,
                            FontWeight.w300,
                            const Color.fromARGB(255, 0, 55, 111),
                            TextDecoration.underline),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Icon(Icons.edit),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 30,
                    color: Color.fromARGB(255, 0, 55, 111),
                    thickness: 3,
                    indent: 0,
                    endIndent: 0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Ativar notificações',
                        style: text(
                            20,
                            FontWeight.w300,
                            const Color.fromARGB(255, 0, 55, 111),
                            TextDecoration.none),
                      ),
                      const SizedBox(width: 20),
                      LiteRollingSwitch(
                        value: true,
                        width: 90.0,
                        textOn: 'On',
                        textOnColor: Colors.white,
                        textOffColor: Colors.white,
                        textOff: 'Off',
                        colorOn: Colors.green,
                        colorOff: Colors.red,
                        iconOn: Icons.done,
                        iconOff: Icons.remove,
                        textSize: 12.0,
                        onChanged: (bool state) {
                          print('turned: $state');
                        },
                        onTap: () {
                          print('Widget tapped');
                        },
                        onDoubleTap: () {
                          print('Widget double tapped');
                        },
                        onSwipe: (bool state) {
                          print('Widget swiped: $state');
                        },
                      ),
                    ],
                  ),
                  const Divider(
                    height: 30,
                    color: Color.fromARGB(255, 0, 55, 111),
                    thickness: 3,
                    indent: 0,
                    endIndent: 0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Idioma',
                        style: text(
                            20,
                            FontWeight.w300,
                            const Color.fromARGB(255, 0, 55, 111),
                            TextDecoration.none),
                      ),
                      SizedBox(width: 20),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Icon(Icons.list),
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 30,
                    color: Color.fromARGB(255, 0, 55, 111),
                    thickness: 3,
                    indent: 0,
                    endIndent: 0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Deletar todos os chats',
                        style: text(
                            20,
                            FontWeight.w300,
                            const Color.fromARGB(255, 0, 55, 111),
                            TextDecoration.none),
                      ),
                      const SizedBox(width: 20),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Icon(Icons.delete),
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 30,
                    color: Color.fromARGB(255, 0, 55, 111),
                    thickness: 3,
                    indent: 0,
                    endIndent: 0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Sobre',
                        style: text(
                            20,
                            FontWeight.w300,
                            const Color.fromARGB(255, 0, 55, 111),
                            TextDecoration.none),
                      ),
                      const SizedBox(width: 20),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Icon(Icons.more),
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 30,
                    color: Color.fromARGB(255, 0, 55, 111),
                    thickness: 3,
                    indent: 0,
                    endIndent: 0,
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
