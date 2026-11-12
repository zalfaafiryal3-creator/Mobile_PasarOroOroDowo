import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'api_config.dart';

class RecommendationsApiException implements Exception {
  const RecommendationsApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class RecommendedStore {
  const RecommendedStore({
    required this.id,
    required this.slug,
    required this.name,
    required this.category,
    required this.location,
    required this.status,
    required this.rating,
    required this.photoUrl,
  });

  final int id;
  final String slug;
  final String name;
  final String category;
  final String location;
  final String status;
  final double rating;
  final String? photoUrl;
}

class FeaturedProduct {
  const FeaturedProduct({
    required this.id,
    required this.name,
    required this.photoUrl,
    required this.storeId,
    required this.storeName,
    required this.description,
    required this.price,
    required this.rating,
    required this.storeRating,
    required this.isAvailable,
  });

  final int id;
  final String name;
  final String? photoUrl;
  final int storeId;
  final String storeName;
  final String description;
  final int price;
  final double? rating;
  final double storeRating;
  final bool isAvailable;
}

class RecommendationsApi {
  static http.Client? _testClient;
  static final http.Client _defaultClient = http.Client();

  @visibleForTesting
  static set clientForTesting(http.Client? client) {
    _testClient = client;
  }

  static http.Client get _client => _testClient ?? _defaultClient;

  static Future<List<RecommendedStore>> fetchStores() async {
    final response = await _client
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
          return _parseStore(item);
        })
        .toList(growable: false);
  }

  static Future<List<FeaturedProduct>> fetchFeaturedProducts({
    String sort = 'best_selling',
  }) async {
    final uri = Uri.parse(
      '${ApiConfig.baseUrl}/api/recommendations/featured-products',
    ).replace(queryParameters: {'sort': sort});
    final response = await _client
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
          return _parseProduct(item);
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

  static RecommendedStore _parseStore(Map<String, dynamic> json) {
    final id = json['id'];
    if (id is! int) {
      throw const FormatException('ID toko rekomendasi tidak sesuai.');
    }
    return RecommendedStore(
      id: id,
      slug: _requiredString(json, 'slug'),
      name: _requiredString(json, 'name'),
      category: _requiredString(json, 'category'),
      location: _requiredString(json, 'location'),
      status: _requiredString(json, 'status'),
      rating: _number(json['rating']),
      photoUrl: _imageUrl(json['photoUrl']),
    );
  }

  static FeaturedProduct _parseProduct(Map<String, dynamic> json) {
    final id = json['id'];
    final storeId = json['storeId'];
    final rawPrice = json['price'];
    if (id is! int || storeId is! int || rawPrice is! num) {
      throw const FormatException('Data produk pilihan tidak sesuai.');
    }
    return FeaturedProduct(
      id: id,
      name: _requiredString(json, 'name'),
      photoUrl: _imageUrl(json['photoUrl']),
      storeId: storeId,
      storeName: _requiredString(json, 'storeName'),
      description: _string(json['description']),
      price: rawPrice.toInt(),
      rating: json['rating'] is num ? _number(json['rating']) : null,
      storeRating: _number(json['storeRating']),
      isAvailable: json['isAvailable'] == true,
    );
  }

  static String? _imageUrl(Object? value) {
    if (value is! String || value.trim().isEmpty) return null;
    final image = value.trim();
    if (image.startsWith('http://') || image.startsWith('https://')) {
      return image;
    }
    if (image.startsWith('/')) return '${ApiConfig.baseUrl}$image';
    return image;
  }

  static String _requiredString(Map<String, dynamic> json, String field) {
    final value = json[field];
    if (value is! String || value.trim().isEmpty) {
      throw FormatException('Field $field dari server tidak sesuai.');
    }
    return value.trim();
  }

  static String _string(Object? value) => value is String ? value : '';

  static double _number(Object? value) => value is num ? value.toDouble() : 0;

  static Object? _decodeJson(String body) {
    try {
      return jsonDecode(body);
    } on FormatException {
      throw const FormatException('Respons rekomendasi bukan JSON valid.');
    }
  }
}
