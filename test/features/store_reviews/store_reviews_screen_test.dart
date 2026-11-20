import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/features/store_reviews/domain/entities/store_review.dart';
import 'package:frontend_flutter/features/store_reviews/domain/repositories/store_reviews_repository.dart';
import 'package:frontend_flutter/features/store_reviews/domain/usecases/get_store_review_statistics.dart';
import 'package:frontend_flutter/features/store_reviews/domain/usecases/get_store_reviews.dart';
import 'package:frontend_flutter/features/store_reviews/presentation/pages/store_reviews_screen.dart';

void main() {
  testWidgets('local-only store explains reviews need backend registration', (
    tester,
  ) async {
    final repository = _UnusedStoreReviewsRepository();

    await tester.pumpWidget(
      MaterialApp(
        home: StoreReviewsScreen(
          storeId: 'toko-pojok-bedak-1',
          storeName: 'Toko Pojok Bedak 1',
          getStatistics: GetStoreReviewStatistics(repository),
          getReviews: GetStoreReviews(repository),
          isLocalFallback: true,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Admin perlu mendaftarkan atau menyinkronkan toko'),
      findsOneWidget,
    );
    expect(find.byType(TextField), findsNothing);
    expect(repository.wasCalled, isFalse);
    expect(tester.takeException(), isNull);
  });
}

class _UnusedStoreReviewsRepository implements StoreReviewsRepository {
  bool wasCalled = false;

  @override
  Future<StoreReviewStatistics> fetchStatistics(String storeId) async {
    wasCalled = true;
    throw StateError('Local-only stores do not have backend reviews.');
  }

  @override
  Future<StoreReviewPage> fetchReviews(
    String storeId, {
    required String filter,
    required String search,
    required int page,
    required int limit,
  }) async {
    wasCalled = true;
    throw StateError('Local-only stores do not have backend reviews.');
  }

  @override
  Future<List<StoreReview>> fetchFormReviews() async {
    wasCalled = true;
    throw StateError('Local-only stores do not have backend reviews.');
  }

  @override
  Future<List<StoreReview>> submitReview({
    required String name,
    required String text,
    required int rating,
    String? storeId,
  }) async {
    wasCalled = true;
    throw StateError('Local-only stores do not have backend reviews.');
  }
}
