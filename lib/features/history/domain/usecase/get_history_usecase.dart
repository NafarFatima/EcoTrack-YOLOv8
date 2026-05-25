import 'package:ecotrack/core/domain/entity/logged_waste.dart';
import '../repository/history_repository.dart';

class GetHistoryUseCase {
  final HistoryRepository repository;

  GetHistoryUseCase(this.repository);

  Stream<List<LoggedWaste>> call(String userId) {
    return repository.watchWasteHistory(userId);
  }
}
