import '../entities/posts.dart';

abstract class PostsRepository {
  Future<List<Posts>> getPosts();
}