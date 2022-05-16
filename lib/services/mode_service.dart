import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModeService extends ChangeNotifier {
  final String modeKey = 'mode';
  final String modePlayer = 'player';
  final String modeMaster = 'master';

  String currentMode = 'player';

  ModeService() {
    defaultValues();
  }

  void defaultValues() async {
    final prefs = await SharedPreferences.getInstance();
    final mode = prefs.getString(modeKey);
    if (mode != null) {
      currentMode = mode;
    } else {
      currentMode = modePlayer;
      await prefs.setString(modeKey, modePlayer);
    }
    notifyListeners();
  }

  void changeMode(String mode) {
    currentMode = mode;
    notifyListeners();
  }

  String getModeName() {
    if (currentMode == modeMaster) {
      return 'DM';
    } else {
      return 'Jugador';
    }
  }
}
