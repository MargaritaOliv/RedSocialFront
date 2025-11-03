// feactures/home/presentation/providers/posts_notifier.dart

import 'package:flutter/material.dart';
import 'package:redsocial/feactures/home/domain/entities/posts.dart'; // Correcto
import 'package:redsocial/feactures/home/domain/usecase/get_posts_usecase.dart'; // Correcto

// Dependencias de inyección (ajustadas al path feactures/home/...)
import 'package:redsocial/feactures/home/data/datasource/posts_remote_datasource.dart';
import 'package:redsocial/feactures/home/data/repository/posts_repository_impl.dart';

enum PostsStateStatus { initial, loading, loaded, error }

class PostsNotifier extends ChangeNotifier {
  late final GetPostsUseCase _getPostsUseCase;

  PostsNotifier() {
    // Inyección de dependencias manual
    final remoteDataSource = PostsRemoteDataSourceImpl();
    final postsRepository = PostsRepositoryImpl(remoteDataSource: remoteDataSource);
    _getPostsUseCase = GetPostsUseCase(postsRepository);
  }

  PostsStateStatus _status = PostsStateStatus.initial;
  String? _errorMessage;
  List<Posts> _posts = [];

  PostsStateStatus get status => _status;
  String? get errorMessage => _errorMessage;
  List<Posts> get posts => _posts;

  Future<void> fetchPosts() async {
    if (_status == PostsStateStatus.loading) return;

    _status = PostsStateStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _posts = await _getPostsUseCase.call();

      _status = PostsStateStatus.loaded;
      notifyListeners();

    } catch (e) {
      _status = PostsStateStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}