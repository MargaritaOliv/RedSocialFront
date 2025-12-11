import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:redsocial/core/network/http_client.dart';
import 'package:redsocial/core/error/exception.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importante
import '../models/create_post_request_model.dart';

abstract class CreatePostRemoteDataSource {
  Future<void> createPost(CreatePostRequestModel postRequest);
}

class CreatePostRemoteDataSourceImpl implements CreatePostRemoteDataSource {
  final http.Client client;

  CreatePostRemoteDataSourceImpl({http.Client? client})
      : client = client ?? HttpClient().client;

  String get baseUrl => dotenv.env['API_URL'] ?? 'http://localhost:3000';

  // --- LÓGICA DE SEGURIDAD (Igual que en Home) ---
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw ServerException("Debes iniciar sesión para publicar.");
    }

    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }
  // ----------------------------------------------

  @override
  Future<void> createPost(CreatePostRequestModel postRequest) async {
    // Endpoint: /api/posts
    final url = Uri.parse('$baseUrl/api/posts');

    try {
      final response = await client.post(
        url,
        headers: await _getHeaders(), // Inyectamos el Token
        body: json.encode(postRequest.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return; // Éxito
      } else {
        // Intentamos leer el mensaje de error del servidor
        String msg = "Error al crear publicación (${response.statusCode})";
        try {
          final errorBody = json.decode(response.body);
          if (errorBody['message'] != null) {
            msg = errorBody['message'];
          }
        } catch (_) {}

        throw ServerException(msg);
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException("Error de red: $e");
    }
  }
}