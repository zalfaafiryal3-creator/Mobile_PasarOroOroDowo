import '../entities/store.dart';
import '../repositories/store_repository.dart';

class GetStores {
  const GetStores(this._repository);

  final StoreRepository _repository;

  Future<List<Store>> call() => _repository.fetchStores();

  String? get lastFetchError => _repository.lastFetchError;
}
