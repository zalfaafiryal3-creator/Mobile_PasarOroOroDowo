import '../entities/store.dart';

abstract interface class StoreRepository {
  String? get lastFetchError;

  Future<List<Store>> fetchStores();

  List<Store> fetchLocalStores();

  Future<Store> fetchStore(String slug, {String? expectedName});
}
