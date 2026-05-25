import '../../domain/entity/eco_mission.dart';

class EcoMissionModel extends EcoMission {
  EcoMissionModel({
    required super.id,
    required super.title,
    required super.description,
    required super.points,
    required super.iconPath,
    super.isCompleted,
    super.type,
  });

  factory EcoMissionModel.fromMap(String id, Map<String, dynamic> map, bool isCompleted) {
    return EcoMissionModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      points: map['points'] ?? 0,
      iconPath: map['iconPath'] ?? '',
      isCompleted: isCompleted,
      type: map['type'] ?? 'daily',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'points': points,
      'iconPath': iconPath,
      'type': type,
    };
  }
}
