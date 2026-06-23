import 'package:flutter/material.dart';

import '../models/app_enums.dart';
import '../models/app_user.dart';
import '../services/auth_service.dart';

class AuthController extends ChangeNotifier {
  AuthController(this._authService);

  final AuthService _authService;

  AuthStatus status = AuthStatus.unknown;
  AppUser? user;
  String? errorMessage;

  bool get isAuthenticated => status == AuthStatus.authenticated && user != null;

  Future<void> loadSession() async {
    user = await _authService.loadRememberedUser();
    status = user == null ? AuthStatus.unauthenticated : AuthStatus.authenticated;
    notifyListeners();
  }

  Future<bool> register(AppUser newUser) async {
    await _authService.register(newUser);
    status = AuthStatus.unauthenticated;
    errorMessage = null;
    notifyListeners();
    return true;
  }

  Future<bool> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    final loggedInUser = await _authService.login(
      email: email,
      password: password,
      rememberMe: rememberMe,
    );
    if (loggedInUser == null) {
      errorMessage = 'Invalid email or password';
      status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }

    user = loggedInUser;
    errorMessage = null;
    status = AuthStatus.authenticated;
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    await _authService.logout();
    user = null;
    status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}

