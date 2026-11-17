import '../../domain/entities/market_review.dart' as domain;
import '../../domain/repositories/market_reviews_repository.dart';
import '../models/market_review_model.dart' as model;
import '../datasources/market_reviews_remote_data_source.dart';

class MarketReviewsRepositoryImpl implements MarketReviewsRepository {
  const MarketReviewsRepositoryImpl(this._dataSource);

  final MarketReviewsRemoteDataSource _dataSource;

  @override
  Future<domain.MarketReviewPage> fetchReviews({
    required int page,
    required int limit,
    required String filter,
    required String search,
  }) async {
    final result = await _dataSource.fetchReviews(
      page: page,
      limit: limit,
      filter: filter,
      search: search,
    );
    return domain.MarketReviewPage(
      reviews: result.reviews.map(_toEntity).toList(growable: false),
      totalCount: result.totalCount,
      page: result.page,
      limit: result.limit,
    );
  }

  @override
  Future<domain.MarketReviewStatistics> fetchStatistics() async {
    final statistics = await _dataSource.fetchStatistics();
    return domain.MarketReviewStatistics(
      totalReviews: statistics.totalReviews,
      withPhoto: statistics.withPhoto,
      star5: statistics.star5,
      star4: statistics.star4,
      star1To3: statistics.star1To3,
    );
  }

  @override
  Future<void> submitReview({
    required String name,
    required String date,
    required String text,
    required int rating,
  }) => _dataSource.submitReview(
    name: name,
    date: date,
    text: text,
    rating: rating,
  );

  domain.MarketReview _toEntity(model.MarketReview review) =>
      domain.MarketReview(
        id: review.id,
        name: review.name,
        date: review.date,
        text: review.text,
        rating: review.rating,
        photos: review.photos,
      );
}
