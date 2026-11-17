import '../entities/store.dart';
import '../repositories/store_repository.dart';

class GetLocalStores {
  const GetLocalStores(this._repository);

  final StoreRepository _repository;

  List<Store> call() => _repository.fetchLocalStores();
}
