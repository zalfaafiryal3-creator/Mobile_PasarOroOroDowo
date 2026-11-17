import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:frontend_flutter/core/network/api_config.dart';
import 'package:frontend_flutter/features/visit_planner/data/models/visit_plan_model.dart';
import 'package:frontend_flutter/features/visit_planner/domain/entities/visit_plan.dart';

typedef VisitPlannerApiException = VisitPlannerFailure;

class VisitPlannerApi {
  static http.Client? _testClient;
  static final http.Client _defaultClient = http.Client();

  @visibleForTesting
  static set clientForTesting(http.Client? client) {
    _testClient = client;
  }

  static http.Client _resolveClient(http.Client? client) =>
      _testClient ?? client ?? _defaultClient;

  /// Meminta rekomendasi rute kunjungan AI ke backend
  static Future<VisitPlannerResponse> getRecommendations({
    required int availableTime,
    required String tastePreference,
    required int budget,
    http.Client? client,
  }) async {
    final url = Uri.parse(
      '${ApiConfig.baseUrl}/api/visit-planner/recommendations',
    );

    final payload = jsonEncode({
      'availableTime': availableTime,
      'tastePreference': tastePreference,
      'budget': budget,
    });

    try {
      final response = await _resolveClient(client)
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
          throw const VisitPlannerFailure(
            'Format data respons server tidak sesuai.',
          );
        }
        return VisitPlanModel.fromJson(decoded);
      }

      if (statusCode == 400) {
        final decoded = _tryDecodeJson(response.body);
        if (decoded is Map<String, dynamic>) {
          if (decoded['errors'] is List &&
              (decoded['errors'] as List).isNotEmpty) {
            final errors = (decoded['errors'] as List).join('\n');
            throw VisitPlannerFailure(errors, statusCode: 400);
          }
          if (decoded['message'] is String) {
            throw VisitPlannerFailure(
              decoded['message'] as String,
              statusCode: 400,
            );
          }
        }
        throw const VisitPlannerFailure(
          'Permintaan tidak valid (400).',
          statusCode: 400,
        );
      }

      if (statusCode == 500) {
        final decoded = _tryDecodeJson(response.body);
        if (decoded is Map<String, dynamic> && decoded['message'] is String) {
          throw VisitPlannerFailure(
            decoded['message'] as String,
            statusCode: 500,
          );
        }
        throw const VisitPlannerFailure(
          'Terjadi gangguan pada server. Silakan coba beberapa saat lagi.',
          statusCode: 500,
        );
      }

      throw VisitPlannerFailure(
        'Gagal memuat rekomendasi kunjungan (Kode: $statusCode).',
        statusCode: statusCode,
      );
    } on SocketException {
      throw const VisitPlannerFailure(
        'Tidak dapat terhubung ke server. Pastikan backend aktif dan perangkat terhubung.',
      );
    } on http.ClientException {
      throw const VisitPlannerFailure(
        'Koneksi ke backend gagal. Periksa koneksi jaringan Anda.',
      );
    } on FormatException catch (e) {
      throw VisitPlannerFailure(e.message);
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
