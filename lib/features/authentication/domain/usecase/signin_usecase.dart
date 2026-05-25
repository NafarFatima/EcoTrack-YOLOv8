import '../entity/login_entity.dart';
import '../repository/auth_repository.dart';

class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  Future<LoginEntity?> execute(String email, String password) {
    return repository.signIn(email, password);
  }
}
