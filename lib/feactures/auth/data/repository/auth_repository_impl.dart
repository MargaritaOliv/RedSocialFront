// lib/feactures/auth/data/repository/auth_repository_impl.dart

import 'package:redsocial/feactures/auth/data/datasource/auth_remote_datasource.dart';
import 'package:redsocial/feactures/auth/data/models/login_request_model.dart';
import 'package:redsocial/feactures/auth/domain/entities/user.dart';
import 'package:redsocial/feactures/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImpl({required this.authRemoteDataSource});

  @override
  Future<User> login(String email, String password) async {
    final loginRequest = LoginRequestModel(email: email, password: password);
    final response = await authRemoteDataSource.login(loginRequest);
    // Aquí se podría guardar el token (response.token) en SharedPreferences/SecureStorage
    return response.user;
  }

  @override
  Future<User> register(String name, String email, String password) async {
    // Llama al datasource para registrar, que devuelve el UserModel.
    final userModel = await authRemoteDataSource.register(name, email, password);
    return userModel; // UserModel extiende User, por lo que cumple con el contrato.
  }

  @override
  Future<User?> getCurrentUser() {
    // TODO: Implementar lógica para obtener el usuario de almacenamiento local.
    return Future.value(null);
  }

  @override
  Future<void> logout() {
    // TODO: Implementar lógica para limpiar el token de autenticación.
    return Future.value();
  }
}