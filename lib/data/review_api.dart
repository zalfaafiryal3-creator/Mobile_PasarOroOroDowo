import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

String _hostFor(String port) {
  if (!kIsWeb && Platform.isAndroid) {
    return '10.0.2.2:$port';
  }
  return 'localhost:$port';
}

class StoreReview {
  const StoreReview({
    required this.id,
    required this.name,
    required this.date,
    required this.text,
    required this.rating,
  });

  final int id;
  final String name;
  final String date;
  final String text;
  final int rating;

  factory StoreReview.fromJson(Map<String, dynamic> json) {
    return StoreReview(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? 'Anonim',
      date: json['date']?.toString() ?? '',
      text: json['text']?.toString() ?? '',
      rating: (json['rating'] as num?)?.toInt() ?? 0,
    );
  }
}

class StoreReviewApi {
  static Uri _uri(String port) =>
      Uri.parse('http://${_hostFor(port)}/api/store-reviews');

  static Future<List<StoreReview>> fetchDetailReviews() =>
      _fetchReviews('5000');

  static Future<List<StoreReview>> fetchFormReviews() =>
      _fetchReviews('4000');

  static Future<List<StoreReview>> _fetchReviews(String port) async {
    final response = await http.get(_uri(port)).timeout(
          const Duration(seconds: 12),
        );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Gagal mengambil data ulasan toko (${response.statusCode}).');
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

  static Future<List<StoreReview>> submitFormReview({
    required String name,
    required String text,
    required int rating,
  }) async {
    final response = await http
        .post(
          _uri('4000'),
          headers: const {'Content-Type': 'application/json'},
          body: jsonEncode({
            'name': name,
            'date': 'Baru saja • Pembeli Terverifikasi',
            'text': text,
            'rating': rating,
          }),
        )
        .timeout(const Duration(seconds: 12));
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
    if (body is! List) {
      throw const FormatException('Format respons ulasan toko tidak sesuai.');
    }
    return body
        .whereType<Map<String, dynamic>>()
        .map(StoreReview.fromJson)
        .toList();
  }

  static Future<List<StoreReview>> submitDetailReview({
    required String name,
    required String text,
  }) async {
    final response = await http
        .post(
          _uri('5000'),
          headers: const {'Content-Type': 'application/json'},
          body: jsonEncode({
            'name': name,
            'date': 'Baru saja • Pembeli',
            'text': text,
            'rating': 5,
          }),
        )
        .timeout(const Duration(seconds: 12));
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
