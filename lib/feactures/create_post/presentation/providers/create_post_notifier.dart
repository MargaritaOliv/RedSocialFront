// feactures/create_post/presentation/providers/create_post_notifier.dart

import 'package:flutter/material.dart';
import 'package:redsocial/core/error/exception.dart'; // Para manejar errores específicos
import 'package:redsocial/feactures/create_post/domain/usecase/create_new_post_usecase.dart';
import 'package:redsocial/feactures/create_post/data/datasource/create_post_remote_datasource.dart';
import 'package:redsocial/feactures/create_post/data/repository/create_post_repository_impl.dart';

enum CreatePostStatus { initial, loading, success, error }

class CreatePostNotifier extends ChangeNotifier {
  late final CreateNewPostUseCase _useCase;

  CreatePostNotifier() {
    // Inyección de dependencias manual
    final dataSource = CreatePostRemoteDataSourceImpl();
    final repository = CreatePostRepositoryImpl(remoteDataSource: dataSource);
    _useCase = CreateNewPostUseCase(repository);
  }

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
      await _useCase.call(
        title: title,
        imageUrl: imageUrl,
        category: category,
        description: description,
      );

      _status = CreatePostStatus.success;
      notifyListeners();

    } on ServerException catch (e) {
      _status = CreatePostStatus.error;
      _errorMessage = e.message;
      notifyListeners();
    } on NetworkException catch (e) {
      _status = CreatePostStatus.error;
      _errorMessage = e.message;
      notifyListeners();
    } catch (e) {
      _status = CreatePostStatus.error;
      _errorMessage = "Ocurrió un error inesperado.";
      notifyListeners();
    }
  }

  void clearStatus() {
    _status = CreatePostStatus.initial;
    _errorMessage = null;
    notifyListeners();
  }
}