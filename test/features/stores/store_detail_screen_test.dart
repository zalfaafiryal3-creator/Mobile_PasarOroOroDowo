import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/app/dependencies.dart';
import 'package:frontend_flutter/app/routes.dart';
import 'package:frontend_flutter/features/stores/data/datasources/local/store_catalog.dart';
import 'package:frontend_flutter/features/stores/presentation/pages/store_detail_screen.dart';
import 'package:frontend_flutter/features/store_reviews/domain/entities/store_review.dart';
import 'package:frontend_flutter/features/store_reviews/domain/usecases/get_store_reviews.dart';

import 'store_api_test_helper.dart';

final _dependencies = AppDependencies.create();

class _FakeGetStoreReviews implements GetStoreReviews {
  const _FakeGetStoreReviews(this.reviews);
  final List<StoreReview> reviews;

  @override
  Future<StoreReviewPage> call(
    String storeId, {
    String filter = 'all',
    String search = '',
    int page = 1,
    int limit = 20,
  }) async {
    return StoreReviewPage(
      reviews: reviews,
      totalCount: reviews.length,
      currentPageCount: reviews.length,
      page: 1,
      limit: limit,
    );
  }
}

StoreDetailScreen _storeDetailScreen({
  String storeId = 'lumpur-kentang-27',
  String? expectedStoreName,
  GetStoreReviews? getStoreReviews,
}) => StoreDetailScreen(
  getStore: _dependencies.getStore,
  getStoreReviews: getStoreReviews,
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

  testWidgets(
    'review section expands and collapses all reviews inline without navigating',
    (tester) async {
      final reviews = [
        const StoreReview(
          id: 1,
          name: 'Budi Santoso',
          date: '24 Nov 2026',
          text: 'Lumpur kentangnya lembut dan manisnya pas!',
          rating: 5,
        ),
        const StoreReview(
          id: 2,
          name: 'Siti Aminah',
          date: '23 Nov 2026',
          text: 'Pelayanan cepat dan rasa sangat enak.',
          rating: 4,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: _storeDetailScreen(
            storeId: 'lumpur-kentang-27',
            getStoreReviews: _FakeGetStoreReviews(reviews),
          ),
          onGenerateRoute: (settings) =>
              generateAppRoute(settings, _dependencies),
        ),
      );
      await tester.pumpAndSettle();

      // First review is visible
      expect(find.text('Budi Santoso'), findsOneWidget);
      expect(
        find.text('Lumpur kentangnya lembut dan manisnya pas!'),
        findsOneWidget,
      );

      // Second review is initially hidden
      expect(find.text('Siti Aminah'), findsNothing);
      expect(
        find.text('Pelayanan cepat dan rasa sangat enak.'),
        findsNothing,
      );

      // Expand button is visible
      final expandButton = find.text('Lihat Semua Ulasan');
      expect(expandButton, findsOneWidget);

      // Tap expand button
      await tester.ensureVisible(expandButton);
      await tester.tap(expandButton);
      await tester.pumpAndSettle();

      // Both reviews are now visible
      expect(find.text('Budi Santoso'), findsOneWidget);
      expect(find.text('Siti Aminah'), findsOneWidget);
      expect(
        find.text('Pelayanan cepat dan rasa sangat enak.'),
        findsOneWidget,
      );

      // Button changed to Tutup Ulasan
      final collapseButton = find.text('Tutup Ulasan');
      expect(collapseButton, findsOneWidget);
      expect(find.text('Review Toko'), findsNothing);

      // Tap collapse button
      await tester.ensureVisible(collapseButton);
      await tester.tap(collapseButton);
      await tester.pumpAndSettle();

      // Second review is collapsed/hidden again
      expect(find.text('Budi Santoso'), findsOneWidget);
      expect(find.text('Siti Aminah'), findsNothing);
      expect(find.text('Lihat Semua Ulasan'), findsOneWidget);
      expect(find.text('Review Toko'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

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
