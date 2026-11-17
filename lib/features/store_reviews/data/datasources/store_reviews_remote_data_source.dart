import 'package:http/http.dart' as http;

import 'store_review_api.dart' as api;
import '../models/store_review_model.dart' as model;

class StoreReviewsRemoteDataSource {
  const StoreReviewsRemoteDataSource({this.client});

  final http.Client? client;

  Future<model.StoreReviewStatistics> fetchStatistics(String storeId) =>
      api.StoreReviewApi.fetchStoreStatistics(storeId, client: client);

  Future<model.StoreReviewPage> fetchReviews(
    String storeId, {
    required String filter,
    required String search,
    required int page,
    required int limit,
  }) => api.StoreReviewApi.fetchStoreReviews(
    storeId,
    filter: filter,
    search: search,
    page: page,
    limit: limit,
    client: client,
  );

  Future<List<model.StoreReview>> submitReview({
    required String name,
    required String text,
    required int rating,
    String? storeId,
  }) => api.StoreReviewApi.submitFormReview(
    name: name,
    text: text,
    rating: rating,
    storeId: storeId,
    client: client,
  );

  Future<List<model.StoreReview>> fetchFormReviews() =>
      api.StoreReviewApi.fetchFormReviews(client: client);
}
