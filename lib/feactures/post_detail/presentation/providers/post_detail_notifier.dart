import 'package:flutter/material.dart';
import 'package:redsocial/feactures/home/domain/entities/posts.dart';
import 'package:redsocial/feactures/post_detail/domain/entities/comment.dart';
import 'package:redsocial/feactures/post_detail/domain/usecase/add_comment_usecase.dart';
import 'package:redsocial/feactures/post_detail/domain/usecase/get_post_full_data_usecase.dart';
import 'package:redsocial/feactures/post_detail/domain/usecase/toggle_like_usecase.dart';
import 'package:redsocial/feactures/post_detail/data/datasource/post_detail_remote_datasource.dart';
import 'package:redsocial/feactures/post_detail/data/repository/post_detail_repository_impl.dart';

enum PostDetailStatus { initial, loading, loaded, error }

class PostDetailNotifier extends ChangeNotifier {
  late final GetPostFullDataUseCase _getDataUseCase;
  late final AddCommentUseCase _addCommentUseCase;
  late final ToggleLikeUseCase _toggleLikeUseCase;

  PostDetailNotifier() {
    final dataSource = PostDetailRemoteDataSourceImpl();
    final repository = PostDetailRepositoryImpl(remoteDataSource: dataSource);

    _getDataUseCase = GetPostFullDataUseCase(repository);
    _addCommentUseCase = AddCommentUseCase(repository);
    _toggleLikeUseCase = ToggleLikeUseCase(repository);
  }

  PostDetailStatus _status = PostDetailStatus.initial;
  String? _errorMessage;
  Posts? _post;
  List<Comment> _comments = [];
  bool _isLiked = false;

  PostDetailStatus get status => _status;
  String? get errorMessage => _errorMessage;
  Posts? get post => _post;
  List<Comment> get comments => _comments;
  bool get isLiked => _isLiked;

  Future<void> fetchPostDetail(String postId) async {
    _status = PostDetailStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await _getDataUseCase.call(postId);
      _post = data.post;
      _comments = data.comments;
      _isLiked = false;

      _status = PostDetailStatus.loaded;
      notifyListeners();

    } catch (e) {
      _status = PostDetailStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> addComment(String postId, String text) async {
    if (text.trim().isEmpty) return;

    try {
      final newComment = await _addCommentUseCase.call(postId, text);

      _comments.insert(0, newComment);
      notifyListeners();

    } catch (e) {
      print('Error al añadir comentario: $e');
    }
  }

  Future<void> toggleLike(String postId) async {
    _isLiked = !_isLiked;
    notifyListeners();

    try {
      await _toggleLikeUseCase.call(postId);
    } catch (e) {
      _isLiked = !_isLiked;
      notifyListeners();
      print('Error al cambiar like: $e');
    }
  }
}