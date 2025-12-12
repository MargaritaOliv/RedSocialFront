import 'package:redsocial/feactures/auth/domain/entities/user.dart';
import '../repository/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<User> call(String name, String bio, String profilePic) async {
    return await repository.updateProfile(name, bio, profilePic);
  }
}