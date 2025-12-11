import 'package:flutter/material.dart';
import 'package:redsocial/feactures/home/domain/entities/posts.dart';
import 'package:redsocial/feactures/home/domain/usecase/get_posts_usecase.dart';

enum PostsStateStatus { initial, loading, loaded, error }

class PostsNotifier extends ChangeNotifier {
  // Inyectamos el UseCase en lugar de crearlo dentro
  final GetPostsUseCase getPostsUseCase;

  PostsNotifier({required this.getPostsUseCase});

  PostsStateStatus _status = PostsStateStatus.initial;
  String? _errorMessage;
  List<Posts> _posts = [];

  PostsStateStatus get status => _status;
  String? get errorMessage => _errorMessage;
  List<Posts> get posts => _posts;

  Future<void> fetchPosts() async {
    _status = PostsStateStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _posts = await getPostsUseCase.call();
      _status = PostsStateStatus.loaded;
      notifyListeners();
    } catch (e) {
      _status = PostsStateStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}