import '../entities/promo.dart';

abstract interface class PromoRepository {
  Future<List<Promo>> getPromotions();
  List<Promo> getLocalPromotions();
}
