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

  test(
    'duplikasi FresGreen Organic digabung ke Fresh Green dan tidak muncul dua kali',
    () async {
      final fresgreenBackend = _backendOnlyStore(
        id: 'fresgreen-organic',
        name: 'FresGreen Organic',
        status: 'buka',
        image: '', // di database tidak punya banner/logo
      );

      installStoreApiMock(
        backendStores: [
          ...marketStores.where((s) => s.id != 'fresh-green'),
          fresgreenBackend,
        ],
      );

      final stores = await StoreApi.fetchStores();

      // Fresh Green tetap ada dengan gambar valid dari katalog dan status buka dari backend
      final freshGreen = stores.where((s) => s.id == 'fresh-green').toList();
      expect(freshGreen, hasLength(1));
      expect(freshGreen.first.name, 'Fresh Green');
      expect(freshGreen.first.category, 'Makanan');
      expect(freshGreen.first.image, 'makanan/makanan _ fresh green.jpeg');
      expect(freshGreen.first.status, 'buka');

      // FresGreen Organic tidak muncul sebagai toko kedua
      expect(stores.any((s) => s.id == 'fresgreen-organic'), isFalse);
      expect(stores.any((s) => s.name == 'FresGreen Organic'), isFalse);
    },
  );

  test(
    'toko tanpa gambar disembunyikan dari daftar toko mobile',
    () async {
      final barokah = _backendOnlyStore(
        id: 'toko-sembako-barokah',
        name: 'Toko Sembako Barokah',
        status: 'buka',
        image: '',
      );
      final ceria = _backendOnlyStore(
        id: 'kios-mainan-baju',
        name: 'Kios Mainan & Baju Ceria',
        status: 'buka',
        image: '',
      );
      final ujiAdmin = _backendOnlyStore(
        id: 'toko-uji-persetujuan-admin',
        name: 'Toko Uji Persetujuan Admin Revisi',
        status: 'buka',
        image: '',
      );

      installStoreApiMock(
        backendStores: [
          ...marketStores,
          barokah,
          ceria,
          ujiAdmin,
        ],
      );

      final stores = await StoreApi.fetchStores();
      final storeIds = stores.map((s) => s.id).toSet();

      expect(storeIds.contains('toko-sembako-barokah'), isFalse);
      expect(storeIds.contains('kios-mainan-baju'), isFalse);
      expect(storeIds.contains('toko-uji-persetujuan-admin'), isFalse);

      // Toko lain dengan gambar tetap lengkap
      expect(stores.length, marketStores.length);
      for (final store in stores) {
        expect(StoreApi.hasValidImage(store), isTrue);
      }
    },
  );

  test(
    'toko backend yang kemudian memiliki gambar otomatis muncul di mobile',
    () async {
      final barokahDenganFoto = _backendOnlyStore(
        id: 'toko-sembako-barokah',
        name: 'Toko Sembako Barokah',
        status: 'buka',
        image: 'https://example.com/uploads/barokah.jpg',
      );

      installStoreApiMock(
        backendStores: [
          ...marketStores,
          barokahDenganFoto,
        ],
      );

      final stores = await StoreApi.fetchStores();
      final barokah = stores.where((s) => s.id == 'toko-sembako-barokah').toList();

      expect(barokah, hasLength(1));
      expect(barokah.first.name, 'Toko Sembako Barokah');
      expect(barokah.first.image, 'https://example.com/uploads/barokah.jpg');
      expect(barokah.first.status, 'buka');
    },
  );

  test(
    'fetchStore fresh-green mengambil data status dan jam backend dari fresgreen-organic',
    () async {
      final fresgreenBackend = _backendOnlyStore(
        id: 'fresgreen-organic',
        name: 'FresGreen Organic',
        status: 'buka',
        image: '',
      );

      installStoreApiMock(backendStores: [fresgreenBackend]);

      final store = await StoreApi.fetchStore('fresh-green');

      expect(store.id, 'fresh-green');
      expect(store.name, 'Fresh Green');
      expect(store.category, 'Makanan');
      expect(store.image, 'makanan/makanan _ fresh green.jpeg');
      expect(store.status, 'buka');
      expect(store.openTime, '06:00');
      expect(store.closeTime, '17:00');
    },
  );
}

StoreData _backendOnlyStore({
  String id = 'toko-baru-admin',
  String name = 'Toko Baru Admin',
  String status = 'buka',
  String image = 'https://example.com/banner.jpg',
}) => StoreData(
  id: id,
  name: name,
  category: 'Makanan',
  displayCategory: '',
  badge: '',
  rating: '',
  products: '0 Produk',
  image: image,
  status: status,
  isLocalFallback: false,
);
