import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_user.dart';

class AuthService {
  static const _registeredUserKey = 'registered_user';
  static const _rememberedUserKey = 'remembered_user';

  Future<void> register(AppUser user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_registeredUserKey, jsonEncode(user.toJson()));
  }

  Future<AppUser?> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final rawUser = prefs.getString(_registeredUserKey);
    if (rawUser == null) return null;

    final user = AppUser.fromJson(jsonDecode(rawUser) as Map<String, dynamic>);
    if (user.email.toLowerCase() != email.toLowerCase() ||
        user.password != password) {
      return null;
    }

    if (rememberMe) {
      await prefs.setString(_rememberedUserKey, jsonEncode(user.toJson()));
    } else {
      await prefs.remove(_rememberedUserKey);
    }
    return user;
  }

  Future<AppUser?> loadRememberedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final rawUser = prefs.getString(_rememberedUserKey);
    if (rawUser == null) return null;
    return AppUser.fromJson(jsonDecode(rawUser) as Map<String, dynamic>);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_rememberedUserKey);
  }
}

