import 'package:redsocial/feactures/home/domain/entities/posts.dart';
import '../../domain/repository/post_detail_repository.dart';
import '../datasource/post_detail_remote_datasource.dart';
import '../../domain/entities/comment.dart';
import '../models/add_comment_request_model.dart';

class PostDetailRepositoryImpl implements PostDetailRepository {
  final PostDetailRemoteDataSource remoteDataSource;

  PostDetailRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Posts> getPostDetail(String postId) {
    return remoteDataSource.fetchPostDetail(postId);
  }

  @override
  Future<List<Comment>> getPostComments(String postId) {
    return remoteDataSource.fetchPostComments(postId);
  }

  @override
  Future<Comment> addComment(String postId, String text) async {
    final request = AddCommentRequestModel(text: text);
    return await remoteDataSource.addComment(postId, request);
  }

  @override
  Future<void> toggleLike(String postId) {
    return remoteDataSource.toggleLike(postId);
  }
}