// feactures/create_post/domain/repository/create_post_repository.dart

abstract class CreatePostRepository {
  Future<void> createPost({
    required String title,
    required String imageUrl,
    required String category,
    required String description,
  });
}