import 'package:go_router/go_router.dart';
import 'package:redsocial/core/application/app_state.dart';
import 'package:redsocial/core/router/routes.dart';

// Pantallas de Auth
import 'package:redsocial/feactures/auth/presentation/pages/login_screen.dart';
import 'package:redsocial/feactures/auth/presentation/pages/register_screen.dart'; // Asegúrate de haber creado este archivo

// Pantallas Principales
import 'package:redsocial/feactures/home/presentation/pages/home_screen.dart';
import 'package:redsocial/feactures/profile/presentation/pages/profile_screen.dart';
import 'package:redsocial/feactures/create_post/presentation/pages/create_post_screen.dart';
import 'package:redsocial/feactures/post_detail/presentation/pages/post_detail_screen.dart';

class AppRouter {
  final AppState appState;

  AppRouter({required this.appState});

  late final GoRouter router = GoRouter(
    initialLocation: AppRoutes.loginPath,
    refreshListenable: appState,
    routes: [
      // --- LOGIN ---
      GoRoute(
        path: AppRoutes.loginPath,
        name: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),

      // --- REGISTER (Nueva Ruta) ---
      GoRoute(
        path: AppRoutes.registerPath,
        name: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),

      // --- HOME y Rutas Anidadas ---
      GoRoute(
        path: AppRoutes.homePath,
        name: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: AppRoutes.profilePath, // 'profile/:id'
            name: AppRoutes.profile,
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return ProfileScreen(userId: id);
            },
          ),
          GoRoute(
            path: 'posts/:id', // Sub-ruta relativa
            name: AppRoutes.postDetail,
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return PostDetailScreen(postId: id);
            },
          ),
        ],
      ),

      // --- CREATE POST ---
      GoRoute(
        path: AppRoutes.createPostPath,
        name: AppRoutes.createPost,
        builder: (context, state) => const CreatePostScreen(),
      ),

      // --- CATCH ALL (404) ---
      GoRoute(
        path: '/:catchAll(.*)',
        builder: (context, state) => const LoginScreen(),
      ),
    ],

    // --- LÓGICA DE PROTECCIÓN DE RUTAS ---
    redirect: (context, state) {
      final authStatus = appState.authStatus;
      final loc = state.matchedLocation;

      // Rutas que se pueden ver sin estar logueado
      const publicPaths = [AppRoutes.loginPath, AppRoutes.registerPath];

      switch (authStatus) {
        case AuthStatus.unknown:
        // Mientras carga, mantenemos en login o splash
          return AppRoutes.loginPath;

        case AuthStatus.unauthenticated:
        // Si NO está logueado y trata de ir a una ruta privada, lo mandamos al login.
        // Si está en login o registro, lo dejamos ahí.
          return publicPaths.contains(loc) ? null : AppRoutes.loginPath;

        case AuthStatus.authenticated:
        // Si YA está logueado y trata de ver Login o Registro, lo mandamos al Home.
          if (publicPaths.contains(loc) || loc == AppRoutes.splashPath) {
            return AppRoutes.homePath;
          }
          return null;
      }
    },
  );
}