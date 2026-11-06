import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'api_config.dart';
import 'market_data.dart';

class StoreApiException implements Exception {
  const StoreApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class StoreApi {
  static http.Client? _testClient;
  static final http.Client _defaultClient = http.Client();

  @visibleForTesting
  static set clientForTesting(http.Client? client) {
    _testClient = client;
  }

  static http.Client get _client => _testClient ?? _defaultClient;

  static Future<List<StoreData>> fetchStores() async {
    final response = await _client
        .get(Uri.parse('${ApiConfig.baseUrl}/api/stores'))
        .timeout(const Duration(seconds: 12));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw _readApiError(response);
    }

    final body = _decodeJson(response.body);
    if (body is! List) {
      throw const FormatException(
        'Format daftar toko dari server tidak sesuai.',
      );
    }
    final backendStores = body.map((item) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException('Data toko dari server tidak sesuai.');
      }
      return _parseStore(item);
    }).toList();

    return marketStores.map((mobileStore) {
      final backendStore = backendStores
          .where((store) => store.id == mobileStore.id)
          .firstOrNull;
      if (backendStore != null && backendStore.name == mobileStore.name) {
        return backendStore;
      }
      return mobileStore;
    }).toList();
  }

  static Future<StoreData> fetchStore(String slug) async {
    final mobileStore = marketStores
        .where((store) => store.id == slug)
        .firstOrNull;
    try {
      final response = await _client
          .get(
            Uri.parse(
              '${ApiConfig.baseUrl}/api/stores/${Uri.encodeComponent(slug)}',
            ),
          )
          .timeout(const Duration(seconds: 12));
      if (response.statusCode == 404 && mobileStore != null) {
        return mobileStore;
      }
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw _readApiError(response);
      }

      final body = _decodeJson(response.body);
      if (body is! Map<String, dynamic>) {
        throw const FormatException(
          'Format detail toko dari server tidak sesuai.',
        );
      }
      final backendStore = _parseStore(body);
      if (mobileStore != null &&
          (backendStore.id != mobileStore.id ||
              backendStore.name != mobileStore.name)) {
        return mobileStore;
      }
      return backendStore;
    } on Exception catch (error) {
      if (mobileStore != null) {
        debugPrint('Gagal memuat detail Backend untuk $slug: $error');
        return mobileStore;
      }
      rethrow;
    }
  }

  static StoreData _parseStore(Map<String, dynamic> json) {
    final slug = _requiredString(json, 'slug');
    final name = _requiredString(json, 'name');
    final category = _requiredString(json, 'category');
    final localStore = marketStores
        .where((store) => store.id == slug)
        .firstOrNull;
    final matchingLocalStore = localStore != null && localStore.name == name
        ? localStore
        : null;
    final ratingValue = _number(json['rating']);
    final productCount = _number(json['productCount']).toInt();
    final rawProducts = json['products'];
    final catalogProducts = rawProducts is List
        ? rawProducts
              .whereType<Map<String, dynamic>>()
              .map(_parseProduct)
              .toList()
        : const <StoreProductData>[];

    return StoreData(
      id: slug,
      name: name,
      category: category,
      displayCategory: matchingLocalStore?.displayCategory ?? '',
      badge: matchingLocalStore?.badge ?? '',
      rating: ratingValue > 0 ? ratingValue.toString() : '',
      products: '$productCount Produk',
      image: matchingLocalStore?.image ?? '',
      owner: _string(json['owner']),
      zone: _string(json['zone']),
      status: _string(json['status']),
      openTime: _nullableString(json['openTime']),
      closeTime: _nullableString(json['closeTime']),
      phone: _string(json['phone']),
      description: _string(json['description']),
      productCount: productCount,
      reviewCount: _number(json['reviewCount']).toInt(),
      catalogProducts: catalogProducts,
      isLocalFallback: false,
    );
  }

  static StoreProductData _parseProduct(Map<String, dynamic> json) {
    final rawPrice = json['price'];
    if (rawPrice is! num) {
      throw const FormatException('Harga produk dari server tidak sesuai.');
    }
    return StoreProductData(
      name: _requiredString(json, 'name'),
      price: rawPrice.toInt(),
      description: _string(json['description']),
      photoUrl: _nullableString(json['photoUrl']),
    );
  }

  static String _requiredString(Map<String, dynamic> json, String field) {
    final value = json[field];
    if (value is! String || value.trim().isEmpty) {
      throw FormatException('Field $field dari server tidak sesuai.');
    }
    return value.trim();
  }

  static String _string(Object? value) => value is String ? value : '';

  static String? _nullableString(Object? value) =>
      value is String && value.trim().isNotEmpty ? value.trim() : null;

  static num _number(Object? value) => value is num ? value : 0;

  static Object? _decodeJson(String body) {
    try {
      return jsonDecode(body);
    } on FormatException {
      throw const FormatException('Respons server bukan JSON yang valid.');
    }
  }

  static StoreApiException _readApiError(http.Response response) {
    try {
      final body = _decodeJson(response.body);
      if (body is Map<String, dynamic> && body['error'] is String) {
        return StoreApiException(body['error'] as String);
      }
    } on FormatException {
      return StoreApiException(
        'Gagal mengambil data toko (${response.statusCode}).',
      );
    }
    return StoreApiException(
      'Gagal mengambil data toko (${response.statusCode}).',
    );
  }
}
