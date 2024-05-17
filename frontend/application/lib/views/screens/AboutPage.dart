// ignore_for_file: prefer_const_constructors

import 'package:application/views/screens/SettingsPage.dart';
import 'package:application/views/widgets/CustomTextField.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  final String userId;
  const AboutPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 55, 111),
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'Sobre nós',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Colors.white,
            decoration: TextDecoration.none,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingsPage(userId: userId),
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Image.asset(
              'assets/logo.png',
              width: 150,
              height: 150,
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'A IWS - Intelliware Solutions é uma empresa de desenvolvimento de software especializada em sistemas de gestão empresarial (ERP). Oferece soluções completas que garantem um domínio absoluto dos processos da empresa. Do operacional ao estratégico, os sistemas abrangem rotinas atendendo diversos segmentos de mercado como atacadistas, distribuidores, lojas de material de construção, supermercados, laticínios e varejistas no geral. Sempre atenta a oferecer o que há de mais novo em tecnologia, procura inserir em suas soluções modernidade, inteligência, segurança da informação e praticidade.',
                textAlign: TextAlign.justify,
                style: text(16, FontWeight.w900,
                    const Color.fromARGB(255, 0, 55, 111), TextDecoration.none),
              ),
            ),
            SizedBox(
              height: 60,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    // Adicione a lógica para abrir o LinkedIn
                  },
                  child: Image.asset(
                    'assets/linkedin.png',
                    width: 60,
                    height: 60,
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Adicione a lógica para abrir o site
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.asset(
                      'assets/web.png',
                      width: 60,
                      height: 60,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Adicione a lógica para abrir o Instagram
                  },
                  child: Image.asset(
                    'assets/instagram.png',
                    width: 60,
                    height: 60,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
