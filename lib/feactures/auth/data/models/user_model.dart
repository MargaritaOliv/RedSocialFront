import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.avatar,
    super.bio,
    super.followers,
    super.following,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatar: json['profilePic'],
      bio: json['bio'],
      followers: (json['followers'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      following: (json['following'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'profilePic': avatar,
      'bio': bio,
      'followers': followers,
      'following': following,
    };
  }
}