import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/data/recommendations_api.dart';
import 'package:frontend_flutter/screens/recommendations/recommendations_screen.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  tearDown(() {
    RecommendationsApi.clientForTesting = null;
  });

  testWidgets('menampilkan toko dan produk dari API serta meminta sorting', (
    tester,
  ) async {
    final requestedSorts = <String?>[];
    RecommendationsApi.clientForTesting = MockClient((request) async {
      if (request.url.path == '/api/recommendations/stores') {
        return http.Response(
          jsonEncode({
            'success': true,
            'message': 'ok',
            'data': [
              _store(5, 'Bakso Goreng Bagoplek'),
              _store(1, 'Lumpur Kentang 27'),
              _store(7, 'Sego Liwet Bakar Kemangi'),
              _store(3, 'Klepon-ku'),
            ],
          }),
          200,
        );
      }
      if (request.url.path == '/api/recommendations/featured-products') {
        requestedSorts.add(request.url.queryParameters['sort']);
        return http.Response(
          jsonEncode({
            'success': true,
            'message': 'ok',
            'data': {
              'products': [_product()],
            },
          }),
          200,
        );
      }
      return http.Response('{}', 404);
    });

    await tester.pumpWidget(const MaterialApp(home: RecommendationsScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Bakso Goreng Bagoplek'), findsOneWidget);
    expect(find.text('Pangsit Mie Arema'), findsNothing);
    expect(requestedSorts, ['best_selling']);

    await tester.drag(find.byType(ListView).last, const Offset(-250, 0));
    await tester.pumpAndSettle();
    expect(find.text('Lumpur Kentang 27'), findsOneWidget);

    await tester.drag(find.byType(ListView).last, const Offset(-250, 0));
    await tester.pumpAndSettle();
    expect(find.text('Sego Liwet Bakar Kemangi'), findsOneWidget);

    await tester.drag(find.byType(ListView).last, const Offset(-250, 0));
    await tester.pumpAndSettle();
    expect(find.text('Klepon-ku'), findsWidgets);

    final pageScrollable = find.byType(Scrollable).first;
    await tester.scrollUntilVisible(
      find.text('Produk dari Database'),
      400,
      scrollable: pageScrollable,
    );
    expect(find.text('Produk dari Database'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Produk Pilihan'),
      300,
      scrollable: pageScrollable,
    );
    await tester.tap(find.text('Terlaris'));
    await tester.pumpAndSettle();
    expect(requestedSorts, ['best_selling', 'highest_rating']);
  });
}

Map<String, Object?> _store(int id, String name) => {
  'id': id,
  'slug': 'store-$id',
  'name': name,
  'category': 'Makanan',
  'location': 'Blok A',
  'status': 'buka',
  'rating': 4.5,
  'photoUrl': null,
};

Map<String, Object?> _product() => {
  'id': 42,
  'name': 'Produk dari Database',
  'photoUrl': null,
  'storeId': 5,
  'storeName': 'Bakso Goreng Bagoplek',
  'description': 'Deskripsi database',
  'price': 12000,
  'rating': null,
  'storeRating': 4.5,
  'isAvailable': true,
};
