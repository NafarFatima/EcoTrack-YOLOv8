class PushNotification {
  final String id;
  final String title;
  final String message;
  final String time;
  final String iconPath;
  final bool isNew;

  PushNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.iconPath,
    required this.isNew,
  });
}
