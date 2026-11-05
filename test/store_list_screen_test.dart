import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/data/market_data.dart';
import 'package:frontend_flutter/screens/store_list/store_list_screen.dart';

Future<void> scrollUntilStoreVisible(WidgetTester tester, String name) async {
  await tester.dragUntilVisible(
    find.text(name),
    find.byType(CustomScrollView),
    const Offset(0, -500),
  );
  await tester.pumpAndSettle();
}

Future<void> scrollToTop(WidgetTester tester) async {
  await tester.drag(find.byType(CustomScrollView), const Offset(0, 3000));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Food cards show store names without category labels', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(0.8)),
        child: MaterialApp(home: StoreListScreen(initialCategory: 'Makanan')),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('17 Toko'), findsOneWidget);
    await scrollUntilStoreVisible(tester, 'Warung Lalapan Bu Win');
    expect(find.text('Warung Lalapan Bu Win'), findsOneWidget);
    expect(find.text('★ 4.8'), findsWidgets);
    expect(
      find.descendant(
        of: find.byType(SliverGrid).last,
        matching: find.text('Makanan'),
      ),
      findsNothing,
    );
  });

  testWidgets('Store grid builds cards as they scroll into view', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(0.8)),
        child: MaterialApp(home: StoreListScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Mama Hong Pulsa'), findsNothing);
    await tester.dragUntilVisible(
      find.text('Mama Hong Pulsa'),
      find.byType(CustomScrollView),
      const Offset(0, -500),
    );
    expect(find.text('Mama Hong Pulsa'), findsOneWidget);
  });

  test(
    'Makanan and Kuliner Legendaris stores use their supplied photos',
    () async {
      const foodImages = {
        'Bedak 16 Kue dan Snack': 'makanan/bedak 19 kue dan snack.png',
        'Fresh Green': 'makanan/makanan _ fresh green.jpeg',
        'Gorengan Bu Sulbiah': 'makanan/makanan _ gorengan bu sulbiah .jpeg',
        'Warung Lalapan Bu Win': 'makanan/warung lalapan mbak win.png',
        'Lumpur Labu': 'makanan/makanan _ lumpur labu .jpeg',
        'Pastel Premium': 'makanan/pastel premium.png',
        'Sego Liwet Bakar Kemangi': 'makanan/sego liwet bakar kemangi.png',
        'Soto Rawon Bu Ninik': 'makanan/makanan _ soto rawon bu ninik .jpeg',
        'Tahu Sukun Bu Suliani': 'makanan/makanan _ TAHU SUKUN BU SULIANI.jpeg',
        'Tempe dan Keripik Misdi':
            'makanan/makanan _ tempe dan kripik misdi .jpeg',
        'Cak Abu Gado-Gado': 'makanan/maknan _ cak abu gado gado .jpeg',
        'Norriture': 'makanan/Norriture.jpeg',
        'Oma Panda': 'makanan/Oma Panda.jpeg',
      };
      const legendaryCuisineImages = {
        'Bagoplek Bakso Goreng': 'kuliner legend/BAGOPLEK bakso Goreng.jpeg',
        'Jemblem Mentega': 'kuliner legend/JEMBLEM MENTEGA.jpeg',
        'Lumpia Semarang 83': 'kuliner legend/Lumpia Semarang 83.jpg',
        'Om Rizal Aneka Kuliner': 'kuliner legend/OM RIZAL ANEKA KULINER.jpeg',
        'Ote Ote Fam': 'kuliner legend/OTE OTE FAM.jpeg',
        'Warung Nologaten': 'kuliner legend/Warung Nologaten.png',
      };

      for (final entry in {
        ...foodImages.entries,
        ...legendaryCuisineImages.entries,
      }) {
        final store = marketStores.singleWhere(
          (store) => store.name == entry.key,
        );
        expect(store.image, entry.value);
        expect(store.badge, isEmpty);
        expect(store.displayCategory, isEmpty);

        final data = await rootBundle.load('assets/${store.image}');
        final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
        codec.dispose();
      }

      expect(
        marketStores.where((store) => store.category == 'Makanan'),
        hasLength(foodImages.length + 4),
      );
      expect(
        marketStores.where((store) => store.category == 'Kuliner Legendaris'),
        hasLength(legendaryCuisineImages.length),
      );
    },
  );

  testWidgets(
    'Daging & Ikan shows the eight supplied stores and search filters',
    (tester) async {
      const suppliedStoreImages = {
        'B. Sutilah': 'store-b-sutilah.jpg',
        'Bejo': 'store-bejo.jpg',
        'Bu Ika': 'store-bu-ika.jpg',
        'Bu Wagini': 'store-bu-wagini.jpg',
        'Cik Ling': 'store-cik-ling.jpg',
        'Hj. Sofiyah': 'store-hj-sofiyah.jpg',
        'Kekal Torik': 'store-kekal-torik.jpg',
        'Mbak Ami Daging': 'store-mbak-ami.jpg',
      };
      final meatAndFishStores = marketStores
          .where((store) => store.category == 'Daging & Ikan')
          .toList();

      expect(meatAndFishStores, hasLength(8));
      expect(
        meatAndFishStores.any((store) => store.name == 'Norriture'),
        isFalse,
      );
      for (final entry in suppliedStoreImages.entries) {
        final store = meatAndFishStores.singleWhere(
          (store) => store.name == entry.key,
        );
        expect(store.image, entry.value);
        final data = await rootBundle.load('assets/${store.image}');
        expect(data.lengthInBytes, greaterThan(0));
        expect(data.getUint8(0), 0xFF);
        expect(data.getUint8(1), 0xD8);
      }

      await tester.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(0.8)),
          child: MaterialApp(
            home: StoreListScreen(initialCategory: 'Daging & Ikan'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('8 Toko'), findsOneWidget);
      expect(find.text('Norriture'), findsNothing);

      await tester.enterText(find.byType(TextField), 'bejo');
      await tester.pumpAndSettle();

      expect(find.text('1 Toko'), findsOneWidget);
      expect(find.text('Bejo'), findsOneWidget);
      expect(find.text('B. Sutilah'), findsNothing);

      await tester.enterText(find.byType(TextField), 'norriture');
      await tester.pumpAndSettle();

      expect(find.text('0 Toko'), findsOneWidget);
      expect(find.text('Norriture'), findsNothing);
    },
  );

  testWidgets('Sayur & Buah shows all stores and search filters', (
    tester,
  ) async {
    const suppliedStoreImages = {
      'Ismawati Sayur': 'store-ismawati-sayur.jpg',
      'Handoko Aneka Buah': 'store-handoko-buah.jpg',
      'Mbak Indah Sayur': 'store-mbak-indah.jpg',
      'Pak Khozin Buah': 'store-pak-khozin.jpg',
      'Pak Mad Sayur Buah': 'store-pak-mad.jpg',
      'B. Wiji': 'store-b-wiji-sayur.jpg',
      'Pak Subai': 'store-pak-subai-sayur.jpg',
      'Pak To': 'store-pak-to-sayur.jpg',
      'Wiwit Sayur': 'store-wiwit-sayur.jpg',
    };
    final produceStores = marketStores
        .where((store) => store.category == 'Sayur & Buah')
        .toList();

    expect(produceStores, hasLength(9));
    expect(
      produceStores.any((store) => store.name == 'FresGreen Organic'),
      isFalse,
    );
    for (final entry in suppliedStoreImages.entries) {
      final store = produceStores.singleWhere(
        (store) => store.name == entry.key,
      );
      expect(store.image, entry.value);
      final data = await rootBundle.load('assets/${store.image}');
      expect(data.lengthInBytes, greaterThan(0));
      expect(data.getUint8(0), 0xFF);
      expect(data.getUint8(1), 0xD8);
    }

    await tester.pumpWidget(
      const MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(0.8)),
        child: MaterialApp(
          home: StoreListScreen(initialCategory: 'Sayur & Buah'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('9 Toko'), findsOneWidget);
    expect(find.text('FresGreen Organic'), findsNothing);
    for (final name in suppliedStoreImages.keys) {
      await scrollUntilStoreVisible(tester, name);
      expect(find.text(name), findsOneWidget);
    }

    await scrollToTop(tester);
    await tester.enterText(find.byType(TextField), 'subai');
    await tester.pumpAndSettle();

    expect(find.text('1 Toko'), findsOneWidget);
    expect(find.text('Pak Subai'), findsOneWidget);
    expect(find.text('Ismawati Sayur'), findsNothing);
    expect(find.text('Pak To'), findsNothing);

    await tester.enterText(find.byType(TextField), 'fresgreen');
    await tester.pumpAndSettle();

    expect(find.text('0 Toko'), findsOneWidget);
    expect(find.text('FresGreen Organic'), findsNothing);
  });

  testWidgets(
    'Sembako & Perabotan shows all supplied shops and search filters',
    (tester) async {
      const suppliedStoreImages = {
        'Bu Yuli': 'store-bu-yuli.jpg',
        'Bu Murti': 'store-bu-murti.jpg',
        'Bu Warsinah': 'store-bu-warsinah.jpg',
        'Bu War': 'store-bu-war.jpg',
        'Sabari': 'store-sabari.jpg',
      };
      final sembakoStores = marketStores
          .where((store) => store.category == 'Sembako & Perabotan')
          .toList();

      expect(sembakoStores, hasLength(5));
      for (final entry in suppliedStoreImages.entries) {
        final store = sembakoStores.singleWhere(
          (store) => store.name == entry.key,
        );
        expect(store.image, entry.value);
        final data = await rootBundle.load('assets/${store.image}');
        expect(data.lengthInBytes, greaterThan(0));
        expect(data.getUint8(0), 0xFF);
        expect(data.getUint8(1), 0xD8);
      }

      await tester.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(0.8)),
          child: MaterialApp(
            home: StoreListScreen(initialCategory: 'Sembako & Perabotan'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('5 Toko'), findsOneWidget);
      for (final name in suppliedStoreImages.keys) {
        await scrollUntilStoreVisible(tester, name);
        expect(find.text(name), findsOneWidget);
      }

      await scrollToTop(tester);
      await tester.enterText(find.byType(TextField), 'sabari');
      await tester.pumpAndSettle();

      expect(find.text('1 Toko'), findsOneWidget);
      expect(find.text('Sabari'), findsOneWidget);
      expect(find.text('Bu Yuli'), findsNothing);
    },
  );

  testWidgets('Toko Mainan & Pakaian shows supplied shop photos', (
    tester,
  ) async {
    const toyShops = {
      'Toko Pojok Bedak 1': 'mainan/toko pojok bedak 1 .jpeg',
      'Mama Hong Pulsa': 'mainan/mama hong.jpeg',
      'Toko Pakaian Bu Anas': 'pakaian/Toko Pakaian Bu Anas.jpg',
      'Toko Pecah Belah Bu Yanti': 'pakaian/Toko Pecah Belah Bu Yanti.jpg',
    };
    final stores = marketStores
        .where((store) => store.category == 'Toko Mainan & Pakaian')
        .toList();

    expect(stores, hasLength(4));
    for (final entry in toyShops.entries) {
      final store = stores.singleWhere((store) => store.name == entry.key);
      expect(store.image, entry.value);
      final data = await rootBundle.load('assets/${store.image}');
      final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
      codec.dispose();
    }

    await tester.pumpWidget(
      const MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(0.8)),
        child: MaterialApp(
          home: StoreListScreen(initialCategory: 'Toko Mainan & Pakaian'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Toko\nMainan &\nPakaian'), findsOneWidget);
    expect(find.text('4 Toko'), findsOneWidget);
    expect(find.text('Kios Mainan & Baju Ceria'), findsNothing);
    for (final name in toyShops.keys) {
      await scrollUntilStoreVisible(tester, name);
      expect(find.text(name), findsOneWidget);
    }
  });
}
