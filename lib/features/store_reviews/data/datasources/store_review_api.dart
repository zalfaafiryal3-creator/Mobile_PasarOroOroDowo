import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:frontend_flutter/core/network/api_config.dart';

import '../models/store_review_model.dart';

class StoreReviewApi {
  @visibleForTesting
  static http.Client? clientForTesting;

  static Future<http.Response> _get(Uri uri, {http.Client? client}) {
    final requestClient = clientForTesting ?? client;
    return requestClient == null ? http.get(uri) : requestClient.get(uri);
  }

  static Future<http.Response> _post(
    Uri uri, {
    required Map<String, String> headers,
    required String body,
    http.Client? client,
  }) {
    final requestClient = clientForTesting ?? client;
    return requestClient == null
        ? http.post(uri, headers: headers, body: body)
        : requestClient.post(uri, headers: headers, body: body);
  }

  static Uri _uri() => Uri.parse('${ApiConfig.baseUrl}/api/store-reviews');

  static Uri _storeUri(String storeId, [String suffix = '']) => Uri.parse(
    '${ApiConfig.baseUrl}/api/stores/${Uri.encodeComponent(storeId)}/reviews$suffix',
  );

  static Future<List<StoreReview>> fetchDetailReviews({http.Client? client}) =>
      _fetchReviews(client: client);

  static Future<List<StoreReview>> fetchFormReviews({http.Client? client}) =>
      _fetchReviews(client: client);

  static Future<List<StoreReview>> _fetchReviews({http.Client? client}) async {
    final response = await _get(
      _uri(),
      client: client,
    ).timeout(const Duration(seconds: 12));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Gagal mengambil data ulasan toko (${response.statusCode}).',
      );
    }
    final body = jsonDecode(response.body);
    if (body is! List) {
      throw const FormatException('Format data ulasan toko tidak sesuai.');
    }
    return body
        .whereType<Map<String, dynamic>>()
        .map(StoreReview.fromJson)
        .toList();
  }

  static Future<StoreReviewStatistics> fetchStoreStatistics(
    String storeId, {
    http.Client? client,
  }) async {
    final response = await _get(
      _storeUri(storeId, '/statistics'),
      client: client,
    ).timeout(const Duration(seconds: 12));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        response.statusCode == 404
            ? 'Toko belum terdaftar di server. Admin perlu mendaftarkan atau menyinkronkan toko ke Kelola Toko.'
            : 'Gagal mengambil statistik ulasan toko (${response.statusCode}).',
      );
    }
    final body = jsonDecode(response.body);
    if (body is! Map<String, dynamic> ||
        body['data'] is! Map<String, dynamic>) {
      throw const FormatException('Format statistik ulasan toko tidak sesuai.');
    }
    return StoreReviewStatistics.fromJson(body['data'] as Map<String, dynamic>);
  }

  static Future<StoreReviewPage> fetchStoreReviews(
    String storeId, {
    String filter = 'all',
    String search = '',
    int page = 1,
    int limit = 20,
    http.Client? client,
  }) async {
    final uri = _storeUri(storeId).replace(
      queryParameters: {
        'filter': filter,
        'page': '$page',
        'limit': '$limit',
        if (search.trim().isNotEmpty) 'search': search.trim(),
      },
    );
    final response = await _get(
      uri,
      client: client,
    ).timeout(const Duration(seconds: 12));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        response.statusCode == 404
            ? 'Toko belum terdaftar di server. Admin perlu mendaftarkan atau menyinkronkan toko ke Kelola Toko.'
            : 'Gagal mengambil daftar ulasan toko (${response.statusCode}).',
      );
    }
    final body = jsonDecode(response.body);
    if (body is! Map<String, dynamic>) {
      throw const FormatException('Format daftar ulasan toko tidak sesuai.');
    }
    return StoreReviewPage.fromJson(body);
  }

  static Future<List<StoreReview>> submitFormReview({
    required String name,
    required String text,
    required int rating,
    String? storeId,
    http.Client? client,
  }) async {
    final response = await _post(
      storeId == null ? _uri() : _storeUri(storeId),
      headers: const {'Content-Type': 'application/json'},
      client: client,
      body: jsonEncode({
        'name': name,
        'date': 'Baru saja • Pembeli Terverifikasi',
        'text': text,
        'rating': rating,
      }),
    ).timeout(const Duration(seconds: 12));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      String message = 'Gagal mengirim ulasan (${response.statusCode}).';
      try {
        final decoded = jsonDecode(response.body);
        if (decoded is Map && decoded['error'] is String) {
          message = decoded['error'] as String;
        }
      } on FormatException {
        // Retain the status-based message when the API does not return JSON.
      }
      throw Exception(message);
    }
    final body = jsonDecode(response.body);
    final reviewList = body is Map<String, dynamic> ? body['data'] : body;
    if (reviewList is! List) {
      throw const FormatException('Format respons ulasan toko tidak sesuai.');
    }
    return reviewList
        .whereType<Map<String, dynamic>>()
        .map(StoreReview.fromJson)
        .toList();
  }

  static Future<List<StoreReview>> submitDetailReview({
    required String name,
    required String text,
    http.Client? client,
  }) async {
    final response = await _post(
      _uri(),
      headers: const {'Content-Type': 'application/json'},
      client: client,
      body: jsonEncode({
        'name': name,
        'date': 'Baru saja • Pembeli',
        'text': text,
        'rating': 5,
      }),
    ).timeout(const Duration(seconds: 12));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Gagal mengirim ulasan (${response.statusCode}).');
    }
    final body = jsonDecode(response.body);
    if (body is! List) {
      throw const FormatException('Format respons ulasan toko tidak sesuai.');
    }
    return body
        .whereType<Map<String, dynamic>>()
        .map(StoreReview.fromJson)
        .toList();
  }
}
