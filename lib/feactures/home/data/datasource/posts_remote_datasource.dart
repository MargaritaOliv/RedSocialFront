import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:redsocial/core/network/http_client.dart';
import 'package:redsocial/core/error/exception.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/posts_model.dart';

abstract class PostsRemoteDataSource {
  Future<List<PostsModel>> fetchPosts();
}

class PostsRemoteDataSourceImpl implements PostsRemoteDataSource {
  final http.Client client;

  PostsRemoteDataSourceImpl({http.Client? client})
      : client = client ?? HttpClient().client;

  String get baseUrl => dotenv.env['API_URL'] ?? 'http://localhost:3000';

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw ServerException("No has iniciado sesión.");
    }

    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }


  @override
  Future<List<PostsModel>> fetchPosts() async {
    final url = Uri.parse('$baseUrl/api/posts/feed');

    try {
      final response = await client.get(
        url,
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> decoded = json.decode(response.body);
        return decoded.map((e) => PostsModel.fromJson(e)).toList();
      } else if (response.statusCode == 401) {
        throw ServerException("Sesión expirada. Por favor ingresa nuevamente.");
      } else {
        throw ServerException("Error del servidor: ${response.statusCode}");
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException("Error de conexión: $e");
    }
  }
}