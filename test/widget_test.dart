import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:frontend_flutter/data/review_api.dart';
import 'package:frontend_flutter/main.dart';
import 'package:frontend_flutter/screens/discovery_screens.dart';
import 'package:frontend_flutter/screens/review_screens.dart'
    show MarketReviewsScreen;
import 'package:frontend_flutter/screens/write_market_review/write_market_review_screen.dart'
    as market_review;

import 'store_api_test_helper.dart';

void main() {
  setUp(() {
    installStoreApiMock();
    _installMarketReviewMock(_defaultMarketReviews);
  });
  tearDown(() {
    clearStoreApiMock();
    MarketReviewApi.clientForTesting = null;
  });

  test('market review submission uses the market reviews endpoint', () async {
    Uri? submittedUri;
    Map<String, dynamic>? submittedBody;
    MarketReviewApi.clientForTesting = MockClient((request) async {
      submittedUri = request.url;
      submittedBody = jsonDecode(request.body) as Map<String, dynamic>;
      return http.Response(
        jsonEncode({'success': true, 'data': []}),
        201,
        headers: const {'content-type': 'application/json'},
      );
    });

    await MarketReviewApi.submitReview(
      name: 'Pengunjung',
      date: 'Hari ini',
      text: 'Pasar bersih dan nyaman.',
      rating: 5,
    );

    expect(submittedUri!.path, endsWith('/api/market-reviews'));
    expect(submittedBody, {
      'name': 'Pengunjung',
      'date': 'Hari ini',
      'text': 'Pasar bersih dan nyaman.',
      'rating': 5,
    });
  });

  for (final totalReviews in [6, 10, 11]) {
    testWidgets(
      'market reviews load 10 at a time for $totalReviews reviews',
      (tester) async {
        final reviews = List.generate(
          totalReviews,
          (index) => _reviewJson(index + 1, 'Reviewer ${index + 1}'),
        );
        var requestedLimit = 0;
        var requestedPages = <int>[];
        MarketReviewApi.clientForTesting = MockClient((request) async {
          if (request.url.path.endsWith('/page')) {
            requestedLimit = int.parse(request.url.queryParameters['limit']!);
            requestedPages.add(
              int.parse(request.url.queryParameters['page']!),
            );
          }
          return _marketReviewResponse(
            request,
            reviews,
            duplicateFirstOnSecondPage: totalReviews == 11,
          );
        });

        await tester.pumpWidget(
          const MaterialApp(home: MarketReviewsScreen()),
        );
        await tester.pumpAndSettle();
        await tester.dragUntilVisible(
          find.text('Reviewer 1'),
          find.byType(ListView).first,
          const Offset(0, -300),
        );
        await tester.pumpAndSettle();

        expect(requestedLimit, 10);
        expect(requestedPages, [1]);
        expect(find.text('Reviewer 1'), findsOneWidget);

        if (totalReviews > 10) {
          await tester.dragUntilVisible(
            find.text('Muat Ulasan Lainnya'),
            find.byType(ListView).first,
            const Offset(0, -300),
          );
          await tester.drag(
            find.byType(ListView).first,
            const Offset(0, -250),
          );
          await tester.pumpAndSettle();
          expect(find.text('Muat Ulasan Lainnya'), findsOneWidget);
          await tester.tap(find.text('Muat Ulasan Lainnya'));
          await tester.pumpAndSettle();

          expect(requestedPages, [1, 2]);
          await tester.dragUntilVisible(
            find.text('Reviewer 1'),
            find.byType(ListView).first,
            const Offset(0, 400),
          );
          await tester.pumpAndSettle();
          expect(find.text('Reviewer 1'), findsOneWidget);
          await tester.dragUntilVisible(
            find.text('Reviewer 11'),
            find.byType(ListView).first,
            const Offset(0, -300),
          );
          expect(find.text('Reviewer 11'), findsOneWidget);
          expect(find.text('Muat Ulasan Lainnya'), findsNothing);
        } else {
          expect(find.text('Muat Ulasan Lainnya'), findsNothing);
        }
      },
    );
  }

  testWidgets('Splash proceeds to landing and home', (tester) async {
    tester.view.physicalSize = const Size(389, 841);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const PasarOroOroDowoApp());
    await tester.pump(const Duration(milliseconds: 1801));
    await tester.pumpAndSettle();

    expect(find.text('SELAMAT DATANG!'), findsOneWidget);
    expect(find.text('Sejarah Singkat'), findsOneWidget);
    expect(find.text('Jam Operasional'), findsOneWidget);
    await tester.tap(find.text('Selanjutnya'));
    await tester.pumpAndSettle();
    expect(find.text('Pilih\nToko Favoritmu'), findsOneWidget);
  });

  testWidgets('Home search filters the visible store list', (tester) async {
    await tester.pumpWidget(const PasarOroOroDowoApp());
    await tester.pump(const Duration(milliseconds: 1801));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Selanjutnya'));
    await tester.pumpAndSettle();

    await tester.dragUntilVisible(
      find.text('Rencanakan Kunjunganmu'),
      find.byType(CustomScrollView).first,
      const Offset(0, -500),
    );
    expect(find.text('Rencanakan Kunjunganmu'), findsOneWidget);
    expect(find.text('Lihat Info Kunjungan'), findsOneWidget);
    await tester.drag(
      find.byType(CustomScrollView).first,
      const Offset(0, 3000),
    );
    await tester.pumpAndSettle();

    await tester.dragUntilVisible(
      find.text('Wiwit Sayur'),
      find.byType(CustomScrollView).first,
      const Offset(0, -450),
    );
    expect(find.text('Kategori Belanja'), findsOneWidget);
    await tester.drag(
      find.byType(CustomScrollView).first,
      const Offset(0, 1600),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'klepon');
    await tester.pump();
    await tester.drag(
      find.byType(CustomScrollView).first,
      const Offset(0, -900),
    );
    await tester.pumpAndSettle();

    expect(find.text('Klepon-ku'), findsOneWidget);
    expect(find.text('Lumpur Kentang 27'), findsNothing);
  });

  testWidgets('market review route resolves to the write-review screen', (
    tester,
  ) async {
    await tester.pumpWidget(const PasarOroOroDowoApp());
    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    final route = app.onGenerateRoute!(
      const RouteSettings(name: '/tulis-ulasan-pasar'),
    );

    expect(route, isA<MaterialPageRoute<bool>>());
    final context = tester.element(find.byType(MaterialApp));
    expect(
      (route! as MaterialPageRoute<bool>).builder(context),
      isA<market_review.WriteMarketReviewScreen>(),
    );
  });

  testWidgets('Bottom navigation opens promo and market reviews', (
    tester,
  ) async {
    await tester.pumpWidget(const PasarOroOroDowoApp());
    await tester.pump(const Duration(milliseconds: 1801));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Selanjutnya'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Promo').last);
    await tester.pumpAndSettle();
    expect(find.text('Info Promo & Event'), findsOneWidget);
    expect(find.text('Diskon Tahu Bakso'), findsOneWidget);
    expect(find.text('4 Program Aktif'), findsOneWidget);

    await tester.tap(find.text('Akan Datang'));
    await tester.pumpAndSettle();
    expect(find.text('Diskon Cake'), findsOneWidget);
    expect(find.text('Diskon Tahu Bakso'), findsNothing);

    await tester.tap(find.text('Review Pasar').last);
    await tester.pumpAndSettle();
    await tester.dragUntilVisible(
      find.text('Dengan Foto (1)'),
      find.byType(ListView).first,
      const Offset(0, -300),
    );
    await tester.pumpAndSettle();
    expect(find.text('Semua (6)'), findsOneWidget);
    expect(find.text('Dengan Foto (1)'), findsOneWidget);
    expect(find.text('Bintang 5 (4)'), findsOneWidget);
    expect(find.text('Bintang 4 (2)'), findsOneWidget);
    expect(find.text('Bintang 1-3 (0)'), findsOneWidget);
    await tester.tap(find.text('Dengan Foto (1)'));
    await tester.pumpAndSettle();
    await tester.dragUntilVisible(
      find.text('ZALFAA'),
      find.byType(ListView).first,
      const Offset(0, -300),
    );
    expect(find.text('ZALFAA'), findsOneWidget);
    expect(find.text('Rani'), findsNothing);

    await tester.dragUntilVisible(
      find.text('Membantu (0)'),
      find.byType(ListView).first,
      const Offset(0, -300),
    );
    await tester.tap(find.text('Membantu (0)'));
    await tester.pumpAndSettle();
    expect(find.text('Membantu (1)'), findsOneWidget);
  });

  testWidgets('Visit info screen displays complete market guide', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(389, 841);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const PasarOroOroDowoApp());
    await tester.pump(const Duration(milliseconds: 1801));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Selanjutnya'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Info\nKunjungan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Info\nKunjungan'));
    await tester.pumpAndSettle();

    expect(find.text('Info Kunjungan'), findsOneWidget);
    expect(find.text('Buka Sekarang'), findsOneWidget);
    expect(find.text('Cagar Budaya SNI'), findsOneWidget);
    expect(find.text('Jam Operasional'), findsOneWidget);

    await tester.dragUntilVisible(
      find.text('Hari Pasaran & Kepadatan'),
      find.byType(ListView).first,
      const Offset(0, -300),
    );
    expect(find.text('Hari Pasaran & Kepadatan'), findsOneWidget);

    await tester.dragUntilVisible(
      find.text('Buka di Google Maps'),
      find.byType(ListView).first,
      const Offset(0, -400),
    );
    expect(find.text('Akses & Pilihan Transportasi'), findsOneWidget);
    expect(find.text('Buka di Google Maps'), findsOneWidget);

    await tester.dragUntilVisible(
      find.text('Waktu Terbaik Berkunjung'),
      find.byType(ListView).first,
      const Offset(0, -400),
    );
    expect(find.text('Waktu Terbaik Berkunjung'), findsOneWidget);
    expect(find.text('Tips Ramah Lingkungan'), findsOneWidget);

    // Tap back button
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.byType(VisitInfoScreen), findsNothing);
  });

  testWidgets('Visit info layout fits small and large screens', (tester) async {
    for (final size in [
      const Size(320, 640),
      const Size(389, 841),
      const Size(768, 1024),
    ]) {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;

      await tester.pumpWidget(const MaterialApp(home: VisitInfoScreen()));
      await tester.pumpAndSettle();
      final finalSection = find.text('Waktu Terbaik Berkunjung');
      for (
        var attempt = 0;
        attempt < 10 && finalSection.evaluate().isEmpty;
        attempt++
      ) {
        await tester.drag(find.byType(ListView), const Offset(0, -500));
        await tester.pumpAndSettle();
      }
      expect(finalSection, findsOneWidget);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull, reason: 'Ukuran layar $size');
    }

    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  });
}

final _defaultMarketReviews = [
  _reviewJson(1, 'ZALFAA', rating: 5, photos: ['2312e.png']),
  _reviewJson(2, 'Rani', rating: 5),
  _reviewJson(3, 'Mifta', rating: 4),
  _reviewJson(4, 'Budi Santoso', rating: 5),
  _reviewJson(5, 'Siti Aminah', rating: 4),
  _reviewJson(6, 'Hendra Wijaya', rating: 5),
];

Map<String, dynamic> _reviewJson(
  int id,
  String name, {
  int rating = 5,
  List<String> photos = const [],
}) => {
  'id': id,
  'name': name,
  'date': 'Hari ini',
  'text': 'Ulasan $name',
  'rating': rating,
  'overallRating': rating,
  'photos': photos
      .asMap()
      .entries
      .map((entry) => {'id': entry.key + 1, 'url': entry.value})
      .toList(),
};

void _installMarketReviewMock(List<Map<String, dynamic>> reviews) {
  MarketReviewApi.clientForTesting = MockClient(
    (request) async => _marketReviewResponse(request, reviews),
  );
}

http.Response _marketReviewResponse(
  http.Request request,
  List<Map<String, dynamic>> reviews, {
  bool duplicateFirstOnSecondPage = false,
}
) {
  if (request.url.path.endsWith('/statistics')) {
    final visible = reviews;
    return http.Response(
      jsonEncode({
        'success': true,
        'data': {
          'total_reviews': visible.length,
          'with_photo': visible.where((review) => (review['photos'] as List).isNotEmpty).length,
          'star_5': visible.where((review) => review['overallRating'] == 5).length,
          'star_4': visible.where((review) => review['overallRating'] == 4).length,
          'star_1_3': visible.where((review) => (review['overallRating'] as int) <= 3).length,
        },
      }),
      200,
      headers: const {'content-type': 'application/json'},
    );
  }

  if (!request.url.path.endsWith('/page')) {
    return http.Response('Not found', 404);
  }

  final query = request.url.queryParameters;
  final filter = query['filter'] ?? 'all';
  final search = (query['search'] ?? '').toLowerCase();
  final filtered = reviews.where((review) {
    final rating = review['overallRating'] as int;
    final photos = review['photos'] as List;
    final matchesFilter = switch (filter) {
      'photo' => photos.isNotEmpty,
      '5' => rating == 5,
      '4' => rating == 4,
      '1-3' => rating >= 1 && rating <= 3,
      _ => true,
    };
    final matchesSearch =
        '${review['name']} ${review['text']}'.toLowerCase().contains(search);
    return matchesFilter && matchesSearch;
  }).toList();
  final page = int.parse(query['page'] ?? '1');
  final limit = int.parse(query['limit'] ?? '10');
  final start = (page - 1) * limit;
  final items = filtered.skip(start).take(limit).toList();
  if (duplicateFirstOnSecondPage && page == 2 && items.isNotEmpty) {
    items.insert(0, filtered.first);
  }

  return http.Response(
    jsonEncode({
      'success': true,
      'data': items,
      'total_count': filtered.length,
      'current_page_count': items.length,
      'page': page,
      'limit': limit,
      'filter': filter,
    }),
    200,
    headers: const {'content-type': 'application/json'},
  );
}
