import '../repository/splash_repository.dart';
import '../entity/app_config.dart';

class CheckFirstTimeUseCase {
  final SplashRepository repository;

  CheckFirstTimeUseCase(this.repository);

  Future<AppConfig> execute() {
    return repository.getAppConfiguration();
  }
}
