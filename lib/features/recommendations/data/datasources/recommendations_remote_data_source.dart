import 'package:http/http.dart' as http;

import '../../domain/entities/recommendation.dart';
import 'recommendations_api_client.dart';

class RecommendationsRemoteDataSource {
  const RecommendationsRemoteDataSource({this.client});

  final http.Client? client;

  Future<List<RecommendedStore>> fetchStores() =>
      RecommendationsApi.fetchStores(client: client);

  Future<List<FeaturedProduct>> fetchFeaturedProducts({required String sort}) =>
      RecommendationsApi.fetchFeaturedProducts(sort: sort, client: client);
}
