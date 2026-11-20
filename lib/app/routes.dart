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
import 'package:frontend_flutter/features/store_reviews/presentation/pages/store_reviews_screen.dart';
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
          storeId: uri.pathSegments.length > 1
              ? uri.pathSegments.last
              : 'lumpur-kentang-27',
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
        );
      case '/tulis-ulasan-toko':
        page = WriteStoreReviewScreen(
          submitReview: dependencies.submitStoreReview,
          storeId: uri.queryParameters['storeId'],
          isLocalFallback: uri.queryParameters['localOnly'] == 'true',
        );
      case '/ulasan-toko':
        page = StoreReviewsScreen(
          storeId: uri.queryParameters['storeId'] ?? '',
          storeName: uri.queryParameters['storeName'] ?? 'Toko',
          getStatistics: dependencies.getStoreReviewStatistics,
          getReviews: dependencies.getStoreReviews,
          isLocalFallback: uri.queryParameters['localOnly'] == 'true',
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
