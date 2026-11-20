import '../../domain/entities/promo.dart';
import '../../domain/repositories/promo_repository.dart';
import '../datasources/local/promo_catalog.dart';
import '../datasources/promo_remote_data_source.dart';

class PromoRepositoryImpl implements PromoRepository {
  const PromoRepositoryImpl(this._remoteDataSource, this._localDataSource);

  final PromoRemoteDataSource _remoteDataSource;
  final PromoLocalDataSource _localDataSource;

  @override
  Future<List<Promo>> getPromotions() async {
    final local = _localDataSource.getPromotions();
    final remote = await _remoteDataSource.fetchPromotions();
    final remoteTitles = remote
        .map((promo) => promo.title.toLowerCase())
        .toSet();
    return [
      ...remote,
      ...local.where(
        (promo) => !remoteTitles.contains(promo.title.toLowerCase()),
      ),
    ];
  }

  @override
  List<Promo> getLocalPromotions() => _localDataSource.getPromotions();
}
