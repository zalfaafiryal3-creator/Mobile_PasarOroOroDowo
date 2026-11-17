import '../entities/store.dart';
import '../repositories/store_repository.dart';

class GetStore {
  const GetStore(this._repository);

  final StoreRepository _repository;

  Future<Store> call(String slug, {String? expectedName}) =>
      _repository.fetchStore(slug, expectedName: expectedName);
}
