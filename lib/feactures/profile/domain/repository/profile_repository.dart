import 'package:redsocial/feactures/auth/domain/entities/user.dart';
import 'package:redsocial/feactures/home/domain/entities/posts.dart';

abstract class ProfileRepository {
  Future<User> getMyProfile();
  Future<List<Posts>> getMyPosts();
  Future<User> updateProfile(String name, String bio, String profilePic);
}