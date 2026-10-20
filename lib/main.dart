import 'package:flutter/material.dart';

import 'screens/discovery_screens.dart';
import 'screens/market_screens.dart';
import 'screens/review_screens.dart';
import 'screens/visit_planner/visit_planner_screen.dart' as visit_planner;
import 'screens/welcome_screens.dart';
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
      page = StoreDetailScreen(storeId: uri.pathSegments.last);
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
          );
        case '/denah':
          page = const MarketMapScreen();
        case '/chatbot-rekomendasi':
          page = const visit_planner.VisitPlannerScreen();
        case '/fasilitas-pasar':
          page = const FacilitiesScreen();
        case '/info-kunjungan':
          page = const VisitInfoScreen();
        case '/promo':
          page = const PromoScreen();
        case '/rekomendasi':
          page = const RecommendationsScreen();
        case '/review-pasar':
          page = const MarketReviewsScreen();
        case '/tulis-ulasan-pasar':
          page = const WriteMarketReviewScreen();
        case '/tulis-ulasan-toko':
          page = const WriteStoreReviewScreen();
        default:
          page = const HomeScreen();
      }
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
