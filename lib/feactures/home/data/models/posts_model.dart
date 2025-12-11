class Posts {
  final String id;
  final String title;
  final String description; // Este es el campo correcto, NO 'body'
  final String imageUrl;
  final String authorName;
  final String? authorPhoto;

  Posts({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.authorName,
    this.authorPhoto,
  });
}