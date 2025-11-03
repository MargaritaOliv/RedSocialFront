// feactures/profile/data/datasource/profile_remote_datasource.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:redsocial/core/network/http_client.dart';
import 'package:redsocial/core/error/exception.dart';
import 'package:redsocial/feactures/home/data/models/posts_model.dart'; // Para las publicaciones
import '../models/user_profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfileModel> fetchMyProfile();
  Future<List<PostsModel>> fetchMyPosts();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final http.Client client;

  ProfileRemoteDataSourceImpl({http.Client? client})
      : client = client ?? HttpClient().client;

  String get baseUrl => dotenv.env['API_URL'] ?? 'http://localhost:3000';

  // TODO: Implementar la obtención segura del Token de Auth
  final String dummyToken = 'YOUR_AUTH_TOKEN_FROM_STORAGE';

  @override
  Future<UserProfileModel> fetchMyProfile() async {
    // Endpoint: GET http://localhost:3000/api/users/me
    final url = Uri.parse('$baseUrl/api/users/me');

    try {
      final response = await client.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $dummyToken",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = json.decode(response.body);
        return UserProfileModel.fromJson(decoded['user'] ?? decoded);
      } else {
        throw ServerException("Error al obtener perfil. Código: ${response.statusCode}");
      }
    } catch (e) {
      throw NetworkException("Error de red al obtener perfil: $e");
    }
  }

  @override
  Future<List<PostsModel>> fetchMyPosts() async {
    // Endpoint: GET http://localhost:3000/api/users/me/posts
    final url = Uri.parse('$baseUrl/api/users/me/posts');

    try {
      final response = await client.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $dummyToken",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> decoded = json.decode(response.body);
        return decoded.map((e) => PostsModel.fromJson(e)).toList();
      } else {
        throw ServerException("Error al obtener posts. Código: ${response.statusCode}");
      }
    } catch (e) {
      throw NetworkException("Error de red al obtener posts: $e");
    }
  }
}