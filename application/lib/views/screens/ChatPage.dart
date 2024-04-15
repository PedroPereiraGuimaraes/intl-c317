// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:application/model/Chat.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:application/model/Message.dart';
import 'package:application/views/screens/ChatsPage.dart';
import 'package:application/database/services/chatservice.dart';

class ChatPage extends StatefulWidget {
  final Chat chat;

  const ChatPage({Key? key, required this.chat}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  String get _newMessage => _messageController.text;
  List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    _getPreviousMessages();
  }

  Future<void> _getPreviousMessages() async {
    final messageData = await getMessagesByChatId(widget.chat.chatId);
    final List<Message> fetchedMessages = [];
    for (var messageJson in messageData) {
      fetchedMessages.add(Message.fromJson(messageJson));
    }
    setState(() {
      messages = fetchedMessages;
    });
  }

  Future<void> sendMessage() async {
    if (_newMessage.isEmpty) return;

    try {
      final response = await sendMessageToChat(
        widget.chat.chatId,
        widget.chat.userId,
        _newMessage,
      );

      final newMessage = Message(
        idUser: widget.chat.userId,
        message: _newMessage,
        response: response['response'],
        timestamp: DateTime.now(),
      );

      setState(() {
        messages.add(newMessage);
        _messageController.text = '';
      });
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "CHAT ${widget.chat.chatId}",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.josefinSans().fontFamily,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 0, 55, 111),
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatsPage(userId: widget.chat.userId),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    title: Text(
                      'DELETAR CHAT',
                      style: TextStyle(
                        color: Color.fromARGB(255, 214, 99, 0),
                        fontFamily: GoogleFonts.josefinSans().fontFamily,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    content: Text(
                      "Tem certeza que quer apagar o chat?",
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
                          deleteChatById(widget.chat.chatId);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChatsPage(userId: widget.chat.userId),
                            ),
                          );
                        },
                        child: Text(
                          'SIM',
                          style: TextStyle(
                            color: Color.fromARGB(255, 214, 99, 0),
                            fontFamily: GoogleFonts.josefinSans().fontFamily,
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'NÃO',
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
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/logobackground.png',
            ),
            opacity: 0.5,
            fit: BoxFit.scaleDown,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: false,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return buildMessage(message);
                },
              ),
            ),
            Container(
              color: Colors.transparent,
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Digite sua mensagem',
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: sendMessage,
                    icon: Icon(
                      Icons.send,
                      color: Color.fromARGB(255, 0, 55, 111),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMessage(Message message) {
    return Container(
      padding: EdgeInsets.only(
        top: 10,
        bottom: 10,
        left: 15,
        right: 10,
      ),
      margin: EdgeInsets.only(
        top: 5,
        bottom: 5,
        left: 45,
        right: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color.fromARGB(255, 0, 55, 111),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 5, right: 5),
            padding: EdgeInsets.symmetric(
              vertical: message.message.isEmpty ? 0 : 5,
              horizontal: message.message.isEmpty ? 0 : 10,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: message.message.isEmpty
                  ? Color.fromARGB(255, 0, 55, 111)
                  : Color.fromARGB(255, 214, 99, 0),
            ),
            child: Text(
              message.message.isEmpty
                  ? ""
                  : "VOCÊ: ${message.message.toUpperCase()}",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontFamily: GoogleFonts.josefinSans().fontFamily,
                fontSize: 13,
              ),
            ),
          ),
          Container(
            padding: message.message.isEmpty
                ? EdgeInsets.all(0)
                : EdgeInsets.only(top: 10),
            child: Text(
              message.response.toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontFamily: GoogleFonts.josefinSans().fontFamily,
                fontWeight: FontWeight.w300,
                fontSize: 13,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              message.timestamp.toString().substring(11, 16),
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
