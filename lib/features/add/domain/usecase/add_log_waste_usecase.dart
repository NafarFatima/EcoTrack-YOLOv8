import 'package:ecotrack/core/domain/entity/logged_waste.dart';
import '../repository/add_repository.dart';

class AddLogWasteUseCase {
  final AddRepository repository;

  AddLogWasteUseCase(this.repository);

  Future<void> execute(String userId, LoggedWaste log) {
    return repository.logWaste(userId, log);
  }
}
