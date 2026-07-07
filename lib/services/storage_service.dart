import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  StorageService._();
  static StorageService? _instance;
  static SharedPreferences? _prefs;

  static Future<StorageService> getInstance() async {
    _instance ??= StorageService._();
    _prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  Future<bool> saveString(String key, String value) async {
    return _prefs!.setString(key, value);
  }

  String? getString(String key) {
    return _prefs?.getString(key);
  }

  Future<bool> remove(String key) async {
    return _prefs!.remove(key);
  }

  Future<bool> clear() async {
    return _prefs!.clear();
  }
}
