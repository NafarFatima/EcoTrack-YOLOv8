import 'package:ecotrack/features/push_notification/domain/entity/push_notification.dart';

abstract class PushNotificationRepository {
  Stream<List<PushNotification>> getNotifications(String userId);
  Future<void> markAsRead(String userId, String notificationId);
}
