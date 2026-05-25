import 'package:ecotrack/core/domain/entity/logged_waste.dart';

abstract class HistoryRepository {
  Stream<List<LoggedWaste>> watchWasteHistory(String userId);
}
