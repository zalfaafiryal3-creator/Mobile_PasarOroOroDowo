import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/features/promotions/data/datasources/promo_remote_data_source.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('maps active admin promotion fields for the mobile card', () async {
    final client = MockClient((request) async {
      expect(request.url.path, '/api/promotions');
      return http.Response('''
        [{
          "id": 8,
          "title": "Diskon Sayur",
          "store": "Toko Sayur",
          "owner": "Pemilik",
          "category": "Zona Sayur & Buah",
          "description": "Potongan harga sayur segar.",
          "bannerImage": "https://example.test/promo.jpg",
          "status": "Akan Datang",
          "periodType": "specific",
          "periodDisplay": "24 Oktober 2026",
          "operatingHours": "06.00 - 17.00 WIB",
          "terms": "Berlaku di kios.",
          "code": "SAYUR10",
          "quota": "0 / 50",
          "discountType": "Diskon Tunai",
          "createdAt": "2026-10-01T00:00:00.000Z"
        }]
        ''', 200);
    });

    final promos = await PromoRemoteDataSource(client: client)
        .fetchPromotions();
    expect(promos, hasLength(1));
    expect(promos.single.title, 'Diskon Sayur');
    expect(promos.single.note, 'Toko Sayur');
    expect(promos.single.periodLabel, 'Tanggal');
    expect(promos.single.image, 'https://example.test/promo.jpg');
    expect(promos.single.ongoing, isFalse);
  });

  test(
    'reports invalid server payloads instead of using malformed promos',
    () async {
      final client = MockClient((_) async => http.Response('{}', 200));

      await expectLater(
        PromoRemoteDataSource(client: client).fetchPromotions(),
        throwsA(isA<PromoApiException>()),
      );
    },
  );
}
