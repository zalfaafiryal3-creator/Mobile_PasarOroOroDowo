import '../entities/recommendation.dart';
import '../repositories/recommendations_repository.dart';

class GetFeaturedProducts {
  const GetFeaturedProducts(this._repository);

  final RecommendationsRepository _repository;

  Future<List<FeaturedProduct>> call({required String sort}) =>
      _repository.fetchFeaturedProducts(sort: sort);
}
