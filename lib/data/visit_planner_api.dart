import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'api_config.dart';

class VisitPlannerApiException implements Exception {
  const VisitPlannerApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

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

  factory RecommendedProduct.fromJson(Map<String, dynamic> json) {
    final rawPrice = json['price'];
    final price = rawPrice is num ? rawPrice.toInt() : 0;

    return RecommendedProduct(
      id: json['id'] is num ? (json['id'] as num).toInt() : 0,
      name: (json['name'] as String?)?.trim() ?? '',
      price: price,
      description: (json['description'] as String?)?.trim() ?? '',
      photoUrl: (json['photoUrl'] as String?)?.trim(),
    );
  }
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
  final int estimatedTime; // Dalam menit
  final String reason;

  factory VisitPlannerStop.fromJson(Map<String, dynamic> json) {
    final rawCost = json['estimatedCost'];
    final estimatedCost = rawCost is num ? rawCost.toInt() : 0;

    final rawTime = json['estimatedTime'];
    final estimatedTime = rawTime is num ? rawTime.toInt() : 0;

    final rawProducts = json['products'];
    final products = <RecommendedProduct>[];
    if (rawProducts is List) {
      for (final item in rawProducts) {
        if (item is Map<String, dynamic>) {
          products.add(RecommendedProduct.fromJson(item));
        }
      }
    }

    return VisitPlannerStop(
      order: json['order'] is num ? (json['order'] as num).toInt() : 0,
      storeId: json['storeId'] is num ? (json['storeId'] as num).toInt() : 0,
      storeName: (json['storeName'] as String?)?.trim() ?? '',
      category: (json['category'] as String?)?.trim() ?? '',
      zone: (json['zone'] as String?)?.trim() ?? '',
      products: products,
      estimatedCost: estimatedCost,
      estimatedTime: estimatedTime,
      reason: (json['reason'] as String?)?.trim() ?? '',
    );
  }
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

  factory VisitPlanResult.fromJson(Map<String, dynamic> json) {
    final rawBudget = json['budget'];
    final budget = rawBudget is num ? rawBudget.toInt() : 0;

    final rawCost = json['totalEstimatedCost'];
    final totalEstimatedCost = rawCost is num ? rawCost.toInt() : 0;

    final rawRemaining = json['remainingBudget'];
    final remainingBudget = rawRemaining is num
        ? rawRemaining.toInt()
        : (budget > 0 ? (budget - totalEstimatedCost) : 0);

    final rawTime = json['totalEstimatedTime'];
    final totalEstimatedTime = rawTime is num ? rawTime.toInt() : 0;

    final rawStops = json['stops'];
    final stops = <VisitPlannerStop>[];
    if (rawStops is List) {
      for (final item in rawStops) {
        if (item is Map<String, dynamic>) {
          stops.add(VisitPlannerStop.fromJson(item));
        }
      }
    }

    return VisitPlanResult(
      title: (json['title'] as String?)?.trim() ?? '',
      budget: budget,
      totalEstimatedCost: totalEstimatedCost,
      remainingBudget: remainingBudget,
      totalEstimatedTime: totalEstimatedTime,
      stops: stops,
    );
  }
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

  factory VisitPlannerResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    VisitPlanResult? data;
    if (rawData is Map<String, dynamic>) {
      data = VisitPlanResult.fromJson(rawData);
    }

    return VisitPlannerResponse(
      success: json['success'] as bool? ?? false,
      message: (json['message'] as String?)?.trim() ?? '',
      data: data,
    );
  }
}

class VisitPlannerApi {
  static http.Client? _testClient;
  static final http.Client _defaultClient = http.Client();

  @visibleForTesting
  static set clientForTesting(http.Client? client) {
    _testClient = client;
  }

  static http.Client get _client => _testClient ?? _defaultClient;

  /// Meminta rekomendasi rute kunjungan AI ke backend
  static Future<VisitPlannerResponse> getRecommendations({
    required int availableTime,
    required String tastePreference,
    required int budget,
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/visit-planner/recommendations');

    final payload = jsonEncode({
      'availableTime': availableTime,
      'tastePreference': tastePreference,
      'budget': budget,
    });

    try {
      final response = await _client
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: payload,
          )
          .timeout(const Duration(seconds: 15));

      final statusCode = response.statusCode;

      if (statusCode >= 200 && statusCode < 300) {
        final decoded = _decodeJson(response.body);
        if (decoded is! Map<String, dynamic>) {
          throw const VisitPlannerApiException('Format data respons server tidak sesuai.');
        }
        return VisitPlannerResponse.fromJson(decoded);
      }

      if (statusCode == 400) {
        final decoded = _tryDecodeJson(response.body);
        if (decoded is Map<String, dynamic>) {
          if (decoded['errors'] is List && (decoded['errors'] as List).isNotEmpty) {
            final errors = (decoded['errors'] as List).join('\n');
            throw VisitPlannerApiException(errors, statusCode: 400);
          }
          if (decoded['message'] is String) {
            throw VisitPlannerApiException(decoded['message'] as String, statusCode: 400);
          }
        }
        throw const VisitPlannerApiException('Permintaan tidak valid (400).', statusCode: 400);
      }

      if (statusCode == 500) {
        final decoded = _tryDecodeJson(response.body);
        if (decoded is Map<String, dynamic> && decoded['message'] is String) {
          throw VisitPlannerApiException(decoded['message'] as String, statusCode: 500);
        }
        throw const VisitPlannerApiException(
          'Terjadi gangguan pada server. Silakan coba beberapa saat lagi.',
          statusCode: 500,
        );
      }

      throw VisitPlannerApiException(
        'Gagal memuat rekomendasi kunjungan (Kode: $statusCode).',
        statusCode: statusCode,
      );
    } on SocketException {
      throw const VisitPlannerApiException(
        'Tidak dapat terhubung ke server. Pastikan backend aktif dan perangkat terhubung.',
      );
    } on http.ClientException {
      throw const VisitPlannerApiException(
        'Koneksi ke backend gagal. Periksa koneksi jaringan Anda.',
      );
    } on FormatException catch (e) {
      throw VisitPlannerApiException(e.message);
    }
  }

  static Object? _decodeJson(String body) {
    try {
      return jsonDecode(body);
    } on FormatException {
      throw const FormatException('Respons server bukan JSON yang valid.');
    }
  }

  static Object? _tryDecodeJson(String body) {
    try {
      return jsonDecode(body);
    } catch (_) {
      return null;
    }
  }
}

