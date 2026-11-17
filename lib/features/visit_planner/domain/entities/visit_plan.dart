class RecommendedProduct {
  const RecommendedProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    this.photoUrl,
  });

  final int id;
  final String name;
  final int price;
  final String description;
  final String? photoUrl;
}

class VisitPlannerStop {
  const VisitPlannerStop({
    required this.order,
    required this.storeId,
    required this.storeName,
    required this.category,
    required this.zone,
    required this.products,
    required this.estimatedCost,
    required this.estimatedTime,
    required this.reason,
  });

  final int order;
  final int storeId;
  final String storeName;
  final String category;
  final String zone;
  final List<RecommendedProduct> products;
  final int estimatedCost;
  final int estimatedTime;
  final String reason;
}

class VisitPlanResult {
  const VisitPlanResult({
    required this.title,
    this.budget = 0,
    required this.totalEstimatedCost,
    this.remainingBudget = 0,
    required this.totalEstimatedTime,
    required this.stops,
  });

  final String title;
  final int budget;
  final int totalEstimatedCost;
  final int remainingBudget;
  final int totalEstimatedTime;
  final List<VisitPlannerStop> stops;
}

class VisitPlannerResponse {
  const VisitPlannerResponse({
    required this.success,
    required this.message,
    this.data,
  });

  final bool success;
  final String message;
  final VisitPlanResult? data;
}

class VisitPlannerFailure implements Exception {
  const VisitPlannerFailure(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}
