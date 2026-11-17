import '../entities/store_review.dart';
import '../repositories/store_reviews_repository.dart';

class SubmitStoreReview {
  const SubmitStoreReview(this._repository);

  final StoreReviewsRepository _repository;

  Future<List<StoreReview>> call({
    required String name,
    required String text,
    required int rating,
    String? storeId,
  }) => _repository.submitReview(
    name: name,
    text: text,
    rating: rating,
    storeId: storeId,
  );
}
