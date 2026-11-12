import 'dart:convert';

import 'package:frontend_flutter/data/api_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/data/recommendations_api.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  tearDown(() {
    RecommendationsApi.clientForTesting = null;
  });

  test('memetakan toko sesuai urutan dan field API', () async {
    Uri? requestedUri;
    RecommendationsApi.clientForTesting = MockClient((request) async {
      requestedUri = request.url;
      return http.Response(
        jsonEncode({
          'success': true,
          'message': 'ok',
          'data': [
            _store(5, 'bakso-goreng-bagoplek', 'Bakso Goreng Bagoplek'),
            _store(1, 'lumpur-kentang-27', 'Lumpur Kentang 27'),
            _store(7, 'sego-liwet-kemangi', 'Sego Liwet Bakar Kemangi'),
            _store(3, 'klepon-ku', 'Klepon-ku'),
          ],
        }),
        200,
      );
    });

    final stores = await RecommendationsApi.fetchStores();

    expect(requestedUri!.path, '/api/recommendations/stores');
    expect(stores.map((store) => store.name), [
      'Bakso Goreng Bagoplek',
      'Lumpur Kentang 27',
      'Sego Liwet Bakar Kemangi',
      'Klepon-ku',
    ]);
    expect(stores.map((store) => store.id), [5, 1, 7, 3]);
    expect(stores.first.status, 'buka');
    expect(stores.first.photoUrl, 'https://example.test/store.jpg');
  });

  test(
    'mengambil produk dari endpoint terlaris dan menyaring yang tidak aktif',
    () async {
      Uri? requestedUri;
      RecommendationsApi.clientForTesting = MockClient((request) async {
        requestedUri = request.url;
        return http.Response(
          jsonEncode({
            'success': true,
            'message': 'ok',
            'data': {
              'sort': request.url.queryParameters['sort'],
              'products': [
                _product(35, isAvailable: true),
                _product(36, isAvailable: false),
              ],
            },
          }),
          200,
        );
      });

      final products = await RecommendationsApi.fetchFeaturedProducts();

      expect(requestedUri!.path, '/api/recommendations/featured-products');
      expect(requestedUri!.queryParameters['sort'], 'best_selling');
      expect(products, hasLength(1));
      expect(products.single.id, 35);
      expect(products.single.storeId, 33);
      expect(products.single.photoUrl, '${ApiConfig.baseUrl}/uploads/item.jpg');
    },
  );

  test('menampilkan pesan API saat toko rekomendasi belum lengkap', () async {
    RecommendationsApi.clientForTesting = MockClient((_) async {
      return http.Response(
        jsonEncode({
          'success': false,
          'message': 'Daftar toko rekomendasi belum lengkap di database.',
          'data': {
            'missingStores': ['Bakso Goreng Bagoplek'],
          },
        }),
        409,
      );
    });

    await expectLater(
      RecommendationsApi.fetchStores(),
      throwsA(
        isA<RecommendationsApiException>().having(
          (error) => error.message,
          'message',
          'Daftar toko rekomendasi belum lengkap di database.',
        ),
      ),
    );
  });
}

Map<String, Object?> _store(int id, String slug, String name) => {
  'id': id,
  'slug': slug,
  'name': name,
  'category': 'Makanan',
  'location': 'Blok A',
  'status': 'buka',
  'rating': 4.5,
  'photoUrl': 'https://example.test/store.jpg',
};

Map<String, Object?> _product(int id, {required bool isAvailable}) => {
  'id': id,
  'name': 'Produk database $id',
  'photoUrl': '/uploads/item.jpg',
  'storeId': 33,
  'storeName': 'Toko database',
  'description': 'Deskripsi database',
  'price': 5000,
  'rating': null,
  'storeRating': 4.5,
  'isAvailable': isAvailable,
};
