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

  static List<Store> _lastKnownStores = [];
  static String? _lastFetchError;

  @override
  String? get lastFetchError => _lastFetchError;

  @override
  Future<List<Store>> fetchStores() async {
    List<Store> backendStores = const [];
    try {
      backendStores = await _remoteDataSource.fetchStores();
      _lastFetchError = null;
    } catch (e) {
      _lastFetchError = e.toString();
      debugPrint(
        'Koneksi backend gagal: $e. Menggunakan cache / katalog lokal.',
      );
      if (_lastKnownStores.isNotEmpty) {
        return _lastKnownStores;
      }
    }
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
      } else {
        if (StoreApi.isPublicStatus(backendStore.status)) {
          mergedStores[localStore.id] = _mergeStores(
            localStore,
            backendStore,
            preserveLocalName: _isDuplicateAlias(
              backendStore.id,
              localStore.id,
            ),
          );
        }
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
      if (localStore == null) {
        mergedStores[backendStore.id] = backendStore;
      }
    }

    final result = mergedStores.values
        .where(
          (store) =>
              store.status.isEmpty || StoreApi.isPublicStatus(store.status),
        )
        .toList();

    if (result.isNotEmpty) {
      _lastKnownStores = result;
    }
    return result;
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
          _canonicalSlug(backendStore.id) != canonicalSlug)) {
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
              (mobileStore.id == _canonicalSlug(backendStore.id) ||
                  _isDuplicateAlias(backendStore.id, mobileStore.id))
          ? mobileStore
          : null;
      return matchingLocalStore == null
          ? backendStore
          : _mergeStores(
              matchingLocalStore,
              backendStore,
              preserveLocalName: _isDuplicateAlias(
                backendStore.id,
                matchingLocalStore.id,
              ),
            );
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

  static Store _mergeStores(
    Store local,
    Store backend, {
    bool preserveLocalName = false,
  }) => Store(
    id: local.id,
    name: preserveLocalName ? local.name : backend.name,
    category: backend.category,
    displayCategory: backend.category == local.category
        ? local.displayCategory
        : backend.displayCategory,
    badge: local.badge.isNotEmpty ? local.badge : backend.badge,
    rating: backend.rating,
    products: backend.products,
    image: StoreApi.hasValidImage(backend) ? backend.image : local.image,
    owner: backend.owner,
    zone: backend.zone,
    status: backend.status,
    openTime: backend.openTime,
    closeTime: backend.closeTime,
    phone: backend.phone,
    description: backend.description,
    productCount: backend.productCount,
    reviewCount: backend.reviewCount,
    catalogProducts: backend.catalogProducts,
    isLocalFallback: false,
  );
}
