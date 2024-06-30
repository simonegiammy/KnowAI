import 'package:shared_preferences/shared_preferences.dart';

class StorageProvider {
  static const String _key = 'storedValue';

  // Incrementa il valore memorizzato di 1
  static Future<void> incrementValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int currentValue = prefs.getInt(_key) ?? 0;
    await prefs.setInt(_key, currentValue + 1);
  }

  // Ottieni il valore corrente
  static Future<int> getValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_key) ?? 0;
  }
}
