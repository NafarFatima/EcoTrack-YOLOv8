import '../entity/app_config.dart';

abstract class SplashRepository {
  Future<AppConfig> getAppConfiguration();
  Future<void> setFirstTimeCompleted();
}
