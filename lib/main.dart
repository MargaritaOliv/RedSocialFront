import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:redsocial/core/application/app_state.dart';
import 'package:redsocial/myapp.dart';
import 'package:provider/provider.dart';
import 'feactures/auth/presentation/providers/auth_notifier.dart';
import 'feactures/home/presentation/providers/posts_notifier.dart';
import 'feactures/create_post/presentation/providers/create_post_notifier.dart';
import 'feactures/post_detail/presentation/providers/post_detail_notifier.dart';
import 'feactures/profile/presentation/providers/profile_notifier.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✨ Hacer el .env opcional
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    if (kDebugMode) {
      print('⚠️  .env no encontrado. Usando valores por defecto.');
    }
  }

  final appState = AppState();

  runApp(
    DevicePreview(
      enabled: kDebugMode,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => appState),
          ChangeNotifierProvider(create: (_) => AuthNotifier(appState)),
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