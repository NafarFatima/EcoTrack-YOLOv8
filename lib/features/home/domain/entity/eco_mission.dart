class EcoMission {
  final String id;
  final String title;
  final String description;
  final int points;
  final String iconPath;
  final bool isCompleted;
  final String type; // e.g., 'daily', 'weekly'

  EcoMission({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
    required this.iconPath,
    this.isCompleted = false,
    this.type = 'daily',
  });

  EcoMission copyWith({
    String? id,
    String? title,
    String? description,
    int? points,
    String? iconPath,
    bool? isCompleted,
    String? type,
  }) {
    return EcoMission(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      points: points ?? this.points,
      iconPath: iconPath ?? this.iconPath,
      isCompleted: isCompleted ?? this.isCompleted,
      type: type ?? this.type,
    );
  }
}
