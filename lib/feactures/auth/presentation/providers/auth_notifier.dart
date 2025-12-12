import 'package:flutter/material.dart';
import 'package:redsocial/core/application/app_state.dart';
import 'package:redsocial/feactures/auth/domain/entities/user.dart';
import 'package:redsocial/feactures/auth/domain/usecase/login_usecase.dart';
import 'package:redsocial/feactures/auth/domain/usecase/register_usecase.dart';
import 'package:redsocial/core/error/exception.dart';

enum AuthStateStatus { initial, loading, success, error }

class AuthNotifier extends ChangeNotifier {
  final AppState appState;
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;

  AuthNotifier({
    required this.appState,
    required this.loginUseCase,
    required this.registerUseCase,
  });

  AuthStateStatus _status = AuthStateStatus.initial;
  String? _errorMessage;
  User? _currentUser;

  AuthStateStatus get status => _status;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _currentUser;

  Future<void> login(String email, String password) async {
    _status = AuthStateStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await loginUseCase.call(email, password);
      _currentUser = user;
      _status = AuthStateStatus.success;

      appState.login();
      notifyListeners();
    } catch (e) {
      _status = AuthStateStatus.error;
      if (e is ServerException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = e.toString().replaceAll('Exception:', '').trim();
      }
      notifyListeners();
    }
  }
  Future<void> register(String name, String email, String password) async {
    _status = AuthStateStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await registerUseCase.call(name, email, password);
      _currentUser = user;
      _status = AuthStateStatus.success;


      notifyListeners();
    } catch (e) {
      _status = AuthStateStatus.error;

      if (e is ServerException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = e.toString().replaceAll('Exception:', '').trim();
      }
      notifyListeners();
    }
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