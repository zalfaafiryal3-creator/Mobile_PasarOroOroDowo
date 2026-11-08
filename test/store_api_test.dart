import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/data/market_data.dart';
import 'package:frontend_flutter/data/store_api.dart';

import 'store_api_test_helper.dart';

void main() {
  tearDown(clearStoreApiMock);

  test(
    'memetakan toko Backend dan jam yang belum diketahui sebagai null',
    () async {
      installStoreApiMock(
        transform: (store) => {
          ...store,
          'openTime': null,
          'closeTime': null,
          'description': '',
          'phone': '',
        },
      );

      final store = await StoreApi.fetchStore('oma-panda');

      expect(store.openTime, isNull);
      expect(store.closeTime, isNull);
      expect(store.description, isEmpty);
      expect(store.phone, isEmpty);
      expect(store.image, 'makanan/Oma Panda.jpeg');
    },
  );

  test('konflik nama tidak mengganti data katalog Mobile', () async {
    installStoreApiMock(transform: (store) => {...store, 'name': 'Dicuri'});

    final store = await StoreApi.fetchStore('lumpur-kentang-27');

    expect(store.name, 'Lumpur Kentang 27');
    expect(store.image, '4ef0e.png');
    expect(store.status, isEmpty);
    expect(store.openTime, isNull);
    expect(store.isLocalFallback, isTrue);
  });

  test(
    'daftar memakai toko publik Backend tanpa duplikasi atau toko pending',
    () async {
      final newStore = _backendOnlyStore(status: 'tutup');
      installStoreApiMock(
        backendStores: [
          marketStores.first,
          marketStores.first,
          marketStores[1],
          newStore,
        ],
        transform: (store) => {
          ...store,
          if (store['slug'] == marketStores[1].id)
            'status': 'menunggu_verifikasi',
        },
      );

      final stores = await StoreApi.fetchStores();
      final storeIds = stores.map((store) => store.id).toSet();

      expect(stores, hasLength(marketStores.length));
      expect(storeIds, hasLength(stores.length));
      expect(stores.first.isLocalFallback, isFalse);
      expect(stores.first.image, marketStores.first.image);
      expect(storeIds, contains(marketStores.last.id));
      expect(storeIds, isNot(contains(marketStores[1].id)));
      final backendOnly = stores.singleWhere(
        (store) => store.id == newStore.id,
      );
      expect(backendOnly.status, 'tutup');
      expect(backendOnly.isLocalFallback, isFalse);
      expect(
        stores.any((store) => store.status == 'menunggu_verifikasi'),
        isFalse,
      );
    },
  );

  test(
    'nama berbeda pada slug yang sama tidak meminjam metadata lokal',
    () async {
      installStoreApiMock(
        backendStores: [
          _backendOnlyStore(id: 'lumpur-kentang-27', name: 'Toko Backend'),
        ],
      );

      final stores = await StoreApi.fetchStores();
      final store = stores.singleWhere(
        (item) => item.id == 'lumpur-kentang-27',
      );

      expect(stores, hasLength(marketStores.length));
      expect(store.name, 'Lumpur Kentang 27');
      expect(store.image, marketStores.first.image);
      expect(store.isLocalFallback, isTrue);
      expect(stores.any((item) => item.name == 'Toko Backend'), isFalse);
    },
  );

  test(
    'detail toko lokal tetap tersedia ketika Backend mengembalikan 404',
    () async {
      final messages = <String>[];
      final originalDebugPrint = debugPrint;
      debugPrint = (message, {wrapWidth}) {
        if (message != null) messages.add(message);
      };
      try {
        installStoreApiMock(
          backendStores: marketStores
              .where((store) => store.id != 'lumpur-kentang-27')
              .toList(),
        );

        final store = await StoreApi.fetchStore('lumpur-kentang-27');

        expect(store.name, 'Lumpur Kentang 27');
        expect(store.isLocalFallback, isTrue);
        expect(store.status, isEmpty);
        expect(store.openTime, isNull);
        expect(store.closeTime, isNull);
        expect(messages, isEmpty);
      } finally {
        debugPrint = originalDebugPrint;
      }
    },
  );
}

StoreData _backendOnlyStore({
  String id = 'toko-baru-admin',
  String name = 'Toko Baru Admin',
  String status = 'buka',
}) => StoreData(
  id: id,
  name: name,
  category: 'Makanan',
  displayCategory: '',
  badge: '',
  rating: '',
  products: '0 Produk',
  image: '',
  status: status,
  isLocalFallback: false,
);
