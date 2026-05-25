import 'package:ecotrack/features/push_notification/data/model/push_notification_model.dart';
import 'package:ecotrack/features/push_notification/data/services/notification_service.dart';
import 'package:ecotrack/features/push_notification/domain/entity/push_notification.dart';
import 'package:ecotrack/features/push_notification/domain/repository/push_notification_repository.dart';

class PushNotificationRepositoryImp implements PushNotificationRepository {
  final NotificationService service;

  PushNotificationRepositoryImp(this.service);

  @override
  Stream<List<PushNotification>> getNotifications(String userId) {
    return service.getNotifications(userId).map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return PushNotificationModel.fromJson({
          ...data,
          'id': doc.id,
        });
      }).toList();
    });
  }

  @override
  Future<void> markAsRead(String userId, String notificationId) async {
    await service.markAsRead(userId, notificationId);
  }
}
