// lib/core/router/routes.dart (ACTUALIZADO: SIN Splash ni Register)

class AppRoutes {
  // static const String splash = 'splash'; // ELIMINADO
  static const String home = 'home';
  static const String login = 'login';
  // static const String register = 'register'; // ELIMINADO
  static const String profile = 'profile';

  static const String createPost = 'create-post';
  static const String postDetail = 'post-detail';

  static const String splashPath = '/'; // Se mantiene el path por ser la raíz
  static const String homePath = '/home';
  static const String loginPath = '/login';
  // static const String registerPath = '/register'; // ELIMINADO
  static const String profilePath = 'profile/:id';

  static const String createPostPath = '/create-post';
  static const String postDetailPath = '/posts/:id';
}