import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/screens/store_detail/store_detail_screen.dart';

void main() {
  testWidgets(
    'stores without existing details show their card photo and reviews',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: StoreDetailScreen(storeId: 'oma-panda')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Oma Panda'), findsNWidgets(2));
      expect(find.text('Tentang Kios Kami'), findsOneWidget);
      expect(find.text('06.00'), findsOneWidget);
      expect(find.text('Tutup 17.00'), findsOneWidget);
      expect(find.text('4.9'), findsNWidgets(2));
      expect(find.text('Hubungi Penjual'), findsOneWidget);
      expect(find.text('Ulasan'), findsOneWidget);
      expect(
        find.textContaining('Oma Panda menyediakan makanan dan camilan'),
        findsOneWidget,
      );
      expect(find.text('Ulasan Toko & Pembeli'), findsOneWidget);
      expect(find.text('Tulis Ulasan'), findsOneWidget);
      expect(find.text('Katalog Produk Kios'), findsNothing);
      expect(find.text('Suasana Kios & Etalase'), findsNothing);
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Image &&
              widget.image is AssetImage &&
              (widget.image as AssetImage).assetName ==
                  'assets/makanan/Oma Panda.jpeg',
        ),
        findsNWidgets(2),
      );
      expect(tester.takeException(), isNull);
    },
  );
}
