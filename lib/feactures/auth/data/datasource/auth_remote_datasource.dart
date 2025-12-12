import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:redsocial/core/network/http_client.dart';
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
  final String baseUrl;

  AuthRemoteDataSourceImpl({HttpClient? httpClient})
      : client = (httpClient ?? HttpClient()).client,
        baseUrl = (httpClient ?? HttpClient()).baseUrl;

  @override
  Future<LoginResponseModel> login(LoginRequestModel loginRequest) async {
    final url = Uri.parse('$baseUrl/auth/login');

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
        final errorBody = json.decode(response.body);
        throw ServerException(errorBody['message'] ?? "Error al iniciar sesión");
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException(e.toString());
    }
  }

  @override
  Future<UserModel> register(String name, String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/register');

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

      if (response.statusCode == 201) {
        return UserModel(
          id: '',
          name: name,
          email: email,
        );
      } else {
        final errorBody = json.decode(response.body);
        throw ServerException(errorBody['message'] ?? "Error al registrar usuario");
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException(e.toString());
    }
  }
}