class Comment {
  final String id;
  final String text;
  final String userId;
  final String userName;
  final String? userAvatar;
  final String postId;

  Comment({
    required this.id,
    required this.text,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.postId,
  });
}