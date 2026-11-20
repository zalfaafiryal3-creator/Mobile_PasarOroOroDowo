import 'package:http/http.dart' as http;

import 'package:frontend_flutter/features/stores/data/datasources/store_local_data_source.dart';
import 'package:frontend_flutter/features/stores/data/datasources/store_remote_data_source.dart';
import 'package:frontend_flutter/features/stores/data/repositories/store_repository_impl.dart';
import 'package:frontend_flutter/features/stores/domain/repositories/store_repository.dart';
import 'package:frontend_flutter/features/stores/domain/usecases/get_local_stores.dart';
import 'package:frontend_flutter/features/stores/domain/usecases/get_store.dart';
import 'package:frontend_flutter/features/stores/domain/usecases/get_stores.dart';
import 'package:frontend_flutter/features/recommendations/data/datasources/recommendations_remote_data_source.dart';
import 'package:frontend_flutter/features/recommendations/data/repositories/recommendations_repository_impl.dart';
import 'package:frontend_flutter/features/recommendations/domain/repositories/recommendations_repository.dart';
import 'package:frontend_flutter/features/recommendations/domain/usecases/get_featured_products.dart';
import 'package:frontend_flutter/features/recommendations/domain/usecases/get_recommended_stores.dart';
import 'package:frontend_flutter/features/visit_planner/data/datasources/visit_planner_remote_data_source.dart';
import 'package:frontend_flutter/features/visit_planner/data/repositories/visit_planner_repository_impl.dart';
import 'package:frontend_flutter/features/visit_planner/domain/repositories/visit_planner_repository.dart';
import 'package:frontend_flutter/features/visit_planner/domain/usecases/get_visit_recommendations.dart';
import 'package:frontend_flutter/features/store_reviews/data/datasources/store_reviews_remote_data_source.dart';
import 'package:frontend_flutter/features/store_reviews/data/repositories/store_reviews_repository_impl.dart';
import 'package:frontend_flutter/features/store_reviews/domain/repositories/store_reviews_repository.dart';
import 'package:frontend_flutter/features/store_reviews/domain/usecases/get_store_form_reviews.dart';
import 'package:frontend_flutter/features/store_reviews/domain/usecases/get_store_review_statistics.dart';
import 'package:frontend_flutter/features/store_reviews/domain/usecases/get_store_reviews.dart';
import 'package:frontend_flutter/features/store_reviews/domain/usecases/submit_store_review.dart';
import 'package:frontend_flutter/features/market_reviews/data/datasources/market_reviews_remote_data_source.dart';
import 'package:frontend_flutter/features/market_reviews/data/repositories/market_reviews_repository_impl.dart';
import 'package:frontend_flutter/features/market_reviews/domain/repositories/market_reviews_repository.dart';
import 'package:frontend_flutter/features/market_reviews/domain/usecases/get_market_review_statistics.dart';
import 'package:frontend_flutter/features/market_reviews/domain/usecases/get_market_reviews.dart';
import 'package:frontend_flutter/features/market_reviews/domain/usecases/submit_market_review.dart';
import 'package:frontend_flutter/features/promotions/data/datasources/local/promo_catalog.dart';
import 'package:frontend_flutter/features/promotions/data/datasources/promo_remote_data_source.dart';
import 'package:frontend_flutter/features/promotions/data/repositories/promo_repository_impl.dart';
import 'package:frontend_flutter/features/promotions/domain/repositories/promo_repository.dart';
import 'package:frontend_flutter/features/promotions/domain/usecases/get_promotions.dart';
import 'package:frontend_flutter/features/categories/domain/usecases/store_category_matcher.dart';

class AppDependencies {
  AppDependencies._({
    required this.storeRepository,
    required this.getStores,
    required this.getLocalStores,
    required this.getStore,
    required this.recommendationsRepository,
    required this.getRecommendedStores,
    required this.getFeaturedProducts,
    required this.visitPlannerRepository,
    required this.getVisitRecommendations,
    required this.storeReviewsRepository,
    required this.getStoreReviewStatistics,
    required this.getStoreReviews,
    required this.getStoreFormReviews,
    required this.submitStoreReview,
    required this.marketReviewsRepository,
    required this.getMarketReviewStatistics,
    required this.getMarketReviews,
    required this.submitMarketReview,
    required this.promoRepository,
    required this.getPromotions,
    required this.storeCategoryMatcher,
  });

  factory AppDependencies.create({http.Client? httpClient}) {
    final client = httpClient ?? http.Client();
    final storeRepository = StoreRepositoryImpl(
      remoteDataSource: StoreRemoteDataSource(client: client),
      localDataSource: const StoreLocalDataSource(),
    );
    final recommendationsRepository = RecommendationsRepositoryImpl(
      RecommendationsRemoteDataSource(client: client),
    );
    final visitPlannerRepository = VisitPlannerRepositoryImpl(
      VisitPlannerRemoteDataSource(client: client),
    );
    final storeReviewsRepository = StoreReviewsRepositoryImpl(
      StoreReviewsRemoteDataSource(client: client),
    );
    final marketReviewsRepository = MarketReviewsRepositoryImpl(
      MarketReviewsRemoteDataSource(client: client),
    );
    final promoRepository = PromoRepositoryImpl(
      PromoRemoteDataSource(client: client),
      const PromoLocalDataSource(),
    );
    return AppDependencies._(
      storeRepository: storeRepository,
      getStores: GetStores(storeRepository),
      getLocalStores: GetLocalStores(storeRepository),
      getStore: GetStore(storeRepository),
      recommendationsRepository: recommendationsRepository,
      getRecommendedStores: GetRecommendedStores(recommendationsRepository),
      getFeaturedProducts: GetFeaturedProducts(recommendationsRepository),
      visitPlannerRepository: visitPlannerRepository,
      getVisitRecommendations: GetVisitRecommendations(visitPlannerRepository),
      storeReviewsRepository: storeReviewsRepository,
      getStoreReviewStatistics: GetStoreReviewStatistics(
        storeReviewsRepository,
      ),
      getStoreReviews: GetStoreReviews(storeReviewsRepository),
      getStoreFormReviews: GetStoreFormReviews(storeReviewsRepository),
      submitStoreReview: SubmitStoreReview(storeReviewsRepository),
      marketReviewsRepository: marketReviewsRepository,
      getMarketReviewStatistics: GetMarketReviewStatistics(
        marketReviewsRepository,
      ),
      getMarketReviews: GetMarketReviews(marketReviewsRepository),
      submitMarketReview: SubmitMarketReview(marketReviewsRepository),
      promoRepository: promoRepository,
      getPromotions: GetPromotions(promoRepository),
      storeCategoryMatcher: const StoreCategoryMatcher(),
    );
  }

  final StoreRepository storeRepository;
  final GetStores getStores;
  final GetLocalStores getLocalStores;
  final GetStore getStore;
  final RecommendationsRepository recommendationsRepository;
  final GetRecommendedStores getRecommendedStores;
  final GetFeaturedProducts getFeaturedProducts;
  final VisitPlannerRepository visitPlannerRepository;
  final GetVisitRecommendations getVisitRecommendations;
  final StoreReviewsRepository storeReviewsRepository;
  final GetStoreReviewStatistics getStoreReviewStatistics;
  final GetStoreReviews getStoreReviews;
  final GetStoreFormReviews getStoreFormReviews;
  final SubmitStoreReview submitStoreReview;
  final MarketReviewsRepository marketReviewsRepository;
  final GetMarketReviewStatistics getMarketReviewStatistics;
  final GetMarketReviews getMarketReviews;
  final SubmitMarketReview submitMarketReview;
  final PromoRepository promoRepository;
  final GetPromotions getPromotions;
  final StoreCategoryMatcher storeCategoryMatcher;
}
