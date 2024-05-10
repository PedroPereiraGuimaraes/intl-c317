// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages, prefer_interpolation_to_compose_strings, unnecessary_null_comparison, file_names, use_build_context_synchronously, unnecessary_string_interpolations

import 'package:application/views/screens/SettingsPage.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:application/model/Chat.dart';
import 'package:application/views/screens/ChatPage.dart';
import 'package:application/database/services/chatservice.dart';
import 'package:application/views/widgets/TextStyles.dart';

void main() async {
  runApp(const ChatsPage(
    userId: '',
  ));
}

class ChatsPage extends StatefulWidget {
  final String userId;
  const ChatsPage({super.key, required this.userId});

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 0, 55, 111),
            automaticallyImplyLeading: false,
            iconTheme: IconThemeData(color: Colors.white),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Text(
                  'CONVERSAS',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsPage(),
                    ),
                  );
                },
              ),
            ],
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
                style: button(Colors.white),
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
                              style: text(
                                  18,
                                  FontWeight.w900,
                                  Color.fromARGB(255, 0, 55, 111),
                                  TextDecoration.none),
                            ),
                            Text(
                              "Chat: $displayedText",
                              style: text(
                                  15,
                                  FontWeight.normal,
                                  Color.fromARGB(255, 214, 99, 0),
                                  TextDecoration.none),
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
                              style: text(
                                  12,
                                  FontWeight.normal,
                                  Color.fromARGB(255, 214, 99, 0),
                                  TextDecoration.none),
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
        ),
      ),
    );
  }
}
