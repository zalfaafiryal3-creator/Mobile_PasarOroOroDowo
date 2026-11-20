import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/features/stores/data/datasources/store_local_data_source.dart';
import 'package:frontend_flutter/features/stores/data/datasources/store_remote_data_source.dart';
import 'package:frontend_flutter/features/stores/data/repositories/store_repository_impl.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('backend edits replace matching local store catalog fields', () async {
    final client = MockClient((_) async {
      return http.Response(
        jsonEncode([
          {
            'slug': 'oma-panda',
            'name': 'Nama Toko Terbaru',
            'category': 'Buah',
            'zone': 'Zona B',
            'status': 'buka',
            'openTime': '07:00',
            'closeTime': '16:00',
            'owner': 'Pemilik Baru',
            'phone': '08123456789',
            'description': 'Deskripsi terbaru.',
            'bannerUrl': 'https://example.test/toko.jpg',
            'logoUrl': null,
            'rating': 4.5,
            'reviewCount': 3,
            'productCount': 0,
          },
        ]),
        200,
      );
    });
    final repository = StoreRepositoryImpl(
      remoteDataSource: StoreRemoteDataSource(client: client),
      localDataSource: const StoreLocalDataSource(),
    );

    final stores = await repository.fetchStores();
    final updatedStore = stores.singleWhere((store) => store.id == 'oma-panda');

    expect(updatedStore.name, 'Nama Toko Terbaru');
    expect(updatedStore.category, 'Buah');
    expect(updatedStore.zone, 'Zona B');
    expect(updatedStore.image, 'https://example.test/toko.jpg');
    expect(updatedStore.rating, '4.5');
    expect(updatedStore.reviewCount, 3);
    expect(updatedStore.productCount, 0);
  });
}
