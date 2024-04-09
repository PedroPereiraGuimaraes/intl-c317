// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages, prefer_interpolation_to_compose_strings

import 'package:application/model/Message.dart';
import 'package:application/views/screens/ChatPage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:application/model/ChatMessage.dart';

class ChatsPage extends StatefulWidget {
  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final int messageLimit = 25;
  final List<Chat> chatMessages = [];

  Future<void> fetchChatMessages() async {
    setState(
      () {
        chatMessages.addAll(
          [
            Chat(
              idChat: 1,
              idUser: 1,
              messages: [
                Message(
                  idChat: 1,
                  idUser: 1,
                  sender: 'ChatBot',
                  message: 'Hello!',
                  timestamp: '2024-04-09 12:00:00',
                ),
                Message(
                  idChat: 1,
                  idUser: 1,
                  sender: 'You',
                  message: 'Opa, como está?',
                  timestamp: '2024-04-09 12:01:00',
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchChatMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CONVERSAS',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 20,
            fontFamily: GoogleFonts.josefinSans().fontFamily,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 0, 55, 111),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: chatMessages.length,
        itemBuilder: (context, index) {
          final chatMessage = chatMessages[index];
          final dateTime = DateTime.parse(chatMessage.messages.last.timestamp);
          final formattedDate = DateFormat('dd/MM').format(dateTime);
          final lastMessage = chatMessage.messages.last;
          final lastMessageText = lastMessage.message;
          final displayedText = lastMessageText.length > messageLimit
              ? lastMessageText.substring(0, messageLimit) + "..."
              : lastMessageText;

          return ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(chat: chatMessage),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              elevation: 0,
              padding: EdgeInsets.all(10),
            ),
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color.fromARGB(255, 0, 55, 111),
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/profile.png'),
                      radius: 25,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "CHAT ${chatMessage.idChat.toString()}",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            fontFamily: GoogleFonts.josefinSans().fontFamily,
                            color: Color.fromARGB(255, 0, 55, 111),
                          ),
                        ),
                        Text(
                          "${chatMessage.messages[chatMessage.messages.length - 1].sender}: $displayedText",
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: GoogleFonts.josefinSans().fontFamily,
                            color: Color.fromARGB(255, 214, 99, 0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(height: 40),
                        Text(
                          formattedDate,
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: GoogleFonts.josefinSans().fontFamily,
                            color: Color.fromARGB(255, 214, 99, 0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
