class User {
  final String name;
  final String password;
  final String email;
  final int idUser;

  User({
    required this.name,
    required this.password,
    required this.email,
    required this.idUser,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String,
      password: json['password'] as String,
      email: json['email'] as String,
      idUser: json['iduser'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'password': password,
      'email': email,
      'iduser': idUser,
    };
  }
}
