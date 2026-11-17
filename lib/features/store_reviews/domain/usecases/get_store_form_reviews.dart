import '../entities/store_review.dart';
import '../repositories/store_reviews_repository.dart';

class GetStoreFormReviews {
  const GetStoreFormReviews(this._repository);

  final StoreReviewsRepository _repository;

  Future<List<StoreReview>> call() => _repository.fetchFormReviews();
}
