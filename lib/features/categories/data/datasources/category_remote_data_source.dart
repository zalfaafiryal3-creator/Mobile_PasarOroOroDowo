import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/network/api_config.dart';
import '../../domain/entities/category.dart';

class CategoryApiException implements Exception {
  const CategoryApiException(this.message, {this.statusCode});
  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class CategoryRemoteDataSource {
  const CategoryRemoteDataSource({this.client});
  final http.Client? client;

  Future<List<StoreCategory>> fetchCategories() async {
    final requestClient = client ?? http.Client();
    final shouldCloseClient = client == null;
    try {
      final response = await requestClient
          .get(Uri.parse('${ApiConfig.baseUrl}/api/categories'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw CategoryApiException(
          'Kategori gagal dimuat dari server (HTTP ${response.statusCode}).',
          statusCode: response.statusCode,
        );
      }

      final Object? decoded;
      try {
        decoded = jsonDecode(response.body);
      } on FormatException {
        throw const CategoryApiException(
          'Format data kategori dari server tidak valid.',
        );
      }

      if (decoded is! List) {
        throw const CategoryApiException('Daftar kategori dari server tidak sesuai.');
      }

      return decoded
          .whereType<Map<String, dynamic>>()
          .map(StoreCategory.fromJson)
          .where((cat) => cat.name.isNotEmpty)
          .toList();
    } finally {
      if (shouldCloseClient) requestClient.close();
    }
  }
}
