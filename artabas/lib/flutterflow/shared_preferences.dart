// shared_preferences.dart

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static const String _key = 'userKey';

  // Método para salvar a chave no SharedPreferences
  static Future<void> saveUserKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, key);
  }

  // Método para recuperar a chave do SharedPreferences
  static Future<String?> getUserKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }
}
