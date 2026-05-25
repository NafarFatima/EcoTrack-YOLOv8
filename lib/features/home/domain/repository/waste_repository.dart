import 'package:ecotrack/core/domain/entity/waste_item.dart';
import 'package:ecotrack/core/domain/entity/logged_waste.dart';

abstract class WasteRepository {
  Future<List<WasteItem>> getCategories();
  Stream<List<LoggedWaste>> getWasteLogs(String userId);
  Future<void> logWaste(String userId, LoggedWaste log);
}
