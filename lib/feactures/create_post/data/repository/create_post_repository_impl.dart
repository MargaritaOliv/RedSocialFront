// feactures/create_post/data/repository/create_post_repository_impl.dart

import '../../domain/repository/create_post_repository.dart';
import '../datasource/create_post_remote_datasource.dart';
import '../models/create_post_request_model.dart';

class CreatePostRepositoryImpl implements CreatePostRepository {
  final CreatePostRemoteDataSource remoteDataSource;

  CreatePostRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> createPost({
    required String title,
    required String imageUrl,
    required String category,
    required String description,
  }) async {
    final request = CreatePostRequestModel(
      title: title,
      imageUrl: imageUrl,
      category: category,
      description: description,
    );

    await remoteDataSource.createPost(request);
  }
}