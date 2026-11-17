import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:frontend_flutter/core/network/api_config.dart';
import 'package:frontend_flutter/features/recommendations/domain/entities/recommendation.dart';
import 'package:frontend_flutter/features/recommendations/data/models/recommendation_model.dart';

class RecommendationsApiException implements Exception {
  const RecommendationsApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class RecommendationsApi {
  static http.Client? _testClient;
  static final http.Client _defaultClient = http.Client();

  @visibleForTesting
  static set clientForTesting(http.Client? client) {
    _testClient = client;
  }

  static http.Client _resolveClient(http.Client? client) =>
      _testClient ?? client ?? _defaultClient;

  static Future<List<RecommendedStore>> fetchStores({
    http.Client? client,
  }) async {
    final response = await _resolveClient(client)
        .get(Uri.parse('${ApiConfig.baseUrl}/api/recommendations/stores'))
        .timeout(const Duration(seconds: 12));
    final data = _successData(response);
    if (data is! List) {
      throw const FormatException(
        'Format toko rekomendasi dari server tidak sesuai.',
      );
    }
    return data
        .map((item) {
          if (item is! Map<String, dynamic>) {
            throw const FormatException('Data toko rekomendasi tidak sesuai.');
          }
          return RecommendedStoreModel.fromJson(
            item,
            baseUrl: ApiConfig.baseUrl,
          );
        })
        .toList(growable: false);
  }

  static Future<List<FeaturedProduct>> fetchFeaturedProducts({
    String sort = 'best_selling',
    http.Client? client,
  }) async {
    final uri = Uri.parse(
      '${ApiConfig.baseUrl}/api/recommendations/featured-products',
    ).replace(queryParameters: {'sort': sort});
    final response = await _resolveClient(client)
        .get(uri)
        .timeout(const Duration(seconds: 12));
    final data = _successData(response);
    if (data is! Map<String, dynamic> || data['products'] is! List) {
      throw const FormatException(
        'Format produk pilihan dari server tidak sesuai.',
      );
    }
    return (data['products'] as List)
        .map((item) {
          if (item is! Map<String, dynamic>) {
            throw const FormatException('Data produk pilihan tidak sesuai.');
          }
          return FeaturedProductModel.fromJson(
            item,
            baseUrl: ApiConfig.baseUrl,
          );
        })
        .where((product) => product.isAvailable)
        .toList(growable: false);
  }

  static Object? _successData(http.Response response) {
    final body = _decodeJson(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = body is Map<String, dynamic>
          ? body['message'] ?? body['error']
          : null;
      throw RecommendationsApiException(
        message is String
            ? message
            : 'Gagal memuat rekomendasi (${response.statusCode}).',
      );
    }
    if (body is! Map<String, dynamic> || body['success'] != true) {
      throw const FormatException(
        'Format respons rekomendasi dari server tidak sesuai.',
      );
    }
    return body['data'];
  }

  static Object? _decodeJson(String body) {
    try {
      return jsonDecode(body);
    } on FormatException {
      throw const FormatException('Respons rekomendasi bukan JSON valid.');
    }
  }
}
