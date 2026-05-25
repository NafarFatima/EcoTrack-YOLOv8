import 'package:ecotrack/features/push_notification/domain/entity/push_notification.dart';

class PushNotificationModel extends PushNotification {
  PushNotificationModel({
    required super.id,
    required super.title,
    required super.message,
    required super.time,
    required super.iconPath,
    required super.isNew,
  });

  factory PushNotificationModel.fromJson(Map<String, dynamic> json) {
    return PushNotificationModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      time: json['time'] ?? '',
      iconPath: json['iconPath'] ?? '',
      isNew: json['isNew'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'time': time,
      'iconPath': iconPath,
      'isNew': isNew,
    };
  }
}
