import 'package:redsocial/feactures/auth/domain/entities/user.dart';
import 'package:redsocial/feactures/home/domain/entities/posts.dart';

class ProfileData {
  final User user;
  final List<Posts> posts;

  ProfileData({required this.user, required this.posts});
}