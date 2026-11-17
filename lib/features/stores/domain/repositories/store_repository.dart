import '../entities/store.dart';

abstract interface class StoreRepository {
  Future<List<Store>> fetchStores();

  List<Store> fetchLocalStores();

  Future<Store> fetchStore(String slug, {String? expectedName});
}
