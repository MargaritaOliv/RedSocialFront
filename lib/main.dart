import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redsocial/core/application/app_state.dart';
import 'package:redsocial/myapp.dart';

import 'feactures/auth/data/datasource/auth_remote_datasource.dart';
import 'feactures/auth/data/repository/auth_repository_impl.dart';
import 'feactures/auth/domain/usecase/login_usecase.dart';
import 'feactures/auth/domain/usecase/register_usecase.dart';
import 'feactures/auth/presentation/providers/auth_notifier.dart';

import 'feactures/home/data/datasource/posts_remote_datasource.dart';
import 'feactures/home/data/repository/posts_repository_impl.dart';
import 'feactures/home/domain/usecase/get_posts_usecase.dart';
import 'feactures/home/presentation/providers/posts_notifier.dart';

import 'feactures/create_post/data/datasource/create_post_remote_datasource.dart';
import 'feactures/create_post/data/repository/create_post_repository_impl.dart';
import 'feactures/create_post/domain/usecase/create_new_post_usecase.dart';
import 'feactures/create_post/presentation/providers/create_post_notifier.dart';

import 'feactures/post_detail/data/datasource/post_detail_remote_datasource.dart';
import 'feactures/post_detail/data/repository/post_detail_repository_impl.dart';
import 'feactures/post_detail/domain/usecase/add_comment_usecase.dart';
import 'feactures/post_detail/domain/usecase/get_post_full_data_usecase.dart';
import 'feactures/post_detail/domain/usecase/toggle_like_usecase.dart';
import 'feactures/post_detail/presentation/providers/post_detail_notifier.dart';

import 'feactures/profile/data/datasource/profile_remote_datasource.dart';
import 'feactures/profile/data/repository/profile_repository_impl.dart';
import 'feactures/profile/domain/usecase/get_profile_data_usecase.dart';
import 'feactures/profile/domain/usecase/update_profile_usecase.dart';
import 'feactures/profile/presentation/providers/profile_notifier.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appState = AppState();

  final authDataSource = AuthRemoteDataSourceImpl();
  final authRepository = AuthRepositoryImpl(authRemoteDataSource: authDataSource);
  final loginUseCase = LoginUseCase(authRepository);
  final registerUseCase = RegisterUseCase(authRepository);

  final postsDataSource = PostsRemoteDataSourceImpl();
  final postsRepository = PostsRepositoryImpl(remoteDataSource: postsDataSource);
  final getPostsUseCase = GetPostsUseCase(postsRepository);

  final createPostDataSource = CreatePostRemoteDataSourceImpl();
  final createPostRepository = CreatePostRepositoryImpl(remoteDataSource: createPostDataSource);
  final createNewPostUseCase = CreateNewPostUseCase(createPostRepository);

  final postDetailDataSource = PostDetailRemoteDataSourceImpl();
  final postDetailRepository = PostDetailRepositoryImpl(remoteDataSource: postDetailDataSource);
  final getPostFullDataUseCase = GetPostFullDataUseCase(postDetailRepository);
  final addCommentUseCase = AddCommentUseCase(postDetailRepository);
  final toggleLikeUseCase = ToggleLikeUseCase(postDetailRepository);

  final profileDataSource = ProfileRemoteDataSourceImpl();
  final profileRepository = ProfileRepositoryImpl(remoteDataSource: profileDataSource);
  final getProfileDataUseCase = GetProfileDataUseCase(profileRepository);
  final updateProfileUseCase = UpdateProfileUseCase(profileRepository);

  runApp(
    /*
    DevicePreview(
      enabled: kDebugMode,
      builder: (context) => MultiProvider(
    */
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => appState),
        ChangeNotifierProvider(
          create: (_) => AuthNotifier(
            appState: appState,
            loginUseCase: loginUseCase,
            registerUseCase: registerUseCase,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => PostsNotifier(
            getPostsUseCase: getPostsUseCase,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => CreatePostNotifier(
            createNewPostUseCase: createNewPostUseCase,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => PostDetailNotifier(
            getDataUseCase: getPostFullDataUseCase,
            addCommentUseCase: addCommentUseCase,
            toggleLikeUseCase: toggleLikeUseCase,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileNotifier(
            getProfileDataUseCase: getProfileDataUseCase,
            updateProfileUseCase: updateProfileUseCase,
          ),
        ),
      ],
      child: const MyApp(),
    ),
    /*
      ),
    ),
    */
  );
}