import 'package:application/model/Message.dart';

class Chat {
  final int idChat;
  final int idUser;
  final List<Message> messages;

  Chat({
    required this.idChat,
    required this.idUser,
    required this.messages,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      idChat: json['idChat'] as int,
      idUser: json['idUser'] as int,
      messages: (json['messages'] as List)
          .map((message) => Message.fromJson(message))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'idChat': idChat,
        'idUser': idUser,
        'messages': messages.map((message) => message.toJson()).toList(),
      };
}
