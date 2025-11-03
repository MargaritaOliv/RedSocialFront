// lib/feactures/auth/data/datasource/auth_remote_datasource.dart

import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:redsocial/core/network/http_client.dart';
import 'package:http/http.dart' as http;
import '../../../../core/error/exception.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login(LoginRequestModel loginRequest);
  Future<UserModel> register(String name, String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl({http.Client? client})
      : client = client ?? HttpClient().client;

  // Obtener la URL base desde .env
  String get baseUrl => dotenv.env['API_URL'] ?? 'http://localhost:3000';

  @override
  Future<LoginResponseModel> login(LoginRequestModel loginRequest) async {
    // AJUSTE DE ENDPOINT: /api/auth/login
    final url = Uri.parse('$baseUrl/api/auth/login');

    try {
      final response = await client.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode(loginRequest.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> decoded = json.decode(response.body);
        return LoginResponseModel.fromJson(decoded);
      } else {
        throw ServerException("Error al iniciar sesión. Código: ${response.statusCode}");
      }
    } catch (e, stacktrace) {
      print("Error en login: $e");
      print(stacktrace);
      throw NetworkException(e.toString());
    }
  }

  @override
  Future<UserModel> register(String name, String email, String password) async {
    // AJUSTE DE ENDPOINT: /api/auth/register
    final url = Uri.parse('$baseUrl/api/auth/register');

    try {
      final response = await client.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> decoded = json.decode(response.body);
        // Asumimos que la respuesta incluye el UserModel
        return UserModel.fromJson(decoded['user'] ?? decoded);
      } else {
        throw ServerException("Error al registrar. Código: ${response.statusCode}");
      }
    } catch (e, stacktrace) {
      print("Error en register: $e");
      print(stacktrace);
      throw NetworkException(e.toString());
    }
  }
}