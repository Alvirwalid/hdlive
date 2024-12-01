import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageHelper {
  static read(key) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(key);
    return value;
  }

  static readBool(key) async {
    final prefs = await SharedPreferences.getInstance();
    dynamic value = prefs.getBool(key) ?? false;
    return value;
  }

  static save(key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value??"");
  }

  static saveBool(key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  static clearData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
