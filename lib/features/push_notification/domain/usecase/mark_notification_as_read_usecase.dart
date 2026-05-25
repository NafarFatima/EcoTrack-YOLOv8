import 'package:ecotrack/features/push_notification/domain/repository/push_notification_repository.dart';

class MarkNotificationAsReadUseCase {
  final PushNotificationRepository repository;

  MarkNotificationAsReadUseCase(this.repository);

  Future<void> execute(String userId, String notificationId) async {
    await repository.markAsRead(userId, notificationId);
  }
}
