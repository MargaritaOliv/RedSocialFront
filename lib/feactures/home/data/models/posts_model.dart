import '../../domain/entities/posts.dart';

class PostsModel extends Posts {
  PostsModel({
    required super.id,
    required super.title,
    required super.description,
    required super.imageUrl,
    required super.authorName,
    super.authorPhoto,
  });

  factory PostsModel.fromJson(Map<String, dynamic> json) {
    return PostsModel(
      // Convertimos a String por seguridad, ya que a veces las APIs mandan int
      id: json['id'].toString(),
      title: json['title'] ?? 'Sin título',
      // Tu API puede mandar 'description' o 'body', ajusta según tu backend.
      // Aquí asumo que viene en 'description' o 'body'.
      description: json['description'] ?? json['body'] ?? '',
      imageUrl: json['imageUrl'] ?? 'https://via.placeholder.com/300',
      authorName: json['authorName'] ?? json['user']?['name'] ?? 'Anónimo',
      authorPhoto: json['authorPhoto'] ?? json['user']?['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'authorName': authorName,
      'authorPhoto': authorPhoto,
    };
  }
}