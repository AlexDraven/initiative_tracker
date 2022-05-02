import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:initiative_tracker/models/models.dart';
import 'package:http/http.dart' as http;

class CharactersService extends ChangeNotifier {
  final String _baseUrl = 'alex-initiative-tracker.herokuapp.com';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final List<Character> characters = [];

  late Character selectedCharacter;

  File? newPictureFile;

  bool isLoading = true;

  bool isSaving = false;

  CharactersService() {
    loadCharacters();
  }

  Future<List<Character>> loadCharacters() async {
    isLoading = true;
    notifyListeners();
    final url = Uri.https(_baseUrl, '/characters');
    //TODO: pasar a https
    final response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      'Authorization': 'Bearer ${await _storage.read(key: 'token')}'
    });

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      print(data);
      final List<Character> characters = data.map((dynamic item) {
        return Character.fromJson(item);
      }).toList();
      this.characters.clear();
      this.characters.addAll(characters);
      isLoading = false;
      notifyListeners();
      return characters;
    } else {
      this.characters.clear();
      isLoading = false;
      notifyListeners();
      throw Exception('Failed to load characters');
    }
  }

  Future saveOrCreateCharacter(Character character) async {
    isSaving = true;
    notifyListeners();
    if (character.id == null) {
      await _createCharacter(character);
    } else {
      await _updateCharacter(character);
    }
    isSaving = false;
    notifyListeners();
  }

  Future _updateCharacter(Character character) async {
    final url = Uri.https(_baseUrl, '/characters/${character.id}');
    final response = await http.patch(url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          'Authorization': 'Bearer ${await _storage.read(key: 'token')}'
        },
        body: json.encode(character));
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = json.decode(response.body);
      final Character updatedCharacter = Character.fromJson(data);
      final index =
          characters.indexWhere((Character c) => c.id == updatedCharacter.id);
      characters[index] = updatedCharacter;
      notifyListeners();
    } else {
      throw Exception('Failed to update character');
    }
  }

  Future _createCharacter(Character character) async {
    final url = Uri.https(_baseUrl, '/characters');
    final response = await http.post(url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          'Authorization': 'Bearer ${await _storage.read(key: 'token')}'
        },
        body: json.encode(character));
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = json.decode(response.body);
      final Character createdCharacter = Character.fromJson(data);
      characters.add(createdCharacter);
      notifyListeners();
    } else {
      throw Exception('Failed to create character');
    }
  }

  void updateSelectedCharacterImage(String path) {
    selectedCharacter.picture = path;
    newPictureFile = File.fromUri(Uri(path: path));

    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (newPictureFile == null) return null;
    isSaving = true;
    notifyListeners();
    // upload image to cloudinary
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dgnezslzj/image/upload?upload_preset=dnd-initiative-tracker');
    // ignore: todo
    // TODO: esto podria hacerlo en backend initiative-tracker-server y no en cliente
    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file =
        await http.MultipartFile.fromPath('file', newPictureFile!.path);

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();

    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      isSaving = false;
      notifyListeners();
      return null;
    }

    newPictureFile = null;
    final decodedData = json.decode(resp.body);
    return decodedData['secure_url'];
  }
}
