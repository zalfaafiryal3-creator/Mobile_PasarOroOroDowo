import '../../domain/entities/visit_plan.dart';
import '../../domain/repositories/visit_planner_repository.dart';
import '../datasources/visit_planner_remote_data_source.dart';

class VisitPlannerRepositoryImpl implements VisitPlannerRepository {
  const VisitPlannerRepositoryImpl(this._dataSource);

  final VisitPlannerRemoteDataSource _dataSource;

  @override
  Future<VisitPlannerResponse> getRecommendations({
    required int availableTime,
    required String tastePreference,
    required int budget,
  }) => _dataSource.getRecommendations(
    availableTime: availableTime,
    tastePreference: tastePreference,
    budget: budget,
  );
}
