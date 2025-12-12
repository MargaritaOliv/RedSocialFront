import '../repository/create_post_repository.dart';


class CreateNewPostUseCase {
  final CreatePostRepository repository;

  CreateNewPostUseCase(this.repository);

  Future<void> call({
    required String title,
    required String imageUrl,
    required String category,
    required String description,
  }) async {
    await repository.createPost(
      title: title,
      imageUrl: imageUrl,
      category: category,
      description: description,
    );
  }
}