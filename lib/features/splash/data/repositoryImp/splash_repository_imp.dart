import 'package:ecotrack/features/splash/data/services/splash_service.dart';
import 'package:ecotrack/features/splash/domain/repository/splash_repository.dart';
import 'package:ecotrack/features/splash/domain/entity/app_config.dart';

class SplashRepositoryImp implements SplashRepository {
  final SplashService service;

  SplashRepositoryImp(this.service);

  @override
  Future<AppConfig> getAppConfiguration() {
    return service.getAppConfig();
  }

  @override
  Future<void> setFirstTimeCompleted() {
    return service.setFirstTimeCompleted();
  }
}
