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

    final storesBySlug = <String, StoreData>{};
    for (final store in backendStores) {
      final existing = storesBySlug[store.id];
      if (existing == null ||
          (!_isPublicStatus(existing.status) &&
              _isPublicStatus(store.status))) {
        storesBySlug[store.id] = store;
      }
    }

    final mergedStores = <String, StoreData>{};
    for (final localStore in marketStores) {
      final backendStore = storesBySlug[localStore.id];
      if (backendStore == null) {
        mergedStores.putIfAbsent(localStore.id, () => localStore);
      } else if (backendStore.name == localStore.name) {
        if (_isPublicStatus(backendStore.status)) {
          mergedStores[localStore.id] = _mergeStores(localStore, backendStore);
        }
      } else {
        mergedStores.putIfAbsent(localStore.id, () => localStore);
      }
    }

    for (final backendStore in storesBySlug.values) {
      if (!_isPublicStatus(backendStore.status) ||
          mergedStores.containsKey(backendStore.id)) {
        continue;
      }
      final localStore = marketStores
          .where((store) => store.id == backendStore.id)
          .firstOrNull;
      if (localStore == null) {
        mergedStores[backendStore.id] = backendStore;
      }
    }

    return mergedStores.values.toList();
  }

  static Future<StoreData> fetchStore(
    String slug, {
    String? expectedName,
  }) async {
    final mobileStore = marketStores
        .where((store) => store.id == slug)
        .firstOrNull;
    final requestedName = expectedName ?? mobileStore?.name;
    final fallbackStore =
        mobileStore != null &&
            (requestedName == null || mobileStore.name == requestedName)
        ? mobileStore
        : null;
    try {
      final response = await _client
          .get(
            Uri.parse(
              '${ApiConfig.baseUrl}/api/stores/${Uri.encodeComponent(slug)}',
            ),
          )
          .timeout(const Duration(seconds: 12));
      if (response.statusCode == 404 && fallbackStore != null) {
        return fallbackStore;
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
      if (backendStore.id != slug ||
          (requestedName != null && backendStore.name != requestedName)) {
        if (fallbackStore != null) return fallbackStore;
        throw const FormatException(
          'Detail toko dari server tidak sesuai dengan toko yang dipilih.',
        );
      }
      if (!_isPublicStatus(backendStore.status)) {
        if (fallbackStore != null) return fallbackStore;
        throw const StoreApiException('Toko belum tersedia untuk publik.');
      }
      final matchingLocalStore =
          mobileStore != null && mobileStore.name == backendStore.name
          ? mobileStore
          : null;
      return matchingLocalStore == null
          ? backendStore
          : _mergeStores(matchingLocalStore, backendStore);
    } on Exception catch (error) {
      if (fallbackStore != null) {
        debugPrint('Gagal memuat detail Backend untuk $slug: $error');
        return fallbackStore;
      }
      rethrow;
    }
  }

  static bool _isPublicStatus(String status) =>
      status == 'buka' || status == 'tutup';

  static StoreData _mergeStores(StoreData local, StoreData backend) =>
      StoreData(
        id: backend.id,
        name: backend.name,
        category: backend.category.isNotEmpty
            ? backend.category
            : local.category,
        displayCategory: backend.displayCategory.isNotEmpty
            ? backend.displayCategory
            : local.displayCategory,
        badge: backend.badge.isNotEmpty ? backend.badge : local.badge,
        rating: backend.rating.isNotEmpty ? backend.rating : local.rating,
        products: backend.productCount > 0 ? backend.products : local.products,
        image: backend.image.isNotEmpty ? backend.image : local.image,
        owner: backend.owner.isNotEmpty ? backend.owner : local.owner,
        zone: backend.zone.isNotEmpty ? backend.zone : local.zone,
        status: backend.status,
        openTime: backend.openTime ?? local.openTime,
        closeTime: backend.closeTime ?? local.closeTime,
        phone: backend.phone.isNotEmpty ? backend.phone : local.phone,
        description: backend.description.isNotEmpty
            ? backend.description
            : local.description,
        productCount: backend.productCount > 0
            ? backend.productCount
            : local.productCount,
        reviewCount: backend.reviewCount > 0
            ? backend.reviewCount
            : local.reviewCount,
        catalogProducts: backend.catalogProducts.isNotEmpty
            ? backend.catalogProducts
            : local.catalogProducts,
        isLocalFallback: false,
      );

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
