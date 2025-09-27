import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtils {
  static SharedPreferences? _prefs;
  
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('PreferenceUtils not initialized. Call init() first.');
    }
    return _prefs!;
  }
  
  static Future<bool> setString(String key, String value) async {
    return await prefs.setString(key, value);
  }
  
  static String? getString(String key, {String? defaultValue}) {
    return prefs.getString(key) ?? defaultValue;
  }
  
  static Future<bool> setInt(String key, int value) async {
    return await prefs.setInt(key, value);
  }
  
  static int? getInt(String key, {int? defaultValue}) {
    return prefs.getInt(key) ?? defaultValue;
  }
  
  static Future<bool> setBool(String key, bool value) async {
    return await prefs.setBool(key, value);
  }
  
  static bool? getBool(String key, {bool? defaultValue}) {
    return prefs.getBool(key) ?? defaultValue;
  }

  static Future<bool> setDouble(String key, double value) async {
    return await prefs.setDouble(key, value);
  }
  
  static double? getDouble(String key, {double? defaultValue}) {
    return prefs.getDouble(key) ?? defaultValue;
  }

  static Future<bool> setStringList(String key, List<String> value) async {
    return await prefs.setStringList(key, value);
  }
  
  static List<String>? getStringList(String key, {List<String>? defaultValue}) {
    return prefs.getStringList(key) ?? defaultValue;
  }

  static Future<bool> remove(String key) async {
    return await prefs.remove(key);
  }
  
  static Future<bool> clear() async {
    return await prefs.clear();
  }
  
  static bool containsKey(String key) {
    return prefs.containsKey(key);
  }
  
  static Set<String> getKeys() {
    return prefs.getKeys();
  }
  
  static Future<bool> setUserToken(String token) async {
    return await setString('user_token', token);
  }
  
  static String? getUserToken() {
    return getString('user_token');
  }
  
  static Future<bool> setUserData(String userData) async {
    return await setString('user_data', userData);
  }
  
  static String? getUserData() {
    return getString('user_data');
  }
  
  static Future<bool> setFirstTime(bool isFirstTime) async {
    return await setBool('is_first_time', isFirstTime);
  }
  
  static bool isFirstTime() {
    return getBool('is_first_time', defaultValue: true) ?? true;
  }
  
  static Future<bool> setLanguage(String language) async {
    return await setString('language', language);
  }
  
  static String getLanguage() {
    return getString('language', defaultValue: 'en') ?? 'en';
  }
  
  static Future<bool> setTheme(String theme) async {
    return await setString('theme', theme);
  }
  
  static String getTheme() {
    return getString('theme', defaultValue: 'light') ?? 'light';
  }

  static Future<bool> clearUserData() async {
    await remove('user_token');
    await remove('user_data');
    return true;
  }
}
