import 'package:flutter/material.dart';
import 'package:frontend_flutter/app/dependencies.dart';
import 'package:frontend_flutter/features/home/presentation/pages/home_screen.dart';
import 'package:frontend_flutter/features/market_information/presentation/pages/discovery_screens.dart';
import 'package:frontend_flutter/features/market_information/presentation/pages/market_facilities_screen.dart';
import 'package:frontend_flutter/features/market_information/presentation/pages/market_history_screen.dart';
import 'package:frontend_flutter/features/market_information/presentation/pages/market_map_screen.dart';
import 'package:frontend_flutter/features/market_information/presentation/pages/welcome_screens.dart';
import 'package:frontend_flutter/features/promotions/presentation/pages/promo_screen.dart';
import 'package:frontend_flutter/features/market_reviews/presentation/pages/review_screens.dart'
    hide WriteMarketReviewScreen;
import 'package:frontend_flutter/features/market_reviews/presentation/pages/write_market_review_screen.dart'
    as market_review;
import 'package:frontend_flutter/features/recommendations/presentation/pages/recommendations_screen.dart'
    as recommendations;
import 'package:frontend_flutter/features/store_reviews/presentation/pages/write_store_review_screen.dart';
import 'package:frontend_flutter/features/stores/presentation/pages/store_detail_screen.dart';
import 'package:frontend_flutter/features/stores/presentation/pages/store_list_screen.dart';
import 'package:frontend_flutter/features/visit_planner/presentation/pages/visit_planner_screen.dart'
    as visit_planner;

Route<dynamic> generateAppRoute(
  RouteSettings settings,
  AppDependencies dependencies,
) {
  final uri = Uri.parse(settings.name ?? '/');
  final path = uri.path;
  final Widget page;

  if (path.startsWith('/detail-toko/')) {
    page = StoreDetailScreen(
      getStore: dependencies.getStore,
      getStoreReviews: dependencies.getStoreReviews,
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
        page = HomeScreen(
          getStores: dependencies.getStores,
          getLocalStores: dependencies.getLocalStores,
          categoryMatcher: dependencies.storeCategoryMatcher,
          getCategories: dependencies.getCategories,
        );
      case '/toko':
        page = StoreListScreen(
          getStores: dependencies.getStores,
          getLocalStores: dependencies.getLocalStores,
          categoryMatcher: dependencies.storeCategoryMatcher,
          getCategories: dependencies.getCategories,
          initialCategory: uri.queryParameters['category'],
        );
      case '/detail-toko':
        page = StoreDetailScreen(
          getStore: dependencies.getStore,
          getStoreReviews: dependencies.getStoreReviews,
          storeId: uri.queryParameters['id'] ?? (uri.pathSegments.length > 1
              ? uri.pathSegments.last
              : 'lumpur-kentang-27'),
          expectedStoreName: uri.queryParameters['name'],
        );
      case '/denah':
        page = const MarketMapScreen();
      case '/chatbot-rekomendasi':
        page = visit_planner.VisitPlannerScreen(
          getVisitRecommendations: dependencies.getVisitRecommendations,
        );
      case '/fasilitas-pasar':
        page = const MarketFacilitiesScreen();
      case '/sejarah-pasar':
      case '/sejarah':
        page = const MarketHistoryScreen();
      case '/info-kunjungan':
        page = const VisitInfoScreen();
      case '/promo':
        page = PromoScreen(getPromotions: dependencies.getPromotions);
      case '/rekomendasi':
        page = recommendations.RecommendationsScreen(
          getRecommendedStores: dependencies.getRecommendedStores,
          getFeaturedProducts: dependencies.getFeaturedProducts,
        );
      case '/review-pasar':
        page = MarketReviewsScreen(
          getStatistics: dependencies.getMarketReviewStatistics,
          getReviews: dependencies.getMarketReviews,
        );
      case '/tulis-ulasan-pasar':
        page = market_review.WriteMarketReviewScreen(
          submitReview: dependencies.submitMarketReview,
          getStatistics: dependencies.getMarketReviewStatistics,
        );
      case '/tulis-ulasan-toko':
        page = WriteStoreReviewScreen(
          submitReview: dependencies.submitStoreReview,
          storeId: uri.queryParameters['storeId'],
          isLocalFallback: uri.queryParameters['localOnly'] == 'true',
        );
      case '/ulasan-toko':
        final storeId = uri.queryParameters['storeId'] ??
            (uri.pathSegments.length > 1
                ? uri.pathSegments.last
                : 'lumpur-kentang-27');
        page = StoreDetailScreen(
          getStore: dependencies.getStore,
          getStoreReviews: dependencies.getStoreReviews,
          storeId: storeId,
          expectedStoreName: uri.queryParameters['storeName'],
        );
      default:
        page = HomeScreen(
          getStores: dependencies.getStores,
          getLocalStores: dependencies.getLocalStores,
          categoryMatcher: dependencies.storeCategoryMatcher,
        );
    }
  }

  if (path == '/tulis-ulasan-pasar' || path == '/tulis-ulasan-toko') {
    return MaterialPageRoute<bool>(settings: settings, builder: (_) => page);
  }
  return MaterialPageRoute<void>(settings: settings, builder: (_) => page);
}

String getSeoTitleForRoute(String? routeName) {
  if (routeName == null || routeName.isEmpty) {
    return 'Pasar Oro-Oro Dowo Malang — Pasar Tradisional Heritage';
  }
  final uri = Uri.parse(routeName);
  final path = uri.path;

  if (path.startsWith('/detail-toko/')) {
    final storeName = uri.queryParameters['name'] ?? 'Toko';
    return 'Detail $storeName | Pasar Oro-Oro Dowo Malang';
  }

  switch (path) {
    case '/':
      return 'Pasar Oro-Oro Dowo Malang — Pasar Tradisional Heritage';
    case '/landing-page':
      return 'Selamat Datang | Pasar Oro-Oro Dowo Malang';
    case '/home':
      return 'Beranda Belanja & Kuliner | Pasar Oro-Oro Dowo Malang';
    case '/toko':
      final cat = uri.queryParameters['category'];
      return (cat != null && cat.isNotEmpty)
          ? 'Toko Kategori $cat | Pasar Oro-Oro Dowo Malang'
          : 'Daftar Toko & Pedagang | Pasar Oro-Oro Dowo Malang';
    case '/detail-toko':
      final storeName = uri.queryParameters['name'] ?? 'Toko';
      return 'Detail $storeName | Pasar Oro-Oro Dowo Malang';
    case '/denah':
      return 'Denah & Peta Lokasi Pasar | Pasar Oro-Oro Dowo Malang';
    case '/chatbot-rekomendasi':
      return 'AI Perencana Kunjungan Belanja | Pasar Oro-Oro Dowo Malang';
    case '/fasilitas-pasar':
      return 'Fasilitas Pasar Lengkap | Pasar Oro-Oro Dowo Malang';
    case '/sejarah-pasar':
    case '/sejarah':
      return 'Sejarah & Heritage Pasar | Pasar Oro-Oro Dowo Malang';
    case '/info-kunjungan':
      return 'Informasi Jam Buka & Kunjungan | Pasar Oro-Oro Dowo Malang';
    case '/promo':
      return 'Promo & Diskon Belanja | Pasar Oro-Oro Dowo Malang';
    case '/rekomendasi':
      return 'Rekomendasi Kuliner & Produk Pilihan | Pasar Oro-Oro Dowo Malang';
    case '/review-pasar':
      return 'Review & Ulasan Pengunjung | Pasar Oro-Oro Dowo Malang';
    case '/tulis-ulasan-pasar':
      return 'Tulis Ulasan Pasar | Pasar Oro-Oro Dowo Malang';
    case '/tulis-ulasan-toko':
      return 'Tulis Ulasan Toko | Pasar Oro-Oro Dowo Malang';
    case '/ulasan-toko':
      final storeName = uri.queryParameters['storeName'] ?? 'Toko';
      return 'Ulasan $storeName | Pasar Oro-Oro Dowo Malang';
    default:
      return 'Pasar Oro-Oro Dowo Malang — Pasar Tradisional Heritage';
  }
}
