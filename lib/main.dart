import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:redsocial/core/application/app_state.dart';
import 'package:redsocial/myapp.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

// --- AUTH IMPORTS ---
import 'feactures/auth/data/datasource/auth_remote_datasource.dart';
import 'feactures/auth/data/repository/auth_repository_impl.dart';
import 'feactures/auth/domain/usecase/login_usecase.dart';
import 'feactures/auth/domain/usecase/register_usecase.dart';
import 'feactures/auth/presentation/providers/auth_notifier.dart';

// --- HOME / POSTS IMPORTS ---
import 'feactures/home/data/datasource/posts_remote_datasource.dart';
import 'feactures/home/data/repository/posts_repository_impl.dart';
import 'feactures/home/domain/usecase/get_posts_usecase.dart';
import 'feactures/home/presentation/providers/posts_notifier.dart';

// --- CREATE POST IMPORTS ---
import 'feactures/create_post/data/datasource/create_post_remote_datasource.dart';
import 'feactures/create_post/data/repository/create_post_repository_impl.dart';
import 'feactures/create_post/domain/usecase/create_new_post_usecase.dart';
import 'feactures/create_post/presentation/providers/create_post_notifier.dart';

// --- POST DETAIL IMPORTS ---
import 'feactures/post_detail/data/datasource/post_detail_remote_datasource.dart';
import 'feactures/post_detail/data/repository/post_detail_repository_impl.dart';
import 'feactures/post_detail/domain/usecase/add_comment_usecase.dart';
import 'feactures/post_detail/domain/usecase/get_post_full_data_usecase.dart';
import 'feactures/post_detail/domain/usecase/toggle_like_usecase.dart';
import 'feactures/post_detail/presentation/providers/post_detail_notifier.dart';

// --- PROFILE IMPORTS ---
import 'feactures/profile/data/datasource/profile_remote_datasource.dart';
import 'feactures/profile/data/repository/profile_repository_impl.dart';
import 'feactures/profile/domain/usecase/get_profile_data_usecase.dart';
import 'feactures/profile/presentation/providers/profile_notifier.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    if (kDebugMode) {
      print('⚠️ .env no encontrado. Usando valores por defecto.');
    }
  }

  final appState = AppState();
  final httpClient = http.Client(); // Cliente HTTP compartido para toda la app

  // ---------------------------------------------------------
  // 1. INYECCIÓN DE AUTH
  // ---------------------------------------------------------
  final authDataSource = AuthRemoteDataSourceImpl(client: httpClient);
  final authRepository = AuthRepositoryImpl(authRemoteDataSource: authDataSource);
  final loginUseCase = LoginUseCase(authRepository);
  final registerUseCase = RegisterUseCase(authRepository);

  // ---------------------------------------------------------
  // 2. INYECCIÓN DE HOME (POSTS)
  // ---------------------------------------------------------
  final postsDataSource = PostsRemoteDataSourceImpl(client: httpClient);
  final postsRepository = PostsRepositoryImpl(remoteDataSource: postsDataSource);
  final getPostsUseCase = GetPostsUseCase(postsRepository);

  // ---------------------------------------------------------
  // 3. INYECCIÓN DE CREATE POST (Aquí estaba tu error)
  // ---------------------------------------------------------
  final createPostDataSource = CreatePostRemoteDataSourceImpl(client: httpClient);
  final createPostRepository = CreatePostRepositoryImpl(remoteDataSource: createPostDataSource);
  final createNewPostUseCase = CreateNewPostUseCase(createPostRepository);

  // ---------------------------------------------------------
  // 4. INYECCIÓN DE POST DETAIL
  // ---------------------------------------------------------
  final postDetailDataSource = PostDetailRemoteDataSourceImpl(client: httpClient);
  final postDetailRepository = PostDetailRepositoryImpl(remoteDataSource: postDetailDataSource);
  final getPostFullDataUseCase = GetPostFullDataUseCase(postDetailRepository);
  final addCommentUseCase = AddCommentUseCase(postDetailRepository);
  final toggleLikeUseCase = ToggleLikeUseCase(postDetailRepository);

  // ---------------------------------------------------------
  // 5. INYECCIÓN DE PROFILE
  // ---------------------------------------------------------
  final profileDataSource = ProfileRemoteDataSourceImpl(client: httpClient);
  final profileRepository = ProfileRepositoryImpl(remoteDataSource: profileDataSource);
  final getProfileDataUseCase = GetProfileDataUseCase(profileRepository);


  runApp(
    DevicePreview(
      enabled: kDebugMode,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => appState),

          // Auth Provider
          ChangeNotifierProvider(
            create: (_) => AuthNotifier(
              appState: appState,
              loginUseCase: loginUseCase,
              registerUseCase: registerUseCase,
            ),
          ),

          // Home/Posts Provider (Ahora recibe el UseCase)
          ChangeNotifierProvider(
            create: (_) => PostsNotifier(
              getPostsUseCase: getPostsUseCase,
            ),
          ),

          // Create Post Provider (CORREGIDO: Ahora recibe el UseCase)
          ChangeNotifierProvider(
            create: (_) => CreatePostNotifier(
              createNewPostUseCase: createNewPostUseCase,
            ),
          ),

          // Post Detail Provider (Ahora recibe sus 3 UseCases)
          ChangeNotifierProvider(
            create: (_) => PostDetailNotifier(
              getDataUseCase: getPostFullDataUseCase,
              addCommentUseCase: addCommentUseCase,
              toggleLikeUseCase: toggleLikeUseCase,
            ),
          ),

          // Profile Provider (Ahora recibe el UseCase)
          ChangeNotifierProvider(
            create: (_) => ProfileNotifier(
              getProfileDataUseCase: getProfileDataUseCase,
            ),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}