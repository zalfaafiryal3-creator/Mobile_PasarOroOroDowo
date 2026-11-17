import '../entities/promo.dart';
import '../repositories/promo_repository.dart';

class GetPromotions {
  const GetPromotions(this._repository);

  final PromoRepository _repository;

  List<Promo> call() => _repository.getPromotions();
}
