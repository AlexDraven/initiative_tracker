import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static final UserPreferences _instance = UserPreferences._internal();

  factory UserPreferences() {
    return _instance;
  }
  UserPreferences._internal();

  static const String _name = 'name';
  static const String _gender = 'gender';
  static const String _secondaryColor = 'secondaryColor';
  // static const String _email = 'email';
  // static const String _password = 'password';
  // static const String _isRemember = 'isRemember';
  // static const String _isLogin = 'isLogin';

  late SharedPreferences _prefs;

  initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String get name {
    return _prefs.getString(_name) ?? '';
  }

  set name(String value) {
    _prefs.setString(_name, value);
  }

  String get gender {
    return _prefs.getString(_gender) ?? '';
  }

  set gender(String value) {
    _prefs.setString(_gender, value);
  }

  bool get secondaryColor {
    return _prefs.getBool(_secondaryColor) ?? false;
  }

  set secondaryColor(bool value) {
    _prefs.setBool(_secondaryColor, value);
  }
}
