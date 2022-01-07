import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  // 10.0.2.2 es localhost para el emulador de android
  final String _baseUrl = '10.0.2.2:3000';
  final storage = const FlutterSecureStorage();

  Future<String?> createUser(
      String firstname, String lastname, String email, String password) async {
    final Map<String, dynamic> registerData = {
      "firstname": email,
      "lastname": email,
      'email': email,
      'password': password
    };

    final url = Uri.http(_baseUrl, '/users/register');
    //TODO: change to https

    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(registerData));

    final Map<String, dynamic> decodedResp = json.decode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return 'Usuario creado exitosamente con el email: ${decodedResp['email']}';
      // return null;
    } else {
      return response.statusCode >= 400 && response.statusCode < 500
          ? decodedResp['message'][0]
          : 'Error al crear el usuario';
    }
  }

  Future<String?> login(String username, String password) async {
    final Map<String, dynamic> authData = {
      'username': username,
      'password': password,
    };

    final url = Uri.http(_baseUrl, '/auth/login');
    // TODO: change to https

    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(authData));

    final Map<String, dynamic> decodedResp = json.decode(response.body);

    if (decodedResp.containsKey('token')) {
      await storage.write(key: 'token', value: decodedResp['token']);
      return null;
    } else {
      return decodedResp['message'][0];
    }
  }

  Future<void> logout() async {
    await storage.delete(key: 'token');
    notifyListeners();
  }

  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }
}
