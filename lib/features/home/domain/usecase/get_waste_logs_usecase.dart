import 'package:ecotrack/core/domain/entity/logged_waste.dart';
import '../repository/waste_repository.dart';

class GetWasteLogsUseCase {
  final WasteRepository repository;

  GetWasteLogsUseCase(this.repository);

  Stream<List<LoggedWaste>> execute(String userId) {
    return repository.getWasteLogs(userId);
  }
}
