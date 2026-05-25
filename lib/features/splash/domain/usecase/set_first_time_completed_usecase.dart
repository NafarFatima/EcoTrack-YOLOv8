import 'package:ecotrack/features/splash/domain/repository/splash_repository.dart';

class SetFirstTimeCompletedUseCase {
  final SplashRepository repository;

  SetFirstTimeCompletedUseCase(this.repository);

  Future<void> execute() {
    return repository.setFirstTimeCompleted();
  }
}
