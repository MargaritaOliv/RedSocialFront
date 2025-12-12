
import 'package:redsocial/feactures/home/domain/entities/posts.dart';
import '../entities/comment.dart';

abstract class PostDetailRepository {
  Future<Posts> getPostDetail(String postId);
  Future<List<Comment>> getPostComments(String postId);
  Future<Comment> addComment(String postId, String text);
  Future<void> toggleLike(String postId);
}