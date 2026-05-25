import '../repository/auth_repository.dart';

class SendPasswordResetUseCase {
  final AuthRepository repository;

  SendPasswordResetUseCase(this.repository);

  Future<void> execute(String email) {
    return repository.sendPasswordReset(email);
  }
}
