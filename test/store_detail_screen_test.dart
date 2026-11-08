import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/data/market_data.dart';
import 'package:frontend_flutter/screens/store_detail/store_detail_screen.dart';

import 'store_api_test_helper.dart';

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
        const MaterialApp(home: StoreDetailScreen(storeId: 'oma-panda')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Oma Panda'), findsNWidgets(2));
      expect(find.text('Tentang Kios Kami'), findsOneWidget);
      expect(find.text('Belum ditentukan'), findsOneWidget);
      expect(find.text('Nomor telepon belum tersedia'), findsOneWidget);
      expect(find.text('Deskripsi toko belum tersedia.'), findsOneWidget);
      expect(find.text('Produk belum tersedia.'), findsOneWidget);
      expect(find.text('4.9'), findsNWidgets(2));
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
      const MaterialApp(
        home: StoreDetailScreen(
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
