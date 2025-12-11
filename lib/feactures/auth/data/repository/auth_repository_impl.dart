import 'package:redsocial/feactures/auth/data/datasource/auth_remote_datasource.dart';
import 'package:redsocial/feactures/auth/data/models/login_request_model.dart';
import 'package:redsocial/feactures/auth/domain/entities/user.dart';
import 'package:redsocial/feactures/auth/domain/repository/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImpl({required this.authRemoteDataSource});

  @override
  Future<User> login(String email, String password) async {
    final loginRequest = LoginRequestModel(email: email, password: password);

    final response = await authRemoteDataSource.login(loginRequest);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', response.token);

    await prefs.setString('userId', response.user.id);
    await prefs.setString('userName', response.user.name);

    return response.user;
  }

  @override
  Future<User> register(String name, String email, String password) async {
    final userModel = await authRemoteDataSource.register(name, email, password);
    return userModel;
  }

  @override
  Future<User?> getCurrentUser() async {
    return null;
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
    await prefs.remove('userName');
  }
}