import '../entities/recommendation.dart';
import '../repositories/recommendations_repository.dart';

class GetRecommendedStores {
  const GetRecommendedStores(this._repository);

  final RecommendationsRepository _repository;

  Future<List<RecommendedStore>> call() => _repository.fetchStores();
}
