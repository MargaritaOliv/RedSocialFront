// feactures/post_detail/domain/usecase/toggle_like_usecase.dart

import '../repository/post_detail_repository.dart';

class ToggleLikeUseCase {
  final PostDetailRepository repository;

  ToggleLikeUseCase(this.repository);

  Future<void> call(String postId) async {
    await repository.toggleLike(postId);
  }
}