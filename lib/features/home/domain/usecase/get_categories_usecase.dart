import 'package:ecotrack/core/domain/entity/waste_item.dart';
import '../repository/waste_repository.dart';

class GetCategoriesUseCase {
  final WasteRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<List<WasteItem>> execute() {
    return repository.getCategories();
  }
}
