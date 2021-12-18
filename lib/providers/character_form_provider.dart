import 'package:flutter/material.dart';
import 'package:initiative_tracker/models/models.dart';

class CharacterFormProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  Character character;

  CharacterFormProvider(this.character);

  updateActive(bool value) {
    character.active = value;
    notifyListeners();
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
