// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'package:application/model/User.dart';
import 'package:http/http.dart' as http;

// POST LOGIN USER
Future<Map<String, dynamic>> loginUser(String email, String password) async {
  final url = Uri.parse('http://10.0.2.2:5000/user/login');

  try {
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final statusCode = response.statusCode;
    final responseBody = jsonDecode(response.body) as Map<String, dynamic>;

    if (statusCode == 201) {
      return responseBody;
    } else if (statusCode == 400) {
      throw Exception(responseBody['error']);
    } else if (statusCode == 401) {
      throw Exception(responseBody['message']);
    } else {
      throw Exception('Login failed with status: $statusCode');
    }
  } catch (e) {
    rethrow;
  }
}

// POST CREATE USER
Future<Map<String, dynamic>> createUser(User newUser) async {
  final url = Uri.parse('http://10.0.2.2:5000/user/create');

  final bool isValidEmail =
      RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(newUser.email);
  if (!isValidEmail) {
    throw Exception('Invalid email format. Please check the email address.');
  }

  if (newUser.username == null || newUser.password == null) {
    throw Exception('Username and password are required');
  }

  try {
    final Map<String, dynamic> requestBody = newUser.toJson();

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBody),
    );

    final statusCode = response.statusCode;

    if (statusCode == 201) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else if (statusCode == 400) {
      throw Exception(jsonDecode(response.body)['error']);
    } else if (statusCode == 409) {
      throw Exception(jsonDecode(response.body)['message']);
    } else {
      throw Exception('User creation failed with status: $statusCode');
    }
  } catch (e) {
    rethrow;
  }
}
