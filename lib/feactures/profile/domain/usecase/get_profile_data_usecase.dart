// feactures/profile/domain/usecase/get_profile_data_usecase.dart (CORREGIDO)

import '../entities/profile_data.dart';
import '../repository/profile_repository.dart';
// 💡 SOLUCIÓN: Importar las entidades User y Posts
import 'package:redsocial/feactures/auth/domain/entities/user.dart';
import 'package:redsocial/feactures/home/domain/entities/posts.dart';


class GetProfileDataUseCase {
  final ProfileRepository repository;

  GetProfileDataUseCase(this.repository);

  Future<ProfileData> call() async {

    final profileFuture = repository.getMyProfile();
    final postsFuture = repository.getMyPosts();
    final results = await Future.wait([profileFuture, postsFuture]);
    final user = results[0] as User;
    final posts = results[1] as List<Posts>;

    return ProfileData(user: user, posts: posts);
  }
}