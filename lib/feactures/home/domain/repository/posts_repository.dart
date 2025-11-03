// feactures/home/domain/repository/posts_repository.dart

import '../entities/posts.dart';

abstract class PostsRepository {
  Future<List<Posts>> getPosts();
}