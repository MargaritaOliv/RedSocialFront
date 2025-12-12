import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:redsocial/core/network/http_client.dart';
import 'package:redsocial/core/error/exception.dart';
import 'package:redsocial/feactures/home/data/models/posts_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final String baseUrl;

  PostDetailRemoteDataSourceImpl({HttpClient? httpClient})
      : client = (httpClient ?? HttpClient()).client,
        baseUrl = (httpClient ?? HttpClient()).baseUrl;

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw ServerException("Debes iniciar sesión.");
    }

    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  @override
  Future<PostsModel> fetchPostDetail(String postId) async {
    final url = Uri.parse('$baseUrl/posts/$postId');
    try {
      final response = await client.get(url, headers: await _getHeaders());
      if (response.statusCode == 200) {
        final dynamic decoded = json.decode(response.body);
        return PostsModel.fromJson(decoded);
      } else {
        throw ServerException("Error al obtener post: ${response.statusCode}");
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException("Error de red: $e");
    }
  }

  @override
  Future<List<CommentModel>> fetchPostComments(String postId) async {
    final url = Uri.parse('$baseUrl/posts/$postId/comments');
    try {
      final response = await client.get(url, headers: await _getHeaders());
      if (response.statusCode == 200) {
        final List<dynamic> decoded = json.decode(response.body);
        return decoded.map((e) => CommentModel.fromJson(e)).toList();
      } else {
        throw ServerException("Error al cargar comentarios: ${response.statusCode}");
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException("Error de red: $e");
    }
  }

  @override
  Future<CommentModel> addComment(String postId, AddCommentRequestModel request) async {
    final url = Uri.parse('$baseUrl/posts/$postId/comments');
    try {
      final response = await client.post(
        url,
        headers: await _getHeaders(),
        body: json.encode(request.toJson()),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final dynamic decoded = json.decode(response.body);
        return CommentModel.fromJson(decoded);
      } else {
        throw ServerException("Error al publicar comentario: ${response.statusCode}");
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException("Error de red: $e");
    }
  }

  @override
  Future<void> toggleLike(String postId) async {
    final url = Uri.parse('$baseUrl/posts/$postId/like');
    try {
      final response = await client.post(
        url,
        headers: await _getHeaders(),
      );
      if (response.statusCode != 200) {
        throw ServerException("Error al dar like: ${response.statusCode}");
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException("Error de red: $e");
    }
  }
}