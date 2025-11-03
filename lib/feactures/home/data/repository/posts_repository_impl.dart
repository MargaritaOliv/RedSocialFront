// feactures/home/data/repository/posts_repository_impl.dart

import '../../domain/entities/posts.dart';
import '../../domain/repository/posts_repository.dart';
import '../datasource/posts_remote_datasource.dart';

class PostsRepositoryImpl implements PostsRepository {
  final PostsRemoteDataSource remoteDataSource;

  PostsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Posts>> getPosts() async {
    return await remoteDataSource.fetchPosts();
  }
}