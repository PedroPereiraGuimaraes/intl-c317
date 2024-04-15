// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:application/database/services/chatservice.dart';
import 'package:flutter/material.dart';
import 'package:application/model/Message.dart';
import 'package:application/model/Chat.dart';

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
          "Chat ${widget.chat.chatId}",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 0, 55, 111),
        iconTheme: IconThemeData(color: Colors.white),
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
            padding: EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 10,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromARGB(255, 214, 99, 0),
            ),
            child: Text(
              message.message,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              message.response,
              style: TextStyle(
                color: Colors.white,
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
