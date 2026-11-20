import '../entities/category.dart';

abstract class CategoryRepository {
  Future<List<StoreCategory>> getCategories();
  List<StoreCategory> getLocalCategories();
}
