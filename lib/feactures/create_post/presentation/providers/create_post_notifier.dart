import 'package:flutter/material.dart';
import 'package:redsocial/feactures/create_post/domain/usecase/create_new_post_usecase.dart';

enum CreatePostStatus { initial, loading, success, error }

class CreatePostNotifier extends ChangeNotifier {
  final CreateNewPostUseCase createNewPostUseCase; // Inyección

  CreatePostNotifier({required this.createNewPostUseCase});

  CreatePostStatus _status = CreatePostStatus.initial;
  String? _errorMessage;

  CreatePostStatus get status => _status;
  String? get errorMessage => _errorMessage;

  Future<void> createPost({
    required String title,
    required String imageUrl,
    required String category,
    required String description,
  }) async {
    _status = CreatePostStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // LLAMADA REAL
      await createNewPostUseCase.call(
        title: title,
        imageUrl: imageUrl,
        category: category,
        description: description,
      );

      _status = CreatePostStatus.success;
      notifyListeners();
    } catch (e) {
      _status = CreatePostStatus.error;
      _errorMessage = e.toString().replaceAll('Exception:', '').trim();
      notifyListeners();
    }
  }

  void clearStatus() {
    _status = CreatePostStatus.initial;
    _errorMessage = null;
    notifyListeners();
  }
}