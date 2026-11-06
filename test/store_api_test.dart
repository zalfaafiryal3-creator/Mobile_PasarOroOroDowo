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

  test('menggabungkan data Backend subset ke katalog 49 toko Mobile', () async {
    final backendStores = marketStores.take(11).toList();
    installStoreApiMock(backendStores: backendStores);

    final stores = await StoreApi.fetchStores();

    expect(stores, hasLength(49));
    expect(stores.map((store) => store.id).toSet(), hasLength(49));
    expect(stores.first.isLocalFallback, isFalse);

    final mobileOnlyStore = stores.singleWhere(
      (store) => store.id == marketStores.last.id,
    );
    expect(mobileOnlyStore.isLocalFallback, isTrue);
    expect(mobileOnlyStore.status, isEmpty);
    expect(mobileOnlyStore.openTime, isNull);
    expect(mobileOnlyStore.closeTime, isNull);
  });

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
