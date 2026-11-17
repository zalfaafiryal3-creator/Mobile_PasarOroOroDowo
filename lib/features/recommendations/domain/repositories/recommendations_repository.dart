import '../entities/recommendation.dart';

abstract interface class RecommendationsRepository {
  Future<List<RecommendedStore>> fetchStores();

  Future<List<FeaturedProduct>> fetchFeaturedProducts({required String sort});
}
