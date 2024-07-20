import 'dart:async' show Future;
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static SharedPreferences? _prefInstance;

  // Getter for SharedPreferences instance, initializes if not already done
  static Future<SharedPreferences> get _instance async =>
      _prefInstance ??= await SharedPreferences.getInstance();

  // Initializes the SharedPreferences instance
  static Future<SharedPreferences?> init() async {
    _prefInstance = await _instance;
    return _prefInstance;
  }

  // Retrieves a string value from SharedPreferences
  static String? getString(String key) {
    return _prefInstance?.getString(key);
  }

  // Sets a string value in SharedPreferences
  static Future<bool> setString(String key, String value) async {
    var pref = await _instance;
    return pref.setString(key, value);
  }

  // Removes a value from SharedPreferences
  static Future<bool> remove(String key) async {
    var pref = await _instance;
    return pref.remove(key);
  }

  // Clears all values in SharedPreferences
  static Future<bool> clear() async {
    var pref = await _instance;
    return pref.clear();
  }
}
