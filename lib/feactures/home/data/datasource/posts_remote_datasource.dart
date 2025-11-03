// feactures/home/data/datasource/posts_remote_datasource.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:redsocial/core/network/http_client.dart'; // Correcto
import 'package:redsocial/core/error/exception.dart'; // Correcto
import '../models/posts_model.dart';

abstract class PostsRemoteDataSource {
  Future<List<PostsModel>> fetchPosts();
}

class PostsRemoteDataSourceImpl implements PostsRemoteDataSource {
  final http.Client client;

  PostsRemoteDataSourceImpl({http.Client? client})
      : client = client ?? HttpClient().client;

  @override
  Future<List<PostsModel>> fetchPosts() async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts');

    try {
      final response = await client.get(
        url,
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> decoded = json.decode(response.body);
        return decoded.map((e) => PostsModel.fromJson(e)).toList();
      } else {
        // En tu proyecto real, aquí lanzarías una ServerException
        throw Exception("Error al cargar posts: Código ${response.statusCode}");
      }
    } catch (e, stacktrace) {
      print("Error en fetchPosts: $e");
      print(stacktrace);
      // En tu proyecto real, aquí lanzarías una NetworkException
      throw Exception("Error de red o cliente: $e");
    }
  }
}