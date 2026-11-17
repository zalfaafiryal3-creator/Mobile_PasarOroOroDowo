import 'package:flutter/foundation.dart';

import '../../domain/entities/store.dart';
import '../../domain/repositories/store_repository.dart';
import '../datasources/store_local_data_source.dart';
import '../datasources/store_remote_data_source.dart';
import '../datasources/store_api_client.dart';

class StoreRepositoryImpl implements StoreRepository {
  const StoreRepositoryImpl({
    required this._remoteDataSource,
    required this._localDataSource,
  });

  final StoreRemoteDataSource _remoteDataSource;
  final StoreLocalDataSource _localDataSource;

  static const Map<String, String> _backendToCanonical = {
    'fresgreen-organic': 'fresh-green',
  };

  static const Map<String, String> _canonicalToBackend = {
    'fresh-green': 'fresgreen-organic',
  };

  @override
  Future<List<Store>> fetchStores() async {
    final backendStores = await _remoteDataSource.fetchStores();
    final localStores = _localDataSource.fetchStores();
    final storesBySlug = <String, Store>{};
    for (final store in backendStores) {
      final canonical = _canonicalSlug(store.id);
      final existing = storesBySlug[canonical];
      if (existing == null ||
          (!StoreApi.isPublicStatus(existing.status) &&
              StoreApi.isPublicStatus(store.status)) ||
          (!StoreApi.hasValidImage(existing) &&
              StoreApi.hasValidImage(store))) {
        storesBySlug[canonical] = store;
      }
    }

    final mergedStores = <String, Store>{};
    for (final localStore in localStores) {
      final backendStore = storesBySlug[localStore.id];
      if (backendStore == null) {
        mergedStores.putIfAbsent(localStore.id, () => localStore);
      } else if (backendStore.name == localStore.name ||
          _isDuplicateAlias(backendStore.id, localStore.id)) {
        if (StoreApi.isPublicStatus(backendStore.status)) {
          mergedStores[localStore.id] = _mergeStores(localStore, backendStore);
        }
      } else {
        mergedStores.putIfAbsent(localStore.id, () => localStore);
      }
    }

    for (final backendStore in backendStores) {
      final canonical = _canonicalSlug(backendStore.id);
      if (!StoreApi.isPublicStatus(backendStore.status) ||
          mergedStores.containsKey(canonical) ||
          mergedStores.containsKey(backendStore.id)) {
        continue;
      }
      final localStore = localStores
          .where(
            (store) => store.id == backendStore.id || store.id == canonical,
          )
          .firstOrNull;
      if (localStore == null && StoreApi.hasValidImage(backendStore)) {
        mergedStores[backendStore.id] = backendStore;
      }
    }

    return mergedStores.values
        .where(
          (store) =>
              StoreApi.hasValidImage(store) &&
              (store.status.isEmpty || StoreApi.isPublicStatus(store.status)),
        )
        .toList();
  }

  @override
  List<Store> fetchLocalStores() => _localDataSource.fetchStores();

  @override
  Future<Store> fetchStore(String slug, {String? expectedName}) async {
    final canonicalSlug = _canonicalSlug(slug);
    final localStores = _localDataSource.fetchStores();
    final mobileStore = localStores
        .where((store) => store.id == slug || store.id == canonicalSlug)
        .firstOrNull;
    final requestedName = expectedName ?? mobileStore?.name;
    final fallbackStore =
        mobileStore != null &&
            (requestedName == null ||
                mobileStore.name == requestedName ||
                _isDuplicateAlias(slug, mobileStore.id))
        ? mobileStore
        : null;

    try {
      final backendStore = await _remoteDataSource.fetchStore(slug);
      if ((backendStore.id != StoreApi.backendSlug(slug) &&
              _canonicalSlug(backendStore.id) != canonicalSlug) ||
          (requestedName != null &&
              backendStore.name != requestedName &&
              !_isDuplicateAlias(backendStore.id, slug))) {
        if (fallbackStore != null) return fallbackStore;
        throw const FormatException(
          'Detail toko dari server tidak sesuai dengan toko yang dipilih.',
        );
      }
      if (!StoreApi.isPublicStatus(backendStore.status)) {
        if (fallbackStore != null) return fallbackStore;
        throw const StoreApiException('Toko belum tersedia untuk publik.');
      }
      final matchingLocalStore =
          mobileStore != null &&
              (mobileStore.name == backendStore.name ||
                  _isDuplicateAlias(backendStore.id, mobileStore.id))
          ? mobileStore
          : null;
      return matchingLocalStore == null
          ? backendStore
          : _mergeStores(matchingLocalStore, backendStore);
    } on Exception catch (error) {
      if (fallbackStore != null) {
        if (error is StoreApiException && error.statusCode == 404) {
          return fallbackStore;
        }
        debugPrint('Gagal memuat detail Backend untuk $slug: $error');
        return fallbackStore;
      }
      rethrow;
    }
  }

  static String _canonicalSlug(String slug) =>
      _backendToCanonical[slug] ?? slug;

  static bool _isDuplicateAlias(String a, String b) {
    if (a == b) return false;
    return _backendToCanonical[a] == b ||
        _backendToCanonical[b] == a ||
        _canonicalToBackend[a] == b ||
        _canonicalToBackend[b] == a;
  }

  static Store _mergeStores(Store local, Store backend) => Store(
    id: local.id,
    name: local.name,
    category: local.category.isNotEmpty ? local.category : backend.category,
    displayCategory: local.displayCategory.isNotEmpty
        ? local.displayCategory
        : backend.displayCategory,
    badge: local.badge.isNotEmpty ? local.badge : backend.badge,
    rating: backend.rating.isNotEmpty ? backend.rating : local.rating,
    products: backend.productCount > 0 ? backend.products : local.products,
    image: local.image.trim().isNotEmpty ? local.image : backend.image,
    owner: backend.owner.isNotEmpty ? backend.owner : local.owner,
    zone: backend.zone.isNotEmpty ? backend.zone : local.zone,
    status: backend.status,
    openTime: backend.openTime ?? local.openTime,
    closeTime: backend.closeTime ?? local.closeTime,
    phone: backend.phone.isNotEmpty ? backend.phone : local.phone,
    description: backend.description.isNotEmpty
        ? backend.description
        : local.description,
    productCount: backend.productCount > 0
        ? backend.productCount
        : local.productCount,
    reviewCount: backend.reviewCount,
    catalogProducts: backend.catalogProducts.isNotEmpty
        ? backend.catalogProducts
        : local.catalogProducts,
    isLocalFallback: false,
  );
}
