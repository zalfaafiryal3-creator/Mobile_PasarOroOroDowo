import '../../domain/entities/store.dart';
import 'local/store_catalog.dart';

class StoreLocalDataSource {
  const StoreLocalDataSource();

  List<Store> fetchStores() => marketStores;
}
