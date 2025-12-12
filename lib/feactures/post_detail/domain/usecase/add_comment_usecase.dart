
import '../entities/comment.dart';
import '../repository/post_detail_repository.dart';

class AddCommentUseCase {
  final PostDetailRepository repository;

  AddCommentUseCase(this.repository);

  Future<Comment> call(String postId, String text) async {
    return await repository.addComment(postId, text);
  }
}