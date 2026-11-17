import '../../domain/entities/promo.dart';
import '../../domain/repositories/promo_repository.dart';
import '../datasources/local/promo_catalog.dart';

class PromoRepositoryImpl implements PromoRepository {
  const PromoRepositoryImpl(this._dataSource);

  final PromoLocalDataSource _dataSource;

  @override
  List<Promo> getPromotions() => _dataSource.getPromotions();
}
