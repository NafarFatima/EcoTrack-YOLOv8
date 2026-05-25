import 'package:ecotrack/features/push_notification/domain/entity/push_notification.dart';
import 'package:ecotrack/features/push_notification/domain/repository/push_notification_repository.dart';

class GetNotificationsUseCase {
  final PushNotificationRepository repository;

  GetNotificationsUseCase(this.repository);

  Stream<List<PushNotification>> execute(String userId) {
    return repository.getNotifications(userId);
  }
}
