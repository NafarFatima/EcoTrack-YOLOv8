import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecotrack/core/domain/entity/waste_item.dart';
import 'package:ecotrack/core/domain/entity/logged_waste.dart';

class WasteItemModel extends WasteItem {
  WasteItemModel({
    required super.id,
    required super.title,
    required super.description,
    required super.iconPath,
    required super.colorValue,
    required super.pointsPerKg,
  });

  factory WasteItemModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return WasteItemModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      iconPath: data['iconPath'] ?? '',
      colorValue: data['colorValue'] ?? 0xFFFFFFFF,
      pointsPerKg: data['pointsPerKg'] ?? 0,
    );
  }
}

class LoggedWasteModel extends LoggedWaste {
  LoggedWasteModel({
    required super.id,
    required super.category,
    required super.quantity,
    required super.location,
    required super.timestamp,
    required super.pointsEarned,
    super.itemName,
    super.notes,
    super.imageUrl,
  });

  factory LoggedWasteModel.fromFirestore(DocumentSnapshot doc, List<WasteItem> categories) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    final categoryId = data['categoryId'];
    
    // Safety check: Find category or use a fallback if not found/list empty
    WasteItem category;
    try {
      category = categories.firstWhere(
        (c) => c.id == categoryId,
        orElse: () => categories.first,
      );
    } catch (e) {
      category = WasteItem(
        id: categoryId ?? 'unknown',
        title: 'Unknown',
        description: '',
        iconPath: '',
        colorValue: 0xFF808080,
        pointsPerKg: 0,
      );
    }
    
    final dynamic rawTimestamp = data['timestamp'];
    DateTime date;
    if (rawTimestamp is Timestamp) {
      date = rawTimestamp.toDate();
    } else if (rawTimestamp is int) {
      date = DateTime.fromMillisecondsSinceEpoch(rawTimestamp);
    } else {
      date = DateTime.now();
    }

    return LoggedWasteModel(
      id: doc.id,
      category: category,
      quantity: (data['quantity'] ?? 0.0).toDouble(),
      location: data['location'] ?? '',
      timestamp: date,
      pointsEarned: (data['pointsEarned'] ?? 0).toInt(),
      itemName: data['itemName'],
      notes: data['notes'],
      imageUrl: data['imageUrl'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'categoryId': category.id,
      'quantity': quantity,
      'location': location,
      'timestamp': Timestamp.fromDate(timestamp),
      'pointsEarned': pointsEarned,
      'itemName': itemName,
      'notes': notes,
      'imageUrl': imageUrl,
    };
  }
}
