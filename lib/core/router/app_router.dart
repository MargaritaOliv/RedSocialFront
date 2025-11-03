import 'package:go_router/go_router.dart';
import 'package:redsocial/core/application/app_state.dart';
import 'package:redsocial/core/router/routes.dart';
import 'package:redsocial/feactures/auth/presentation/pages/login_screen.dart';


class AppRouter {
  final AppState appState;

  AppRouter({required this.appState});

  late final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splashPath,
    refreshListenable: appState,
    routes: [
      GoRoute(
        path: AppRoutes.splashPath,
        name: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.loginPath,
        name: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.registerPath,
        name: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.homePath,
        name: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: AppRoutes.profilePath,
            name: AppRoutes.profile,
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return ProfileScreen(userId: id);
            },
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final authStatus = appState.authStatus;
      final loc = state.matchedLocation;

      print(authStatus);

      switch (authStatus) {
        case AuthStatus.unknown:
        // Solo redirige si no estamos ya en Splash
          return loc == AppRoutes.splashPath ? null : AppRoutes.splashPath;

        case AuthStatus.unauthenticated:
        // Bloquear rutas protegidas si no está autenticado
          if (loc == AppRoutes.homePath || loc.startsWith('/home')) {
            return AppRoutes.loginPath;
          }
          // Si ya está en login o register, no redirigir
          if (loc == AppRoutes.loginPath || loc == AppRoutes.registerPath) {
            return null;
          }
          return AppRoutes.loginPath;

        case AuthStatus.authenticated:
        // Si está autenticado y trata de ir a login, redirigir a home
          return loc == AppRoutes.loginPath || loc == AppRoutes.splashPath
              ? AppRoutes.homePath
              : null;
      }
    },
  );
}