class Message {
  final int idChat;
  final int idUser;
  final String sender;
  final String message;
  final String timestamp;

  Message({
    required this.idChat,
    required this.idUser,
    required this.sender,
    required this.message,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      idChat: json['idChat'] as int,
      idUser: json['idUser'] as int,
      sender: json['sender'] as String,
      message: json['message'] as String,
      timestamp: json['timestamp'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'idChat': idChat,
        'idUser': idUser,
        'sender': sender,
        'message': message,
        'timestamp': timestamp,
      };
}
