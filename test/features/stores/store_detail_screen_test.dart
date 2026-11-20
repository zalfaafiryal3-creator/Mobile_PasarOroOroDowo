import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/app/dependencies.dart';
import 'package:frontend_flutter/app/routes.dart';
import 'package:frontend_flutter/features/stores/data/datasources/local/store_catalog.dart';
import 'package:frontend_flutter/features/stores/presentation/pages/store_detail_screen.dart';

import 'store_api_test_helper.dart';

final _dependencies = AppDependencies.create();

StoreDetailScreen _storeDetailScreen({
  String storeId = 'lumpur-kentang-27',
  String? expectedStoreName,
}) => StoreDetailScreen(
  getStore: _dependencies.getStore,
  storeId: storeId,
  expectedStoreName: expectedStoreName,
);

void main() {
  setUp(
    () => installStoreApiMock(
      transform: (store) => {
        ...store,
        'openTime': null,
        'closeTime': null,
        'phone': '',
        'description': '',
        'rating': 0,
        'productCount': 0,
      },
    ),
  );
  tearDown(clearStoreApiMock);

  testWidgets(
    'stores without existing details show their card photo and reviews',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: _storeDetailScreen(storeId: 'oma-panda')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Oma Panda'), findsNWidgets(2));
      expect(find.text('Tentang Kios Kami'), findsOneWidget);
      expect(find.text('Belum ditentukan'), findsOneWidget);
      expect(find.text('Nomor telepon belum tersedia'), findsOneWidget);
      expect(find.text('Deskripsi toko belum tersedia.'), findsOneWidget);
      expect(find.text('Produk belum tersedia.'), findsOneWidget);
      expect(find.text('4.9'), findsNothing);
      expect(find.text('Ulasan Toko & Pembeli'), findsOneWidget);
      expect(find.text('+ Tulis Ulasan'), findsOneWidget);
      expect(find.text('Katalog Produk Kios'), findsNothing);
      expect(find.text('Foto Toko'), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Image &&
              widget.image is AssetImage &&
              (widget.image as AssetImage).assetName ==
                  'assets/makanan/Oma Panda.jpeg',
        ),
        findsNWidgets(5),
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('review link opens the review screen for a local store', (
    tester,
  ) async {
    installStoreApiMock(backendStores: []);
    await tester.pumpWidget(
      MaterialApp(
        home: _storeDetailScreen(
          storeId: 'oma-panda',
          expectedStoreName: 'Oma Panda',
        ),
        onGenerateRoute: (settings) =>
            generateAppRoute(settings, _dependencies),
      ),
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Lihat Semua Ulasan'));
    await tester.tap(find.text('Lihat Semua Ulasan'));
    await tester.pumpAndSettle();

    expect(find.text('Review Toko'), findsOneWidget);
    expect(
      find.textContaining('Admin perlu mendaftarkan atau menyinkronkan toko'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('write-review link responds for a local store', (tester) async {
    installStoreApiMock(backendStores: []);
    await tester.pumpWidget(
      MaterialApp(
        home: _storeDetailScreen(
          storeId: 'oma-panda',
          expectedStoreName: 'Oma Panda',
        ),
        onGenerateRoute: (settings) =>
            generateAppRoute(settings, _dependencies),
      ),
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('+ Tulis Ulasan'));
    await tester.tap(find.text('+ Tulis Ulasan'));
    await tester.pumpAndSettle();

    expect(find.text('Tulis Ulasan Toko'), findsOneWidget);
    expect(
      find.textContaining('Admin perlu mendaftarkan atau menyinkronkan toko'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Backend-only store uses placeholders instead of empty assets', (
    tester,
  ) async {
    installStoreApiMock(
      backendStores: [
        StoreData(
          id: 'toko-baru-admin',
          name: 'Toko Baru Admin',
          category: 'Makanan',
          displayCategory: '',
          badge: '',
          rating: '',
          products: '0 Produk',
          image: '',
          status: 'buka',
          isLocalFallback: false,
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: _storeDetailScreen(
          storeId: 'toko-baru-admin',
          expectedStoreName: 'Toko Baru Admin',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Toko Baru Admin'), findsWidgets);
    expect(find.byIcon(Icons.store), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
