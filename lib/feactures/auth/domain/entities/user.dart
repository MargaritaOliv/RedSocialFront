class User {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  final String? bio;
  final List<String> followers;
  final List<String> following;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.bio,
    this.followers = const [],
    this.following = const [],
  });
}