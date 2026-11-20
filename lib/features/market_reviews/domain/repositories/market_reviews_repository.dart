import 'package:image_picker/image_picker.dart';

import '../entities/market_review.dart';

abstract interface class MarketReviewsRepository {
  Future<MarketReviewPage> fetchReviews({
    required int page,
    required int limit,
    required String filter,
    required String search,
  });

  Future<MarketReviewStatistics> fetchStatistics();

  Future<String> uploadPhoto(XFile photo);

  Future<void> submitReview({
    required String name,
    required String date,
    required String text,
    required int rating,
    List<String> photos = const [],
  });
}
