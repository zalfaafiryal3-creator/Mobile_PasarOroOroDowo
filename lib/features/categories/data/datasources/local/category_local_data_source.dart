import '../../domain/entities/category.dart';
import 'category_catalog.dart';

class CategoryLocalDataSource {
  const CategoryLocalDataSource();

  List<StoreCategory> getCategories() {
    return storeCategories.asMap().entries.map((entry) {
      return StoreCategory(
        id: entry.key + 1,
        name: entry.value,
        storeCount: 0,
      );
    }).toList();
  }
}
