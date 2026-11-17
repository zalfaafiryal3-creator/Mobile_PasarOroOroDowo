import '../../domain/entities/store_review.dart' as domain;
import '../../domain/repositories/store_reviews_repository.dart';
import '../datasources/store_reviews_remote_data_source.dart';
import '../models/store_review_model.dart' as model;

class StoreReviewsRepositoryImpl implements StoreReviewsRepository {
  const StoreReviewsRepositoryImpl(this._dataSource);

  final StoreReviewsRemoteDataSource _dataSource;

  @override
  Future<domain.StoreReviewStatistics> fetchStatistics(String storeId) async {
    final statistics = await _dataSource.fetchStatistics(storeId);
    return domain.StoreReviewStatistics(
      totalReviews: statistics.totalReviews,
      withPhoto: statistics.withPhoto,
      star5: statistics.star5,
      star4: statistics.star4,
      star1To3: statistics.star1To3,
    );
  }

  @override
  Future<domain.StoreReviewPage> fetchReviews(
    String storeId, {
    required String filter,
    required String search,
    required int page,
    required int limit,
  }) async {
    final result = await _dataSource.fetchReviews(
      storeId,
      filter: filter,
      search: search,
      page: page,
      limit: limit,
    );
    return domain.StoreReviewPage(
      reviews: result.reviews.map(_toEntity).toList(growable: false),
      totalCount: result.totalCount,
      currentPageCount: result.currentPageCount,
      page: result.page,
      limit: result.limit,
    );
  }

  @override
  Future<List<domain.StoreReview>> submitReview({
    required String name,
    required String text,
    required int rating,
    String? storeId,
  }) async {
    final result = await _dataSource.submitReview(
      name: name,
      text: text,
      rating: rating,
      storeId: storeId,
    );
    return result.map(_toEntity).toList(growable: false);
  }

  @override
  Future<List<domain.StoreReview>> fetchFormReviews() async =>
      (await _dataSource.fetchFormReviews())
          .map(_toEntity)
          .toList(growable: false);

  domain.StoreReview _toEntity(model.StoreReview review) => domain.StoreReview(
    id: review.id,
    name: review.name,
    date: review.date,
    text: review.text,
    rating: review.rating,
    photos: review.photos,
  );
}
