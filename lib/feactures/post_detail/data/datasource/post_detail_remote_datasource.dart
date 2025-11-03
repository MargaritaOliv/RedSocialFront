// feactures/post_detail/data/datasource/post_detail_remote_datasource.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:redsocial/core/network/http_client.dart';
import 'package:redsocial/core/error/exception.dart';
import 'package:redsocial/feactures/home/data/models/posts_model.dart'; // Reutilizamos PostsModel
import '../models/comment_model.dart';
import '../models/add_comment_request_model.dart';

abstract class PostDetailRemoteDataSource {
  Future<PostsModel> fetchPostDetail(String postId);
  Future<List<CommentModel>> fetchPostComments(String postId);
  Future<CommentModel> addComment(String postId, AddCommentRequestModel request);
  Future<void> toggleLike(String postId);
}

class PostDetailRemoteDataSourceImpl implements PostDetailRemoteDataSource {
  final http.Client client;

  PostDetailRemoteDataSourceImpl({http.Client? client})
      : client = client ?? HttpClient().client;

  String get baseUrl => dotenv.env['API_URL'] ?? 'http://localhost:3000';

  // TODO: Implementar la obtención segura del Token de Auth
  final String dummyToken = 'YOUR_AUTH_TOKEN_FROM_STORAGE';

  @override
  Future<PostsModel> fetchPostDetail(String postId) async {
    // GET /api/posts/:id
    final url = Uri.parse('$baseUrl/api/posts/$postId');

    try {
      final response = await client.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = json.decode(response.body);
        return PostsModel.fromJson(decoded['post'] ?? decoded);
      } else {
        throw ServerException("Error al obtener post: ${response.statusCode}");
      }
    } catch (e) {
      throw NetworkException("Error de red al obtener post: $e");
    }
  }

  @override
  Future<List<CommentModel>> fetchPostComments(String postId) async {
    // GET /api/posts/:id/comments
    final url = Uri.parse('$baseUrl/api/posts/$postId/comments');

    try {
      final response = await client.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> decoded = json.decode(response.body);
        return decoded.map((e) => CommentModel.fromJson(e)).toList();
      } else {
        throw ServerException("Error al obtener comentarios: ${response.statusCode}");
      }
    } catch (e) {
      throw NetworkException("Error de red al obtener comentarios: $e");
    }
  }

  @override
  Future<CommentModel> addComment(String postId, AddCommentRequestModel request) async {
    // POST /api/posts/:id/comments
    final url = Uri.parse('$baseUrl/api/posts/$postId/comments');

    try {
      final response = await client.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $dummyToken",
        },
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> decoded = json.decode(response.body);
        return CommentModel.fromJson(decoded['comment'] ?? decoded);
      } else {
        throw ServerException("Error al añadir comentario: ${response.statusCode}");
      }
    } catch (e) {
      throw NetworkException("Error de red al añadir comentario: $e");
    }
  }

  @override
  Future<void> toggleLike(String postId) async {
    // POST /api/posts/:id/like
    final url = Uri.parse('$baseUrl/api/posts/$postId/like');

    try {
      final response = await client.post(
        url,
        headers: {
          "Authorization": "Bearer $dummyToken",
        },
      );

      if (response.statusCode != 200) {
        throw ServerException("Error al dar like: ${response.statusCode}");
      }
    } catch (e) {
      throw NetworkException("Error de red al dar like: $e");
    }
  }
}