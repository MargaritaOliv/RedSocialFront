import '../entities/user.dart';
import '../repository/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository authRepository;

  RegisterUseCase(this.authRepository);

  Future<User> call(String name, String email, String password) async {
    return await authRepository.register(name, email, password);
  }
}