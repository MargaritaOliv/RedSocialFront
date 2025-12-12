import 'package:redsocial/feactures/auth/domain/entities/user.dart';

class UserProfileModel extends User {
  UserProfileModel({
    required super.id,
    required super.name,
    required super.email,
    super.avatar,
    super.bio,
    super.followers,
    super.following,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['_id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatar: json['profilePic'],

      bio: json['bio'],
      followers: (json['followers'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      following: (json['following'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}