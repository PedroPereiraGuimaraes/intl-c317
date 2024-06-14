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
      idUser: json['idUser'] != null ? json['idUser'] as String : '',
      message: json['message'] != null ? json['message'] as String : '',
      response: json['response'] != null ? json['response'] as String : '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
    );
  }
}
