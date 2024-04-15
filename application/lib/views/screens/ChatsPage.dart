// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages, prefer_interpolation_to_compose_strings, unnecessary_null_comparison

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:application/model/Chat.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:application/views/screens/ChatPage.dart';
import 'package:application/database/services/chatservice.dart';

class ChatsPage extends StatefulWidget {
  final String userId;
  const ChatsPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final int messageLimit = 25;
  List<Chat> chatList = [];

  Future<void> _getChats() async {
    final chatsData = await getChatsByID(widget.userId);
    final chats = chatsData.map((chatJson) => Chat.fromJson(chatJson)).toList();
    setState(() {
      chatList = chats
        ..sort((a, b) => b.messages.isNotEmpty
            ? b.messages.last.timestamp.compareTo(a.messages.isNotEmpty
                ? a.messages.last.timestamp
                : DateTime.now())
            : 1);
    });
  }

  Future<void> _createNewChat() async {
    final newChatData = await createNewChat(widget.userId);
    final chat =
        newChatData.map((chatJson) => Chat.fromJson(chatJson)).toList();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(chat: chat.first),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getChats();
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
        itemCount: chatList.length,
        itemBuilder: (context, index) {
          final chat = chatList[index];
          final lastMessage =
              chat.messages.isNotEmpty ? chat.messages.last : null;
          if (lastMessage == null) return SizedBox();
          String displayedText = lastMessage.response;
          final formattedDate =
              DateFormat('dd/MM').format(lastMessage.timestamp);

          return ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(chat: chat),
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
                          "Chat ${chat.chatId}",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            fontFamily: GoogleFonts.josefinSans().fontFamily,
                            color: Color.fromARGB(255, 0, 55, 111),
                          ),
                        ),
                        Text(
                          "Chat: $displayedText",
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: GoogleFonts.josefinSans().fontFamily,
                            color: Color.fromARGB(255, 214, 99, 0),
                          ),
                          maxLines: 1,
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
                          "$formattedDate",
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _createNewChat();
        },
        backgroundColor: Color.fromARGB(255, 214, 99, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
