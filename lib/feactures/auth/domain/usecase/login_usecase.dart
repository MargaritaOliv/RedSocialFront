import '../entities/user.dart';
import 'package:redsocial/feactures/auth/domain/repository/auth_repository.dart';

class LoginUseCase {
  final AuthRepository authRepository;

  LoginUseCase(this.authRepository);

  Future<User> call(String email, String password) async {
    return await authRepository.login(email, password);
  }
}