import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:frontend_flutter/core/network/api_config.dart';
import 'package:frontend_flutter/features/stores/data/models/store_model.dart';
import 'package:frontend_flutter/features/stores/domain/entities/store.dart';

class StoreApiException implements Exception {
  const StoreApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

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

  static http.Client _resolveClient(http.Client? client) =>
      _testClient ?? client ?? _defaultClient;

  static String backendSlug(String slug) =>
      slug == 'fresh-green' ? 'fresgreen-organic' : slug;
  static bool hasValidImage(StoreData store) {
    final image = store.image.trim();
    if (image.isEmpty) return false;
    final lower = image.toLowerCase();
    if (lower == 'null' || lower == 'none' || lower == 'undefined') {
      return false;
    }
    return true;
  }

  static bool isPublicStatus(String status) =>
      status == 'buka' || status == 'tutup';

  static Future<List<StoreData>> fetchStores({http.Client? client}) async {
    final response = await _resolveClient(client)
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
    return body.map((item) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException('Data toko dari server tidak sesuai.');
      }
      return _parseStore(item);
    }).toList();
  }

  static Future<StoreData> fetchStore(
    String slug, {
    http.Client? client,
  }) async {
    final querySlug = backendSlug(slug);
    final response = await _resolveClient(client)
        .get(
          Uri.parse(
            '${ApiConfig.baseUrl}/api/stores/${Uri.encodeComponent(querySlug)}',
          ),
        )
        .timeout(const Duration(seconds: 12));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw _readApiError(response);
    }

    final body = _decodeJson(response.body);
    if (body is! Map<String, dynamic>) {
      throw const FormatException(
        'Format detail toko dari server tidak sesuai.',
      );
    }
    return _parseStore(body);
  }

  static StoreData _parseStore(Map<String, dynamic> json) =>
      StoreModel.fromJson(
        json,
        baseUrl: ApiConfig.baseUrl,
        matchingLocalStore: null,
      );
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
        return StoreApiException(
          body['error'] as String,
          statusCode: response.statusCode,
        );
      }
    } on FormatException {
      return StoreApiException(
        'Gagal mengambil data toko (${response.statusCode}).',
        statusCode: response.statusCode,
      );
    }
    return StoreApiException(
      'Gagal mengambil data toko (${response.statusCode}).',
      statusCode: response.statusCode,
    );
  }
}
