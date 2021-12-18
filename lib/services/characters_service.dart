import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:initiative_tracker/models/models.dart';
import 'package:http/http.dart' as http;

class CharactersService extends ChangeNotifier {
  // ignore: unused_field
  final String _baseUrl =
      'dnd-initiative-tracker-4bef6-default-rtdb.firebaseio.com';
  final List<Character> characters = [];

  late Character selectedCharacter;

  final storage = new FlutterSecureStorage();

  File? newPictureFile;

  bool isLoading = true;

  bool isSaving = false;

  CharactersService() {
    loadCharacters();
  }

  Future<List<Character>> loadCharacters() async {
    isLoading = true;
    notifyListeners();
    final url = Uri.https(_baseUrl, 'characters.json',
        {'auth': await storage.read(key: 'idToken') ?? ''});

    final resp = await http.get(url);

    final Map<String, dynamic> charactersMap = json.decode(resp.body);

    charactersMap.forEach((key, value) {
      final tmpCharacter = Character.fromMap(value);
      tmpCharacter.id = key;
      characters.add(tmpCharacter);
    });

    isLoading = false;
    notifyListeners();
    return characters;
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
    final url = Uri.https(_baseUrl, 'characters/${character.id}.json',
        {'auth': await storage.read(key: 'idToken') ?? ''});
    // ignore: unused_local_variable
    final resp = await http.put(url, body: character.toJson());
    final index = characters.indexWhere((c) => c.id == character.id);
    characters[index] = character;
    return character.id;
  }

  Future _createCharacter(Character character) async {
    final url = Uri.https(_baseUrl, 'characters.json',
        {'auth': await storage.read(key: 'idToken') ?? ''});
    final resp = await http.post(url, body: character.toJson());
    final decodedData = json.decode(resp.body);

    character.id = decodedData['name'];

    characters.add(character);

    return character.id!;
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
