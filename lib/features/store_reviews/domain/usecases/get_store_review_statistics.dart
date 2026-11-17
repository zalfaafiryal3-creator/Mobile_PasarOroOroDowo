import '../entities/store_review.dart';
import '../repositories/store_reviews_repository.dart';

class GetStoreReviewStatistics {
  const GetStoreReviewStatistics(this._repository);

  final StoreReviewsRepository _repository;

  Future<StoreReviewStatistics> call(String storeId) =>
      _repository.fetchStatistics(storeId);
}
