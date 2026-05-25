import 'package:ecotrack/core/domain/entity/logged_waste.dart';
import '../repository/waste_repository.dart';

class LogWasteUseCase {
  final WasteRepository repository;

  LogWasteUseCase(this.repository);

  Future<void> execute(String userId, LoggedWaste log) {
    return repository.logWaste(userId, log);
  }
}
