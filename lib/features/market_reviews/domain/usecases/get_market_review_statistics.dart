import '../entities/market_review.dart';
import '../repositories/market_reviews_repository.dart';

class GetMarketReviewStatistics {
  const GetMarketReviewStatistics(this._repository);

  final MarketReviewsRepository _repository;

  Future<MarketReviewStatistics> call() => _repository.fetchStatistics();
}
