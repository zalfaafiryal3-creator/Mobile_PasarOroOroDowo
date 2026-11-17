import '../entities/visit_plan.dart';

abstract interface class VisitPlannerRepository {
  Future<VisitPlannerResponse> getRecommendations({
    required int availableTime,
    required String tastePreference,
    required int budget,
  });
}
