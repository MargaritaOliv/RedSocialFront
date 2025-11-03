// feactures/profile/data/models/user_profile_model.dart

// Reutilizamos la entidad User y el modelo Post
import 'package:redsocial/feactures/auth/domain/entities/user.dart';

// Definimos un modelo de perfil, que puede ser la misma entidad User
// o una extensión que incluya más datos si fuera necesario.
// Usaremos la misma estructura que User/UserModel.

class UserProfileModel extends User {
  UserProfileModel({
    required super.id,
    required super.name,
    required super.email,
    super.avatar,
    super.bio,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'],
      bio: json['bio'],
    );
  }
}