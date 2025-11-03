// feactures/home/data/models/posts_model.dart (CORREGIDO)

import '../../domain/entities/posts.dart';

class PostsModel extends Posts {
  final int userId;

  // Solución: Si usas required super.X, NO necesitas el inicializador ": super(X: X)"
  PostsModel({
    required this.userId,
    required super.id,
    required super.title,
    required super.body
  }); // <--- Se elimina el inicializador : super(...)

  factory PostsModel.fromJson(Map<String, dynamic> json) {
    return PostsModel(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}