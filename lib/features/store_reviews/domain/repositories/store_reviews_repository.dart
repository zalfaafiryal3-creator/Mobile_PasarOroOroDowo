import '../entities/store_review.dart';

abstract interface class StoreReviewsRepository {
  Future<StoreReviewStatistics> fetchStatistics(String storeId);

  Future<StoreReviewPage> fetchReviews(
    String storeId, {
    required String filter,
    required String search,
    required int page,
    required int limit,
  });

  Future<List<StoreReview>> submitReview({
    required String name,
    required String text,
    required int rating,
    String? storeId,
  });

  Future<List<StoreReview>> fetchFormReviews();
}
