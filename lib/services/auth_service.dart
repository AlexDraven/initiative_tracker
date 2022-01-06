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
      print(decodedResp);
      return response.statusCode >= 400 && response.statusCode < 500
          ? decodedResp['message'][0]
          : 'Error al crear el usuario';
    }
  }

// TODO: UPDATE LOGIN
  Future<String?> login(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };

    final url = Uri.https(_baseUrl, '/v1/accounts:signInWithPassword');

    final response = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedResp = json.decode(response.body);

    if (decodedResp.containsKey('idToken')) {
      await storage.write(key: 'idToken', value: decodedResp['idToken']);
      return null;
    } else {
      return decodedResp['error']['message'];
    }
  }

// TODO: UPDATE LOGOUT
  Future<void> logout() async {
    await storage.delete(key: 'idToken');
    notifyListeners();
  }

// TODO: UPDATE CHECK AUTH
  Future<String> readToken() async {
    return await storage.read(key: 'idToken') ?? '';
  }
}
