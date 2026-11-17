import '../../domain/entities/recommendation.dart';
import '../../domain/repositories/recommendations_repository.dart';
import '../datasources/recommendations_remote_data_source.dart';

class RecommendationsRepositoryImpl implements RecommendationsRepository {
  const RecommendationsRepositoryImpl(this._dataSource);

  final RecommendationsRemoteDataSource _dataSource;

  @override
  Future<List<RecommendedStore>> fetchStores() => _dataSource.fetchStores();

  @override
  Future<List<FeaturedProduct>> fetchFeaturedProducts({required String sort}) =>
      _dataSource.fetchFeaturedProducts(sort: sort);
}
