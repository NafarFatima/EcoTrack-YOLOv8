import '../entity/waste_category.dart';
import 'package:ecotrack/core/domain/entity/logged_waste.dart';

abstract class AddRepository {
  Future<List<WasteCategory>> getCategories();
  Future<void> logWaste(String userId, LoggedWaste log);
}
