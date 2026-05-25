import '../entity/waste_category.dart';
import '../repository/add_repository.dart';

class GetAddCategoriesUseCase {
  final AddRepository repository;

  GetAddCategoriesUseCase(this.repository);

  Future<List<WasteCategory>> execute() {
    return repository.getCategories();
  }
}
