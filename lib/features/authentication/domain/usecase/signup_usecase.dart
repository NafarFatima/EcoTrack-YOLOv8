import '../entity/login_entity.dart';
import '../repository/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<LoginEntity?> execute(String email, String password, String name) {
    return repository.signUp(email, password, name);
  }
}
