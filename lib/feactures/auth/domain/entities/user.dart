class User {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  final String? bio;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.bio,
  });
}