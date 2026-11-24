import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/features/market_reviews/domain/entities/market_review.dart';
import 'package:frontend_flutter/features/market_reviews/presentation/pages/write_market_review_screen.dart';
import 'package:frontend_flutter/features/market_reviews/domain/usecases/submit_market_review.dart';
import 'package:frontend_flutter/features/market_reviews/domain/repositories/market_reviews_repository.dart';
import 'package:image_picker/image_picker.dart';

class _MockMarketReviewsRepository implements MarketReviewsRepository {
  int submitCalls = 0;
  String? submittedName;
  String? submittedText;

  @override
  Future<MarketReviewStatistics> fetchStatistics() => throw UnimplementedError();

  @override
  Future<MarketReviewPage> fetchReviews({
    String filter = 'all',
    String search = '',
    int page = 1,
    int limit = 10,
  }) => throw UnimplementedError();

  @override
  Future<dynamic> submitReview({
    required String name,
    required String date,
    required String text,
    required int rating,
    List<String> photos = const [],
  }) async {
    submitCalls++;
    submittedName = name;
    submittedText = text;
    return [];
  }

  @override
  Future<String> uploadPhoto(XFile photo) async => 'https://example.com/photo.jpg';
}

void main() {
  late _MockMarketReviewsRepository repository;
  late SubmitMarketReview submitReview;

  setUp(() {
    repository = _MockMarketReviewsRepository();
    submitReview = SubmitMarketReview(repository);
  });

  Widget createWidget() {
    return MaterialApp(
      home: WriteMarketReviewScreen(submitReview: submitReview),
    );
  }

  void configureScreen(WidgetTester tester) {
    tester.view.physicalSize = const Size(402, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  testWidgets('validasi nama pengunjung: ulasan tidak boleh disimpan jika nama kosong', (tester) async {
    configureScreen(tester);
    await tester.pumpWidget(createWidget());
    await tester.pumpAndSettle();

    // Isi cerita pengalaman tapi biarkan nama kosong
    final storyInput = find.widgetWithText(TextField, 'Bagikan pengalaman kamu tentang pasar ini...');
    await tester.enterText(storyInput, 'Pasar sangat bersih dan nyaman.');
    await tester.pumpAndSettle();

    // Klik tombol Kirim Ulasan Pasar
    final submitButton = find.text('Kirim Ulasan Pasar');
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    // Pastikan muncul pesan error nama dan API tidak dipanggil
    expect(find.text('Nama pengunjung wajib diisi.'), findsWidgets);
    expect(repository.submitCalls, equals(0));
  });

  testWidgets('validasi aspek penilaian: ulasan tidak boleh disimpan jika tidak ada aspek yang dipilih', (tester) async {
    configureScreen(tester);
    await tester.pumpWidget(createWidget());
    await tester.pumpAndSettle();

    // Isi nama dan cerita pengalaman
    final nameInput = find.widgetWithText(TextField, 'Masukkan Nama');
    await tester.enterText(nameInput, 'Budi Santoso');
    final storyInput = find.widgetWithText(TextField, 'Bagikan pengalaman kamu tentang pasar ini...');
    await tester.enterText(storyInput, 'Pasar sangat bersih dan nyaman.');
    await tester.pumpAndSettle();

    // Deselect semua 4 aspek
    await tester.tap(find.text('Kebersihan'));
    await tester.tap(find.text('Keramahan'));
    await tester.tap(find.text('Parkir Tertata'));
    await tester.tap(find.text('Kelengkapan\nKomoditas'));
    await tester.pumpAndSettle();

    // Klik tombol Kirim Ulasan Pasar
    final submitButton = find.text('Kirim Ulasan Pasar');
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    // Pastikan muncul pesan error aspek dan API tidak dipanggil
    expect(find.text('Silakan pilih minimal satu aspek penilaian.'), findsWidgets);
    expect(repository.submitCalls, equals(0));
  });

  testWidgets('validasi cerita pengalaman: ulasan tidak boleh disimpan jika cerita kosong atau hanya spasi', (tester) async {
    configureScreen(tester);
    await tester.pumpWidget(createWidget());
    await tester.pumpAndSettle();

    // Isi nama tapi biarkan cerita hanya spasi
    final nameInput = find.widgetWithText(TextField, 'Masukkan Nama');
    await tester.enterText(nameInput, 'Budi Santoso');
    final storyInput = find.widgetWithText(TextField, 'Bagikan pengalaman kamu tentang pasar ini...');
    await tester.enterText(storyInput, '     ');
    await tester.pumpAndSettle();

    // Klik tombol Kirim Ulasan Pasar
    final submitButton = find.text('Kirim Ulasan Pasar');
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    // Pastikan muncul pesan error cerita dan API tidak dipanggil
    expect(find.text('Ceritakan pengalaman Anda terlebih dahulu.'), findsWidgets);
    expect(repository.submitCalls, equals(0));
  });

  testWidgets('semua kolom wajib terisi: ulasan berhasil disimpan', (tester) async {
    configureScreen(tester);
    await tester.pumpWidget(createWidget());
    await tester.pumpAndSettle();

    // Isi nama dan cerita
    final nameInput = find.widgetWithText(TextField, 'Masukkan Nama');
    await tester.enterText(nameInput, 'Siti Rahma');
    final storyInput = find.widgetWithText(TextField, 'Bagikan pengalaman kamu tentang pasar ini...');
    await tester.enterText(storyInput, 'Pasar sangat bersih, tertata rapi dan pedagangnya ramah.');
    await tester.pumpAndSettle();

    // Klik tombol Kirim Ulasan Pasar
    final submitButton = find.text('Kirim Ulasan Pasar');
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    // Verifikasi API berhasil dipanggil
    expect(repository.submitCalls, equals(1));
    expect(repository.submittedName, equals('Siti Rahma'));
    expect(repository.submittedText, equals('Pasar sangat bersih, tertata rapi dan pedagangnya ramah.'));
  });
}
