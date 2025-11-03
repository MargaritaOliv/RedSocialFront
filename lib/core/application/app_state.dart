import 'package:flutter/cupertino.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AppState extends ChangeNotifier {
  AuthStatus _authStatus = AuthStatus.unknown;

  AuthStatus get authStatus => _authStatus;

  Future<void> checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 3));
    _authStatus = AuthStatus.unauthenticated;
    notifyListeners();
  }

  void login() {
    _authStatus = AuthStatus.authenticated;
    notifyListeners();
  }

  void logout() {
    _authStatus = AuthStatus.unauthenticated;
    notifyListeners();
  }
}