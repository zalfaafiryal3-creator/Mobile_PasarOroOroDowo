import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:frontend_flutter/core/network/api_config.dart';

import '../models/market_review_model.dart';

class MarketReviewApi {
  static http.Client? clientForTesting;

  static Uri _uri(String path, [Map<String, String>? query]) =>
      Uri.parse('${ApiConfig.baseUrl}/api/market-reviews$path')
          .replace(queryParameters: query);

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

  static Future<MarketReviewPage> fetchReviews({
    required int page,
    int limit = 10,
    String filter = 'all',
    String search = '',
    http.Client? client,
  }) async {
    final uri = _uri('/page', {
      'page': '$page',
      'limit': '$limit',
      'filter': filter,
      if (search.trim().isNotEmpty) 'search': search.trim(),
    });
    final response = await _get(
      uri,
      client: client,
    ).timeout(const Duration(seconds: 12));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Gagal mengambil ulasan pasar (${response.statusCode}).');
    }
    final body = jsonDecode(response.body);
    if (body is! Map<String, dynamic>) {
      throw const FormatException('Format daftar ulasan pasar tidak sesuai.');
    }
    return MarketReviewPage.fromJson(body);
  }

  static Future<MarketReviewStatistics> fetchStatistics({
    http.Client? client,
  }) async {
    final response = await _get(
      _uri('/statistics'),
      client: client,
    ).timeout(const Duration(seconds: 12));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Gagal mengambil statistik ulasan pasar (${response.statusCode}).',
      );
    }
    final body = jsonDecode(response.body);
    if (body is! Map<String, dynamic> ||
        body['data'] is! Map<String, dynamic>) {
      throw const FormatException(
        'Format statistik ulasan pasar tidak sesuai.',
      );
    }
    return MarketReviewStatistics.fromJson(
      body['data'] as Map<String, dynamic>,
    );
  }

  static Future<void> submitReview({
    required String name,
    required String date,
    required String text,
    required int rating,
    http.Client? client,
  }) async {
    final response = await _post(
      _uri(''),
      headers: const {'Content-Type': 'application/json'},
      client: client,
      body: jsonEncode({
        'name': name,
        'date': date,
        'text': text,
        'rating': rating,
      }),
    ).timeout(const Duration(seconds: 12));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      String message = 'Gagal mengirim ulasan pasar (${response.statusCode}).';
      try {
        final body = jsonDecode(response.body);
        if (body is Map && body['error'] is String) {
          message = body['error'] as String;
        }
      } on FormatException {
        // Keep the status-based message for non-JSON responses.
      }
      throw Exception(message);
    }
  }
}
