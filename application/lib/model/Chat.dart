// ignore_for_file: file_names

import 'package:application/model/Message.dart';

class Chat {
  int chatId;
  String userId;
  List<Message> messages;

  Chat({
    required this.chatId,
    required this.messages,
    required this.userId,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      chatId: json['chatId'] as int,
      messages: (json['messages'] as List<dynamic>)
          .map((messageJson) => Message.fromJson(messageJson))
          .toList(),
      userId: json['userId'] as String,
    );
  }
}
