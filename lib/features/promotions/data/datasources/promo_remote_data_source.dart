import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/network/api_config.dart';
import '../../domain/entities/promo.dart';

class PromoRemoteDataSource {
  const PromoRemoteDataSource({this.client});

  final http.Client? client;

  Future<List<Promo>> fetchPromotions() async {
    final requestClient = client ?? http.Client();
    final shouldCloseClient = client == null;
    try {
      final response = await requestClient
          .get(Uri.parse('${ApiConfig.baseUrl}/api/promotions'))
          .timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) {
        throw PromoApiException(
          'Promo gagal dimuat dari server (HTTP ${response.statusCode}).',
        );
      }

      final Object? decoded;
      try {
        decoded = jsonDecode(response.body);
      } on FormatException {
        throw const PromoApiException(
          'Format data promo dari server tidak valid.',
        );
      }
      if (decoded is! List) {
        throw const PromoApiException('Daftar promo dari server tidak sesuai.');
      }
      return decoded.map((item) {
        if (item is! Map<String, dynamic>) {
          throw const PromoApiException('Data promo dari server tidak sesuai.');
        }
        return _promoFromJson(item);
      }).toList();
    } finally {
      if (shouldCloseClient) requestClient.close();
    }
  }

  Promo _promoFromJson(Map<String, dynamic> json) {
    String requiredString(String key) {
      final value = json[key];
      if (value is! String || value.trim().isEmpty) {
        throw PromoApiException('Field $key dari promo tidak sesuai.');
      }
      return value.trim();
    }

    String optionalString(String key, [String fallback = '']) {
      final value = json[key];
      return value is String ? value.trim() : fallback;
    }

    final status = requiredString('status');
    final periodType = requiredString('periodType');
    final image = optionalString('bannerImage');
    return Promo(
      title: requiredString('title'),
      image: image.startsWith('/') ? '${ApiConfig.baseUrl}$image' : image,
      status: status,
      note: requiredString('store'),
      description: requiredString('description'),
      period: requiredString('periodDisplay'),
      periodLabel: switch (periodType) {
        'days' => 'Hari',
        'specific' => 'Tanggal',
        _ => 'Periode',
      },
      time: requiredString('operatingHours'),
      timeLabel: 'Jam',
      finePrint: optionalString('terms').isEmpty
          ? 'Berlaku langsung di kios'
          : optionalString('terms'),
      category: optionalString('category', 'Promo'),
      ongoing: status == 'Sedang Berlangsung' || status == 'Hampir Habis',
      weekend: status == 'Setiap Akhir Pekan',
    );
  }
}

class PromoApiException implements Exception {
  const PromoApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
