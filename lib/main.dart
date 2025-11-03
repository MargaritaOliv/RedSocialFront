import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:redsocial/core/application/app_state.dart';
import 'package:redsocial/myapp.dart';
import 'package:provider/provider.dart';
import 'feactures/auth/presentation/providers/auth_notifier.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final appState = AppState();

  runApp(
    DevicePreview(
      enabled: kDebugMode,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => appState),
          ChangeNotifierProvider(create: (_) => AuthNotifier(appState)),
        ],
        child: const MyApp(),
      ),
    ),
  );
}