import 'package:shared_preferences/shared_preferences.dart';
import '../model/app_config_model.dart';

class SplashService {
  static const String _kFirstTimeKey = 'is_first_time';

  Future<AppConfigModel> getAppConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool(_kFirstTimeKey) ?? true;
    return AppConfigModel(
      isFirstTime: isFirstTime,
      version: '1.0.0', // This could come from package_info_plus later
    );
  }

  Future<void> setFirstTimeCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kFirstTimeKey, false);
  }
}
