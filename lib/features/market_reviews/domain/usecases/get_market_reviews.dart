import '../entities/market_review.dart';
import '../repositories/market_reviews_repository.dart';

class GetMarketReviews {
  const GetMarketReviews(this._repository);

  final MarketReviewsRepository _repository;

  Future<MarketReviewPage> call({
    required int page,
    int limit = 10,
    String filter = 'all',
    String search = '',
  }) => _repository.fetchReviews(
    page: page,
    limit: limit,
    filter: filter,
    search: search,
  );
}
