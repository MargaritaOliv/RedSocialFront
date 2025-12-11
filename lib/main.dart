import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:redsocial/core/application/app_state.dart';
import 'package:redsocial/myapp.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http; // Importante para el cliente

// Imports de Auth
import 'feactures/auth/data/datasource/auth_remote_datasource.dart';
import 'feactures/auth/data/repository/auth_repository_impl.dart';
import 'feactures/auth/domain/usecase/login_usecase.dart';
import 'feactures/auth/domain/usecase/register_usecase.dart';
import 'feactures/auth/presentation/providers/auth_notifier.dart';

// Otros providers
import 'feactures/home/presentation/providers/posts_notifier.dart';
import 'feactures/create_post/presentation/providers/create_post_notifier.dart';
import 'feactures/post_detail/presentation/providers/post_detail_notifier.dart';
import 'feactures/profile/presentation/providers/profile_notifier.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    if (kDebugMode) {
      print('⚠️  .env no encontrado. Usando valores por defecto.');
    }
  }

  final appState = AppState();
  final httpClient = http.Client(); // Cliente HTTP compartido

  // --- INYECCIÓN DE DEPENDENCIAS DE AUTH ---
  // 1. DataSource
  final authDataSource = AuthRemoteDataSourceImpl(client: httpClient);
  // 2. Repository
  final authRepository = AuthRepositoryImpl(authRemoteDataSource: authDataSource);
  // 3. UseCases
  final loginUseCase = LoginUseCase(authRepository);
  final registerUseCase = RegisterUseCase(authRepository);

  runApp(
    DevicePreview(
      enabled: kDebugMode,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => appState),

          // 4. Provider con dependencias inyectadas
          ChangeNotifierProvider(
            create: (_) => AuthNotifier(
              appState: appState,
              loginUseCase: loginUseCase,
              registerUseCase: registerUseCase,
            ),
          ),

          ChangeNotifierProvider(create: (_) => PostsNotifier()),
          ChangeNotifierProvider(create: (_) => CreatePostNotifier()),
          ChangeNotifierProvider(create: (_) => PostDetailNotifier()),
          ChangeNotifierProvider(create: (_) => ProfileNotifier()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}