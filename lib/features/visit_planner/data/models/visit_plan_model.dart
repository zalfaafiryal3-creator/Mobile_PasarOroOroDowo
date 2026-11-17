import '../../domain/entities/visit_plan.dart';

class VisitPlanModel {
  static VisitPlannerResponse fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    return VisitPlannerResponse(
      success: json['success'] as bool? ?? false,
      message: (json['message'] as String?)?.trim() ?? '',
      data: rawData is Map<String, dynamic> ? _resultFromJson(rawData) : null,
    );
  }

  static VisitPlanResult _resultFromJson(Map<String, dynamic> json) {
    final budget = json['budget'] is num ? (json['budget'] as num).toInt() : 0;
    final totalCost = json['totalEstimatedCost'] is num
        ? (json['totalEstimatedCost'] as num).toInt()
        : 0;
    final remaining = json['remainingBudget'] is num
        ? (json['remainingBudget'] as num).toInt()
        : (budget > 0 ? budget - totalCost : 0);
    final rawStops = json['stops'];
    final stops = rawStops is List
        ? rawStops.whereType<Map<String, dynamic>>().map(_stopFromJson).toList()
        : <VisitPlannerStop>[];

    return VisitPlanResult(
      title: (json['title'] as String?)?.trim() ?? '',
      budget: budget,
      totalEstimatedCost: totalCost,
      remainingBudget: remaining,
      totalEstimatedTime: json['totalEstimatedTime'] is num
          ? (json['totalEstimatedTime'] as num).toInt()
          : 0,
      stops: stops,
    );
  }

  static VisitPlannerStop _stopFromJson(Map<String, dynamic> json) {
    final rawProducts = json['products'];
    final products = rawProducts is List
        ? rawProducts
              .whereType<Map<String, dynamic>>()
              .map(_productFromJson)
              .toList()
        : <RecommendedProduct>[];

    return VisitPlannerStop(
      order: json['order'] is num ? (json['order'] as num).toInt() : 0,
      storeId: json['storeId'] is num ? (json['storeId'] as num).toInt() : 0,
      storeName: (json['storeName'] as String?)?.trim() ?? '',
      category: (json['category'] as String?)?.trim() ?? '',
      zone: (json['zone'] as String?)?.trim() ?? '',
      products: products,
      estimatedCost: json['estimatedCost'] is num
          ? (json['estimatedCost'] as num).toInt()
          : 0,
      estimatedTime: json['estimatedTime'] is num
          ? (json['estimatedTime'] as num).toInt()
          : 0,
      reason: (json['reason'] as String?)?.trim() ?? '',
    );
  }

  static RecommendedProduct _productFromJson(Map<String, dynamic> json) {
    final rawPrice = json['price'];
    return RecommendedProduct(
      id: json['id'] is num ? (json['id'] as num).toInt() : 0,
      name: (json['name'] as String?)?.trim() ?? '',
      price: rawPrice is num ? rawPrice.toInt() : 0,
      description: (json['description'] as String?)?.trim() ?? '',
      photoUrl: (json['photoUrl'] as String?)?.trim(),
    );
  }
}
