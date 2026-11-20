import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

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

  Future<String> uploadPhoto(XFile photo) =>
      api.MarketReviewApi.uploadPhoto(photo, client: client);

  Future<void> submitReview({
    required String name,
    required String date,
    required String text,
    required int rating,
    List<String> photos = const [],
  }) => api.MarketReviewApi.submitReview(
    name: name,
    date: date,
    text: text,
    rating: rating,
    photos: photos,
    client: client,
  );
}
