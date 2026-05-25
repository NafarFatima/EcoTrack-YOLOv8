import 'package:ecotrack/core/domain/entity/logged_waste.dart';
import 'package:ecotrack/core/domain/entity/waste_item.dart';
import '../../domain/repository/waste_repository.dart';
import '../model/waste_model.dart';
import '../services/waste_services.dart';

class WasteRepositoryImp implements WasteRepository {
  final WasteServices wasteServices;

  WasteRepositoryImp(this.wasteServices);

  @override
  Future<List<WasteItem>> getCategories() async {
    final docs = await wasteServices.getCategories();
    return docs.map((doc) => WasteItemModel.fromFirestore(doc)).toList();
  }

  @override
  Stream<List<LoggedWaste>> getWasteLogs(String userId) {
    return wasteServices.getWasteLogs(userId).asyncMap((snapshot) async {
      final categoryDocs = await wasteServices.getCategories();
      final categories = categoryDocs.map((doc) => WasteItemModel.fromFirestore(doc)).toList();
      
      final logs = snapshot.docs.map((doc) {
        return LoggedWasteModel.fromFirestore(doc, categories);
      }).toList();

      // Manual sorting to ensure newest logs appear first (no index needed)
      logs.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return logs;
    });
  }

  @override
  Future<void> logWaste(String userId, LoggedWaste log) async {
    final model = LoggedWasteModel(
      id: log.id,
      category: log.category,
      quantity: log.quantity,
      location: log.location,
      timestamp: log.timestamp,
      pointsEarned: log.pointsEarned,
      itemName: log.itemName,
      notes: log.notes,
      imageUrl: log.imageUrl,
    );
    await wasteServices.logWaste(userId, model.toFirestore());
  }
}
