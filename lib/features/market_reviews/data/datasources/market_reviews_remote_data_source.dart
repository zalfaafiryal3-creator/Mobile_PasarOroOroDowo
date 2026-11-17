import 'package:http/http.dart' as http;

import 'market_review_api.dart' as api;
import '../models/market_review_model.dart' as model;

class MarketReviewsRemoteDataSource {
  const MarketReviewsRemoteDataSource({this.client});

  final http.Client? client;

  Future<model.MarketReviewPage> fetchReviews({
    required int page,
    required int limit,
    required String filter,
    required String search,
  }) => api.MarketReviewApi.fetchReviews(
    page: page,
    limit: limit,
    filter: filter,
    search: search,
    client: client,
  );

  Future<model.MarketReviewStatistics> fetchStatistics() =>
      api.MarketReviewApi.fetchStatistics(client: client);

  Future<void> submitReview({
    required String name,
    required String date,
    required String text,
    required int rating,
  }) => api.MarketReviewApi.submitReview(
    name: name,
    date: date,
    text: text,
    rating: rating,
    client: client,
  );
}
