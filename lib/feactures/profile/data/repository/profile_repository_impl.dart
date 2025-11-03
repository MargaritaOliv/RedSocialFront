// feactures/profile/data/repository/profile_repository_impl.dart

import 'package:redsocial/feactures/auth/domain/entities/user.dart';
import 'package:redsocial/feactures/home/domain/entities/posts.dart';
import '../../domain/repository/profile_repository.dart';
import '../datasource/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<User> getMyProfile() async {
    return await remoteDataSource.fetchMyProfile();
  }

  @override
  Future<List<Posts>> getMyPosts() async {
    return await remoteDataSource.fetchMyPosts();
  }
}