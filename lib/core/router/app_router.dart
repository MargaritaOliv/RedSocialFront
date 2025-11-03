// lib/core/router/app_router.dart (ACTUALIZADO: SIN Splash ni Register)

import 'package:go_router/go_router.dart';
import 'package:redsocial/core/application/app_state.dart';
import 'package:redsocial/core/router/routes.dart';

// --- RUTAS MANTENIDAS ---
import 'package:redsocial/feactures/auth/presentation/pages/login_screen.dart';
import 'package:redsocial/feactures/home/presentation/pages/home_screen.dart';
import 'package:redsocial/feactures/profile/presentation/pages/profile_screen.dart';
import 'package:redsocial/feactures/create_post/presentation/pages/create_post_screen.dart';
import 'package:redsocial/feactures/post_detail/presentation/pages/post_detail_screen.dart';

// --- RUTAS ELIMINADAS: Splash/RegisterScreen ya no se importan ---


class AppRouter {
  final AppState appState;

  AppRouter({required this.appState});

  late final GoRouter router = GoRouter(
    initialLocation: AppRoutes.loginPath, // 💡 CAMBIO: Inicia en Login
    refreshListenable: appState,
    routes: [
      // 1. Splash (ELIMINADO)
      /*
      GoRoute(
        path: AppRoutes.splashPath,
        name: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      */

      // 2. Autenticación
      GoRoute(
        path: AppRoutes.loginPath,
        name: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      // Register (ELIMINADO)
      /*
      GoRoute(
        path: AppRoutes.registerPath,
        name: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      */

      // 3. HOME y RUTAS PROTEGIDAS ANIDADAS/DETALLE
      GoRoute(
        path: AppRoutes.homePath,
        name: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
        routes: [
          // Ruta anidada para el perfil del usuario (e.g., /home/profile/123)
          GoRoute(
            path: AppRoutes.profilePath,
            name: AppRoutes.profile,
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return ProfileScreen(userId: id);
            },
          ),
          // Ruta anidada para detalle de un post (e.g., /home/posts/abc)
          GoRoute(
            path: 'posts/:id', // Relativa a /home
            name: AppRoutes.postDetail,
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return PostDetailScreen(postId: id);
            },
          ),
        ],
      ),

      // 4. Otras Rutas Protegidas (Crear Post)
      GoRoute(
        path: AppRoutes.createPostPath,
        name: AppRoutes.createPost,
        builder: (context, state) => const CreatePostScreen(),
      ),

      // 5. Catch-all
      GoRoute(
        path: '/:catchAll(.*)',
        builder: (context, state) => const LoginScreen(), // Redirige a Login si la ruta no existe
      ),
    ],

    // LÓGICA DE REDIRECCIÓN
    redirect: (context, state) {
      final authStatus = appState.authStatus;
      final loc = state.matchedLocation;

      // Rutas públicas restantes
      const publicPaths = [AppRoutes.loginPath];

      switch (authStatus) {
        case AuthStatus.unknown:
        // 💡 CAMBIO: Redirige directamente a Login si el estado es desconocido
          return AppRoutes.loginPath;

        case AuthStatus.unauthenticated:
        // Si no está autenticado, solo permite Login.
          return publicPaths.contains(loc) ? null : AppRoutes.loginPath;

        case AuthStatus.authenticated:
        // Si está autenticado, no permite ir a Login.
          if (loc == AppRoutes.loginPath || loc == AppRoutes.splashPath) {
            return AppRoutes.homePath;
          }
          // Si no es ninguna de las anteriores, permite la navegación normal
          return null;
      }
    },
  );
}