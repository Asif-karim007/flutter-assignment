import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user_model.dart';

class StorageService {
  static const _userKey = 'cached_user';
  static const _tokenKey = 'auth_token';
  static const _themeKey = 'theme_mode';

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> saveUser(UserModel user) async {
    await _prefs?.setString(_userKey, jsonEncode(user.toJson()));
    await _prefs?.setString(_tokenKey, user.token);
  }

  UserModel? getUser() {
    final raw = _prefs?.getString(_userKey);
    if (raw == null || raw.isEmpty) return null;

    try {
      return UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  String? getToken() {
    final token = _prefs?.getString(_tokenKey);
    if (token == null || token.isEmpty) return null;
    return token;
  }

  Future<void> clearSession() async {
    await _prefs?.remove(_userKey);
    await _prefs?.remove(_tokenKey);
  }

  Future<void> saveThemeMode(bool isDarkMode) async {
    await _prefs?.setBool(_themeKey, isDarkMode);
  }

  bool getSavedThemeMode() {
    return _prefs?.getBool(_themeKey) ?? false;
  }
}
