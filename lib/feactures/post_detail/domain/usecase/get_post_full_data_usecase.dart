// feactures/post_detail/domain/usecase/get_post_full_data_usecase.dart

import 'package:redsocial/feactures/home/domain/entities/posts.dart';
import '../repository/post_detail_repository.dart';
import '../entities/comment.dart';

class PostFullData {
  final Posts post;
  final List<Comment> comments;

  PostFullData({required this.post, required this.comments});
}

class GetPostFullDataUseCase {
  final PostDetailRepository repository;

  GetPostFullDataUseCase(this.repository);

  Future<PostFullData> call(String postId) async {
    // Cargamos post y comentarios en paralelo
    final postFuture = repository.getPostDetail(postId);
    final commentsFuture = repository.getPostComments(postId);

    final results = await Future.wait([postFuture, commentsFuture]);

    final post = results[0] as Posts;
    final comments = results[1] as List<Comment>;

    return PostFullData(post: post, comments: comments);
  }
}