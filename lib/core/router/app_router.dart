import 'package:go_router/go_router.dart';
import 'package:redsocial/core/application/app_state.dart';
import 'package:redsocial/core/router/routes.dart';
import 'package:redsocial/feactures/auth/presentation/pages/login_screen.dart';
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
      GoRoute(
        path: AppRoutes.loginPath,
        name: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
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
          GoRoute(
            path: 'posts/:id',
            name: AppRoutes.postDetail,
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return PostDetailScreen(postId: id);
            },
          ),
        ],
      ),

      GoRoute(
        path: AppRoutes.createPostPath,
        name: AppRoutes.createPost,
        builder: (context, state) => const CreatePostScreen(),
      ),

      GoRoute(
        path: '/:catchAll(.*)',
        builder: (context, state) => const LoginScreen(),
      ),
    ],

    redirect: (context, state) {
      final authStatus = appState.authStatus;
      final loc = state.matchedLocation;

      const publicPaths = [AppRoutes.loginPath];

      switch (authStatus) {
        case AuthStatus.unknown:
          return AppRoutes.loginPath;
        case AuthStatus.unauthenticated:
          return publicPaths.contains(loc) ? null : AppRoutes.loginPath;

        case AuthStatus.authenticated:
          if (loc == AppRoutes.loginPath || loc == AppRoutes.splashPath) {
            return AppRoutes.homePath;
          }
          return null;
      }
    },
  );
}