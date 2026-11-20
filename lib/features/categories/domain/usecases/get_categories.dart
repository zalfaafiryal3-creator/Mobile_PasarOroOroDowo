import '../entities/category.dart';
import '../repositories/category_repository.dart';

class GetCategories {
  const GetCategories(this._repository);

  final CategoryRepository _repository;

  Future<List<StoreCategory>> call() => _repository.getCategories();
  List<StoreCategory> getLocal() => _repository.getLocalCategories();
}
