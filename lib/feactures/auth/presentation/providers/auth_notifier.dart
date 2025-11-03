import 'package:flutter/foundation.dart';
import 'package:redsocial/core/application/app_state.dart';
import 'package:redsocial/feactures/auth/data/datasource/auth_remote_datasource.dart';
import 'package:redsocial/feactures/auth/data/repository/auth_repository_impl.dart';
import 'package:redsocial/feactures/auth/domain/entities/user.dart';
import 'package:redsocial/feactures/auth/domain/usecase/login_usecase.dart';

enum AuthStateStatus { initial, loading, success, error }

class AuthNotifier extends ChangeNotifier {
  final AppState appState;

  // Inicializar las dependencias dentro del notifier
  late final LoginUseCase _loginUseCase;

  AuthNotifier(this.appState) {
    // Inyección de dependencias manual (patrón del profesor)
    final authRemoteDataSource = AuthRemoteDataSourceImpl();
    final authRepository = AuthRepositoryImpl(
      authRemoteDataSource: authRemoteDataSource,
    );
    _loginUseCase = LoginUseCase(authRepository);
  }

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
      // Llamar al use case
      _currentUser = await _loginUseCase.call(email, password);

      _status = AuthStateStatus.success;
      appState.login();
      notifyListeners();
    } catch (e) {
      _status = AuthStateStatus.error;
      _errorMessage = e.toString();
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