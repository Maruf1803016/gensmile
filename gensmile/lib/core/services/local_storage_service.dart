import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static SharedPreferences? _prefs;

  Future<SharedPreferences> get _instancePrefs async {
    if (_prefs != null) return _prefs!;
    _prefs = await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<void> saveToken(String token) async {
    final prefs = await _instancePrefs;
    await prefs.setString('auth_token', token);
  }

  Future<String?> getToken() async {
    final prefs = await _instancePrefs;
    return prefs.getString('auth_token');
  }

  Future<void> removeToken() async {
    final prefs = await _instancePrefs;
    await prefs.remove('auth_token');
  }

  Future<void> saveProfile(Map<String, dynamic> profile) async {
    final prefs = await _instancePrefs;
    final jsonString = jsonEncode(profile);
    await prefs.setString('user_profile', jsonString);
  }

  Future<Map<String, dynamic>?> getProfile() async {
    final prefs = await _instancePrefs;
    final jsonString = prefs.getString('user_profile');
    if (jsonString != null) {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    }
    return null;
  }

  Future<void> removeProfile() async {
    final prefs = await _instancePrefs;
    await prefs.remove('user_profile');
  }

  Future<void> clearAll() async {
    final prefs = await _instancePrefs;
    await prefs.clear();
  }
}
