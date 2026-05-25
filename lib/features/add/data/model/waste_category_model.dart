import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entity/waste_category.dart';

class WasteCategoryModel extends WasteCategory {
  WasteCategoryModel({
    required super.id,
    required super.title,
    required super.description,
    required super.iconPath,
    required super.colorValue,
    required super.pointsPerKg,
  });

  factory WasteCategoryModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return WasteCategoryModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      iconPath: data['iconPath'] ?? '',
      colorValue: data['colorValue'] ?? 0xFFFFFFFF,
      pointsPerKg: data['pointsPerKg'] ?? 0,
    );
  }
}
