import 'package:ecotrack/features/home/data/model/waste_model.dart';
import 'package:ecotrack/core/domain/entity/logged_waste.dart';
import '../../domain/entity/waste_category.dart';
import '../../domain/repository/add_repository.dart';
import '../model/waste_category_model.dart';
import '../services/add_services.dart';

class AddRepositoryImp implements AddRepository {
  final AddServices services;

  AddRepositoryImp(this.services);

  @override
  Future<List<WasteCategory>> getCategories() async {
    final docs = await services.getCategories();
    return docs.map((doc) => WasteCategoryModel.fromFirestore(doc)).toList();
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
    await services.logWaste(userId, model.toFirestore());
  }
}
