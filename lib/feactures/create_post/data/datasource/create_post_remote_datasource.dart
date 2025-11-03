// feactures/create_post/data/datasource/create_post_remote_datasource.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:redsocial/core/network/http_client.dart';
import 'package:redsocial/core/error/exception.dart';
import '../models/create_post_request_model.dart';

abstract class CreatePostRemoteDataSource {
  Future<void> createPost(CreatePostRequestModel postRequest);
}

class CreatePostRemoteDataSourceImpl implements CreatePostRemoteDataSource {
  final http.Client client;

  CreatePostRemoteDataSourceImpl({http.Client? client})
      : client = client ?? HttpClient().client;

  String get baseUrl => dotenv.env['API_URL'] ?? 'http://localhost:3000';

  @override
  Future<void> createPost(CreatePostRequestModel postRequest) async {
    // Endpoint: POST http://localhost:3000/api/posts
    final url = Uri.parse('$baseUrl/api/posts');

    // TODO: Obtener el token de autorización (e.g., de SharedPreferences o AuthNotifier)
    const String dummyToken = 'YOUR_AUTH_TOKEN';

    try {
      final response = await client.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $dummyToken",
        },
        body: json.encode(postRequest.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return; // Éxito en la creación
      } else {
        throw ServerException("Error al crear publicación. Código: ${response.statusCode}");
      }
    } catch (e) {
      throw NetworkException("Error de red al crear publicación: $e");
    }
  }
}