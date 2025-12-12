import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:redsocial/core/network/http_client.dart';
import 'package:redsocial/core/error/exception.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/create_post_request_model.dart';

abstract class CreatePostRemoteDataSource {
  Future<void> createPost(CreatePostRequestModel postRequest);
}

class CreatePostRemoteDataSourceImpl implements CreatePostRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  CreatePostRemoteDataSourceImpl({HttpClient? httpClient})
      : client = (httpClient ?? HttpClient()).client,
        baseUrl = (httpClient ?? HttpClient()).baseUrl;

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print('❌ [DataSource] Token es NULL');
      throw ServerException("Debes iniciar sesión para publicar.");
    }
    print('✅ [DataSource] Token encontrado: ${token.substring(0, 10)}...');

    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  @override
  Future<void> createPost(CreatePostRequestModel postRequest) async {
    final url = Uri.parse('$baseUrl/posts');

    print('------------------------------------------------');
    print('📤 [DataSource] Enviando a: $url');
    print('📦 Body: ${json.encode(postRequest.toJson())}');

    try {
      final headers = await _getHeaders();
      final response = await client.post(
        url,
        headers: headers,
        body: json.encode(postRequest.toJson()),
      );

      print('📥 [DataSource] Respuesta: ${response.statusCode}');
      print('📄 Body Resp: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return; // Éxito
      } else {
        String msg = "Error (${response.statusCode})";
        try {
          final errorBody = json.decode(response.body);
          if (errorBody['message'] != null) {
            msg = errorBody['message'];
          }
        } catch (_) {}
        throw ServerException(msg);
      }
    } catch (e) {
      print('💥 [DataSource] Error: $e');
      if (e is ServerException) rethrow;
      throw NetworkException("Error de red: $e");
    }
  }
}