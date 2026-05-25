import 'waste_item.dart';

class LoggedWaste {
  final String id;
  final WasteItem category;
  final double quantity;
  final String location;
  final DateTime timestamp;
  final int pointsEarned;
  final String? itemName;
  final String? notes;
  final String? imageUrl;

  LoggedWaste({
    required this.id,
    required this.category,
    required this.quantity,
    required this.location,
    required this.timestamp,
    required this.pointsEarned,
    this.itemName,
    this.notes,
    this.imageUrl,
  });
}
