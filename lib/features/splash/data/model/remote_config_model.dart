import '../../domain/entity/remote_config.dart';

class RemoteConfigModel extends RemoteConfig {
  RemoteConfigModel({
    required super.isUnderMaintenance,
    required super.minVersion,
    required super.latestVersion,
    required super.maintenanceMessage,
  });

  factory RemoteConfigModel.fromJson(Map<String, dynamic> json) {
    return RemoteConfigModel(
      isUnderMaintenance: json['isUnderMaintenance'] ?? false,
      minVersion: json['minVersion'] ?? '1.0.0',
      latestVersion: json['latestVersion'] ?? '1.0.0',
      maintenanceMessage: json['maintenanceMessage'] ?? 'We are currently under maintenance. Please try again later.',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isUnderMaintenance': isUnderMaintenance,
      'minVersion': minVersion,
      'latestVersion': latestVersion,
      'maintenanceMessage': maintenanceMessage,
    };
  }
}
