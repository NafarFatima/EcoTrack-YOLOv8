import '../../domain/entity/app_config.dart';

class AppConfigModel extends AppConfig {
  AppConfigModel({
    required super.isFirstTime,
    required super.version,
  });

  factory AppConfigModel.fromJson(Map<String, dynamic> json) {
    return AppConfigModel(
      isFirstTime: json['isFirstTime'] ?? true,
      version: json['version'] ?? '1.0.0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isFirstTime': isFirstTime,
      'version': version,
    };
  }
}
