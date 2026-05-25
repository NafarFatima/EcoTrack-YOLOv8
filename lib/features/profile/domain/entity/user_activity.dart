enum ActivityType { milestone, achievement, social }

class UserActivity {
  final String id;
  final String title;
  final String description;
  final DateTime timestamp;
  final ActivityType type;
  final String? icon;

  UserActivity({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.type,
    this.icon,
  });
}
