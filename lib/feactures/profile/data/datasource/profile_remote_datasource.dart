import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:redsocial/core/network/http_client.dart';
import 'package:redsocial/core/error/exception.dart';
import 'package:redsocial/feactures/home/data/models/posts_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfileModel> fetchMyProfile();
  Future<List<PostsModel>> fetchMyPosts();
  Future<UserProfileModel> updateProfile(String name, String bio, String profilePic);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  ProfileRemoteDataSourceImpl({HttpClient? httpClient})
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
  Future<UserProfileModel> fetchMyProfile() async {
    final url = Uri.parse('$baseUrl/users/me');
    try {
      final response = await client.get(url, headers: await _getHeaders());
      if (response.statusCode == 200) {
        final dynamic decoded = json.decode(response.body);
        return UserProfileModel.fromJson(decoded);
      } else {
        throw ServerException("Error al cargar perfil: ${response.statusCode}");
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException("Error de red: $e");
    }
  }

  @override
  Future<List<PostsModel>> fetchMyPosts() async {
    final url = Uri.parse('$baseUrl/users/me/posts');
    try {
      final response = await client.get(url, headers: await _getHeaders());
      if (response.statusCode == 200) {
        final List<dynamic> decoded = json.decode(response.body);
        return decoded.map((e) => PostsModel.fromJson(e)).toList();
      } else {
        throw ServerException("Error al cargar mis posts: ${response.statusCode}");
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException("Error de red: $e");
    }
  }

  @override
  Future<UserProfileModel> updateProfile(String name, String bio, String profilePic) async {
    final url = Uri.parse('$baseUrl/users/me'); // PUT

    try {
      final response = await client.put(
        url,
        headers: await _getHeaders(),
        body: json.encode({
          'name': name,
          'bio': bio,
          'profilePic': profilePic,
        }),
      );

      if (response.statusCode == 200) {
        final dynamic decoded = json.decode(response.body);
        return UserProfileModel.fromJson(decoded);
      } else {
        throw ServerException("Error al actualizar perfil: ${response.statusCode}");
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException("Error de red: $e");
    }
  }
}