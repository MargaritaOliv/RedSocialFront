// lib/feactures/auth/presentation/providers/auth_notifier.dart

import 'package:flutter/foundation.dart';
import 'package:redsocial/core/application/app_state.dart';
import 'package:redsocial/feactures/auth/domain/entities/user.dart';

enum AuthStateStatus { initial, loading, success, error }

class AuthNotifier extends ChangeNotifier {
  final AppState appState;

  AuthNotifier(this.appState);

  AuthStateStatus _status = AuthStateStatus.initial;
  String? _errorMessage;
  User? _currentUser;

  AuthStateStatus get status => _status;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _currentUser;

  // ✨ LOGIN SIMULADO (acepta cualquier email/password)
  Future<void> login(String email, String password) async {
    _status = AuthStateStatus.loading;
    _errorMessage = null;
    notifyListeners();

    // Simula delay de red
    await Future.delayed(const Duration(seconds: 1));

    try {
      // ✨ VALIDACIÓN SIMPLE SIMULADA
      if (email.isEmpty || !email.contains('@')) {
        throw Exception('Email inválido');
      }
      if (password.isEmpty || password.length < 6) {
        throw Exception('Contraseña debe tener al menos 6 caracteres');
      }

      // ✨ USUARIO SIMULADO
      _currentUser = User(
        id: '1',
        name: 'Usuario Demo',
        email: email,
        avatar: null,
        bio: 'Usuario de prueba',
      );

      _status = AuthStateStatus.success;
      appState.login(); // Cambia el estado de autenticación
      notifyListeners();
    } catch (e) {
      _status = AuthStateStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void setUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  Future<void> logout() async {
    _currentUser = null;
    _status = AuthStateStatus.initial;
    appState.logout();
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    _status = AuthStateStatus.initial;
    notifyListeners();
  }
}