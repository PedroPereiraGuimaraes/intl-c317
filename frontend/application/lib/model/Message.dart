// ignore_for_file: file_names

class Message {
  String idUser;
  String message;
  String response;
  DateTime timestamp;

  Message({
    required this.idUser,
    required this.message,
    required this.response,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      idUser: json['idUser'] as String,
      message: json['message'] as String,
      response: json['response'] as String,
      timestamp: DateTime.parse(
        json['timestamp'] as String,
      ),
    );
  }
}
