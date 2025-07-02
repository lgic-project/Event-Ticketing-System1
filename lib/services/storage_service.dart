import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  // Initialize secure storage
  final _secureStorage = const FlutterSecureStorage();

  // Secure Storage Methods (for sensitive data like tokens)

  Future<void> saveSecureData(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> getSecureData(String key) async {
    return await _secureStorage.read(key: key);
  }

  Future<void> deleteSecureData(String key) async {
    await _secureStorage.delete(key: key);
  }

  Future<void> clearAllSecureData() async {
    await _secureStorage.deleteAll();
  }

  // Shared Preferences Methods (for non-sensitive data)

  Future<void> saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<void> saveInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  Future<int?> getInt(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  Future<void> saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<bool?> getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  Future<void> saveDouble(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(key, value);
  }

  Future<double?> getDouble(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key);
  }

  Future<void> saveStringList(String key, List<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, value);
  }

  Future<List<String>?> getStringList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key);
  }

  // JSON Object Storage

  Future<void> saveObject(String key, Map<String, dynamic> object) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(object);
    await prefs.setString(key, jsonString);
  }

  Future<Map<String, dynamic>?> getObject(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key);
    if (jsonString != null) {
      return json.decode(jsonString) as Map<String, dynamic>;
    }
    return null;
  }

  Future<void> saveObjectList(
    String key,
    List<Map<String, dynamic>> list,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(list);
    await prefs.setString(key, jsonString);
  }

  Future<List<Map<String, dynamic>>?> getObjectList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((item) => item as Map<String, dynamic>).toList();
    }
    return null;
  }

  // Delete Methods

  Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Check if key exists

  Future<bool> containsKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

  // Auth Token Management

  Future<void> saveAuthToken(String token) async {
    await saveSecureData('auth_token', token);
  }

  Future<String?> getAuthToken() async {
    return await getSecureData('auth_token');
  }

  Future<void> clearAuthToken() async {
    await deleteSecureData('auth_token');
  }

  // User Data Management

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await saveObject('user_data', userData);
  }

  Future<Map<String, dynamic>?> getUserData() async {
    return await getObject('user_data');
  }

  Future<void> clearUserData() async {
    await remove('user_data');
  }

  // App Settings

  Future<void> saveThemeMode(String themeMode) async {
    await saveString('theme_mode', themeMode);
  }

  Future<String?> getThemeMode() async {
    return await getString('theme_mode');
  }

  Future<void> saveLanguage(String language) async {
    await saveString('language', language);
  }

  Future<String?> getLanguage() async {
    return await getString('language');
  }

  Future<void> saveNotificationEnabled(bool enabled) async {
    await saveBool('notifications_enabled', enabled);
  }

  Future<bool> getNotificationEnabled() async {
    return await getBool('notifications_enabled') ?? true;
  }

  // Onboarding

  Future<void> setOnboardingCompleted(bool completed) async {
    await saveBool('onboarding_completed', completed);
  }

  Future<bool> isOnboardingCompleted() async {
    return await getBool('onboarding_completed') ?? false;
  }

  // Recent Searches

  Future<void> saveRecentSearches(List<String> searches) async {
    await saveStringList('recent_searches', searches);
  }

  Future<List<String>> getRecentSearches() async {
    return await getStringList('recent_searches') ?? [];
  }

  Future<void> addRecentSearch(String search) async {
    final searches = await getRecentSearches();
    searches.removeWhere((s) => s == search);
    searches.insert(0, search);
    if (searches.length > 10) {
      searches.removeLast();
    }
    await saveRecentSearches(searches);
  }

  Future<void> clearRecentSearches() async {
    await remove('recent_searches');
  }
}
