// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:application/model/Message.dart';
import 'package:application/model/ChatMessage.dart';

class ChatPage extends StatefulWidget {
  final Chat chat;

  const ChatPage({Key? key, required this.chat}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    messages = widget.chat.messages;
  }

  String newMessage = '';

  void sendMessage() {
    setState(() {
      messages.add(Message(
        idChat: widget.chat.idChat,
        idUser: widget.chat.idUser,
        sender: 'You',
        message: newMessage,
        timestamp: DateTime.now().toString(),
      ));
      newMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chat ${widget.chat.idChat}",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 0, 55, 111),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
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
            color: Colors.grey[200],
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (text) => newMessage = text,
                    decoration: InputDecoration(
                      hintText: 'Digite sua mensagem',
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: sendMessage,
                  icon: Icon(Icons.send, color: Color(0xff075E54)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMessage(Message message) {
    final isYou = message.sender == 'You';
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
        left: isYou ? 60 : 10,
        right: isYou ? 10 : 60,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: isYou
            ? Color.fromARGB(255, 214, 99, 0)
            : Color.fromARGB(255, 0, 55, 111),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isYou)
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                message.timestamp.substring(11, 16),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          Text(
            message.message,
            style: TextStyle(color: Colors.white),
          ),
          if (isYou)
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                message.timestamp.substring(11, 16),
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
