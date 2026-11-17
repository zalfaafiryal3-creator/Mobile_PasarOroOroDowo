import '../entities/visit_plan.dart';
import '../repositories/visit_planner_repository.dart';

class GetVisitRecommendations {
  const GetVisitRecommendations(this._repository);

  final VisitPlannerRepository _repository;

  Future<VisitPlannerResponse> call({
    required int availableTime,
    required String tastePreference,
    required int budget,
  }) => _repository.getRecommendations(
    availableTime: availableTime,
    tastePreference: tastePreference,
    budget: budget,
  );
}
