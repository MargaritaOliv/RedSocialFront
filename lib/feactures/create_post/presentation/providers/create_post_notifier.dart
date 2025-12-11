// lib/feactures/create_post/presentation/providers/create_post_notifier.dart

import 'package:flutter/material.dart';

enum CreatePostStatus { initial, loading, success, error }

class CreatePostNotifier extends ChangeNotifier {
  CreatePostStatus _status = CreatePostStatus.initial;
  String? _errorMessage;

  CreatePostStatus get status => _status;
  String? get errorMessage => _errorMessage;

  // ✨ SIMULACIÓN: Crear post fake
  Future<void> createPost({
    required String title,
    required String imageUrl,
    required String category,
    required String description,
  }) async {
    _status = CreatePostStatus.loading;
    _errorMessage = null;
    notifyListeners();

    // Simula delay de red
    await Future.delayed(const Duration(seconds: 2));

    try {
      // ✨ VALIDACIÓN SIMPLE
      if (title.isEmpty) throw Exception('El título es requerido');
      if (description.isEmpty) throw Exception('La descripción es requerida');

      // ✨ ÉXITO SIMULADO
      print('✅ Post creado: $title');

      _status = CreatePostStatus.success;
      notifyListeners();
    } catch (e) {
      _status = CreatePostStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void clearStatus() {
    _status = CreatePostStatus.initial;
    _errorMessage = null;
    notifyListeners();
  }
}