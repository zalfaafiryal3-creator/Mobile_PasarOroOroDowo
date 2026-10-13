import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/main.dart';

void main() {
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
      find.byType(ListView).first,
      const Offset(0, -500),
    );
    expect(find.text('Rencanakan Kunjunganmu'), findsOneWidget);
    expect(find.text('Lihat Info Kunjungan'), findsOneWidget);
    await tester.drag(find.byType(ListView).first, const Offset(0, 3000));
    await tester.pumpAndSettle();

    await tester.dragUntilVisible(
      find.text('Wiwit Sayur'),
      find.byType(ListView).first,
      const Offset(0, -450),
    );
    expect(find.text('Kategori Belanja'), findsOneWidget);
    await tester.drag(find.byType(ListView).first, const Offset(0, 1600));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'klepon');
    await tester.pump();
    await tester.drag(find.byType(ListView).first, const Offset(0, -900));
    await tester.pumpAndSettle();

    expect(find.text('Klepon-ku'), findsOneWidget);
    expect(find.text('Lumpur Kentang 27'), findsNothing);
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
      find.text('Membantu (34)'),
      find.byType(ListView).first,
      const Offset(0, -300),
    );
    await tester.tap(find.text('Membantu (34)'));
    await tester.pumpAndSettle();
    expect(find.text('Membantu (35)'), findsOneWidget);
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

    await tester.dragUntilVisible(
      find.text('Info\nKunjungan'),
      find.byType(ListView).first,
      const Offset(0, -200),
    );
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
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Pilih\nToko Favoritmu'), findsOneWidget);
  });
}
