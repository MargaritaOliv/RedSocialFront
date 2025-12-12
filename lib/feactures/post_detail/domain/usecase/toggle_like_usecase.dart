import '../repository/post_detail_repository.dart';

class ToggleLikeUseCase {
  final PostDetailRepository repository;

  ToggleLikeUseCase(this.repository);

  Future<void> call(String postId) async {
    await repository.toggleLike(postId);
  }
}