import '../../domain/entities/posts.dart';

class PostsModel extends Posts {
  PostsModel({
    required super.id,
    required super.title,
    required super.description,
    required super.imageUrl,
    required super.authorName,
    super.authorPhoto,
    super.likes,
  });

  factory PostsModel.fromJson(Map<String, dynamic> json) {
    final artistObj = json['artist'];
    String name = 'Anónimo';
    String? photo;

    if (artistObj is Map<String, dynamic>) {
      name = artistObj['name'] ?? 'Anónimo';
      photo = artistObj['profilePic'];
    }

    return PostsModel(
      id: json['_id']?.toString() ?? '',
      title: json['title'] ?? 'Sin título',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? 'https://via.placeholder.com/300',
      authorName: name,
      authorPhoto: photo,
      likes: (json['likes'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'artist': authorName,
      'likes': likes,
    };
  }
}