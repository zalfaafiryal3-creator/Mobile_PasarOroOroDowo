import '../entities/store_review.dart';
import '../repositories/store_reviews_repository.dart';

class GetStoreReviews {
  const GetStoreReviews(this._repository);

  final StoreReviewsRepository _repository;

  Future<StoreReviewPage> call(
    String storeId, {
    String filter = 'all',
    String search = '',
    int page = 1,
    int limit = 20,
  }) => _repository.fetchReviews(
    storeId,
    filter: filter,
    search: search,
    page: page,
    limit: limit,
  );
}
