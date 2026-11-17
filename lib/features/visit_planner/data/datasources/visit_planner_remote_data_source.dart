import 'package:http/http.dart' as http;

import '../../domain/entities/visit_plan.dart';
import 'visit_planner_api_client.dart';

class VisitPlannerRemoteDataSource {
  const VisitPlannerRemoteDataSource({this.client});

  final http.Client? client;

  Future<VisitPlannerResponse> getRecommendations({
    required int availableTime,
    required String tastePreference,
    required int budget,
  }) => VisitPlannerApi.getRecommendations(
    availableTime: availableTime,
    tastePreference: tastePreference,
    budget: budget,
    client: client,
  );
}
