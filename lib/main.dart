import 'package:flutter/material.dart';

import 'screens/discovery_screens.dart';
import 'screens/home/home_screen.dart';
import 'screens/market_facilities/market_facilities_screen.dart';
import 'screens/market_history/market_history_screen.dart';
import 'screens/market_map/market_map_screen.dart';
import 'screens/recommendations/recommendations_screen.dart' as recommendations;
import 'screens/review_screens.dart' hide WriteMarketReviewScreen;
import 'screens/store_detail/store_detail_screen.dart';
import 'screens/store_list/store_list_screen.dart';
import 'screens/store_reviews/store_reviews_screen.dart';
import 'screens/visit_planner/visit_planner_screen.dart' as visit_planner;
import 'screens/welcome_screens.dart';
import 'screens/write_store_review/write_store_review_screen.dart';
import 'screens/write_market_review/write_market_review_screen.dart'
    as market_review;
import 'widgets/market_ui.dart';

void main() {
  runApp(const PasarOroOroDowoApp());
}

class PasarOroOroDowoApp extends StatelessWidget {
  const PasarOroOroDowoApp({super.key});

  Route<dynamic> _route(RouteSettings settings) {
    final uri = Uri.parse(settings.name ?? '/');
    final path = uri.path;
    final Widget page;

    if (path.startsWith('/detail-toko/')) {
      page = StoreDetailScreen(
        storeId: uri.pathSegments.last,
        expectedStoreName: uri.queryParameters['name'],
      );
    } else {
      switch (path) {
        case '/':
          page = const SplashScreen();
        case '/landing-page':
          page = const LandingPage();
        case '/home':
          page = const HomeScreen();
        case '/toko':
          page = StoreListScreen(
            initialCategory: uri.queryParameters['category'],
          );
        case '/detail-toko':
          page = StoreDetailScreen(
            storeId: uri.pathSegments.length > 1
                ? uri.pathSegments.last
                : 'lumpur-kentang-27',
            expectedStoreName: uri.queryParameters['name'],
          );
        case '/denah':
          page = const MarketMapScreen();
        case '/chatbot-rekomendasi':
          page = const visit_planner.VisitPlannerScreen();
        case '/fasilitas-pasar':
          page = const MarketFacilitiesScreen();
        case '/sejarah-pasar':
        case '/sejarah':
          page = const MarketHistoryScreen();
        case '/info-kunjungan':
          page = const VisitInfoScreen();
        case '/promo':
          page = const PromoScreen();
        case '/rekomendasi':
          page = const recommendations.RecommendationsScreen();
        case '/review-pasar':
          page = const MarketReviewsScreen();
        case '/tulis-ulasan-pasar':
          page = const market_review.WriteMarketReviewScreen();
        case '/tulis-ulasan-toko':
          page = WriteStoreReviewScreen(
            storeId: uri.queryParameters['storeId'],
          );
        case '/ulasan-toko':
          page = StoreReviewsScreen(
            storeId: uri.queryParameters['storeId'] ?? '',
            storeName: uri.queryParameters['storeName'] ?? 'Toko',
          );
        default:
          page = const HomeScreen();
      }
    }

    if (path == '/tulis-ulasan-pasar') {
      return MaterialPageRoute<bool>(
        settings: settings,
        builder: (_) => page,
      );
    }

    return MaterialPageRoute<void>(settings: settings, builder: (_) => page);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pasar Oro-Oro Dowo',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: MarketColors.canvas,
        colorScheme: ColorScheme.fromSeed(
          seedColor: MarketColors.pink,
          primary: MarketColors.pink,
          surface: MarketColors.paper,
        ),
        fontFamily: 'Arial',
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: MarketColors.pink,
          selectionColor: Color(0x55D56989),
          selectionHandleColor: MarketColors.pink,
        ),
      ),
      onGenerateRoute: _route,
    );
  }
}
