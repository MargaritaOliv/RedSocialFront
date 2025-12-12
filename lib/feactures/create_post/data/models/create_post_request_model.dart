class CreatePostRequestModel {
  final String title;
  final String imageUrl;
  final String category;
  final String description;

  CreatePostRequestModel({
    required this.title,
    required this.imageUrl,
    required this.category,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'category': category,
      'description': description,
    };
  }
}