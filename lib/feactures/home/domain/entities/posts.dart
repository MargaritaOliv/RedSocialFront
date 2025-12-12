class Posts {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String authorName;
  final String? authorPhoto;
  final List<String> likes;

  Posts({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.authorName,
    this.authorPhoto,
    this.likes = const [],
  });
}