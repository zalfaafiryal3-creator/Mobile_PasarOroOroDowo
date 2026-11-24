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
  static List<Store> _lastKnownBackendStores = [];
  static String? _lastFetchError;

  @override
  String? get lastFetchError => _lastFetchError;

  @override
  Future<List<Store>> fetchStores() async {
    List<Store> backendStores = const [];
    try {
      backendStores = await _remoteDataSource.fetchStores();
      _lastKnownBackendStores = List<Store>.from(backendStores);
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

    Store? backendStore;
    Exception? lastError;

    // Untuk toko yang punya padanan di katalog lokal, cocokkan dulu dengan daftar
    // toko Backend agar perbedaan slug/ID/nama tidak memicu request detail ke
    // endpoint yang salah (404) dan agar toko local-only tidak memanggil Backend.
    if (fallbackStore != null) {
      try {
        final backendStores = await _getBackendStoresForLookup();
        final resolved = _findMatchingBackendStore(
          backendStores,
          slug: slug,
          canonicalSlug: canonicalSlug,
          requestedName: requestedName,
        );
        if (resolved == null) {
          return fallbackStore;
        }
        try {
          backendStore = await _remoteDataSource.fetchStore(resolved.id);
        } on Exception catch (error) {
          lastError = error;
          // Jika detail gagal tetapi toko ada di daftar Backend, gunakan data
          // daftar Backend daripada jatuh ke katalog lokal mentah.
          backendStore = resolved;
        }
      } on Exception catch (error) {
        lastError = error;
        // Gagal memuat daftar Backend; coba alur langsung di bawah.
      }
    }

    // Alur langsung: toko tanpa fallback lokal, atau saat lookup daftar gagal.
    if (backendStore == null) {
      try {
        backendStore = await _remoteDataSource.fetchStore(slug);
      } on Exception catch (error) {
        lastError = error;
      }
    }

    // Jika masih gagal, coba resolusi dari daftar Backend (berguna saat fallback
    // lokal tidak tersedia atau saat slug yang diminta berbeda dari Backend).
    if (backendStore == null) {
      try {
        final backendStores = await _getBackendStoresForLookup(forceRefresh: true);
        final resolved = _findMatchingBackendStore(
          backendStores,
          slug: slug,
          canonicalSlug: canonicalSlug,
          requestedName: requestedName,
        );
        if (resolved != null) {
          try {
            backendStore = await _remoteDataSource.fetchStore(resolved.id);
          } on Exception {
            backendStore = resolved;
          }
        }
      } on Exception {
        // Abaikan; fallback/error akhir ditangani di bawah.
      }
    }

    if (backendStore != null) {
      if (!StoreApi.isPublicStatus(backendStore.status)) {
        if (fallbackStore != null) return fallbackStore;
        throw const StoreApiException('Toko belum tersedia untuk publik.');
      }
      final matchingLocalStore = _findMatchingLocalStore(
        localStores,
        backendStore: backendStore,
        slug: slug,
        canonicalSlug: canonicalSlug,
      );
      if (matchingLocalStore == null) {
        return backendStore;
      }
      return _mergeStores(
        matchingLocalStore,
        backendStore,
        preserveLocalName: _isDuplicateAlias(
          backendStore.id,
          matchingLocalStore.id,
        ),
      );
    }

    if (fallbackStore != null) {
      if (lastError != null &&
          !(lastError is StoreApiException && lastError.statusCode == 404)) {
        debugPrint('Gagal memuat detail Backend untuk $slug: $lastError');
      }
      return fallbackStore;
    }

    if (lastError != null) throw lastError;
    throw const StoreApiException('Toko tidak ditemukan.');
  }

  Future<List<Store>> _getBackendStoresForLookup({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _lastKnownBackendStores.isNotEmpty) {
      return _lastKnownBackendStores;
    }
    final backendStores = await _remoteDataSource.fetchStores();
    _lastKnownBackendStores = List<Store>.from(backendStores);
    return backendStores;
  }

  static Store? _findMatchingBackendStore(
    List<Store> backendStores, {
    required String slug,
    required String canonicalSlug,
    String? requestedName,
  }) {
    final normalizedRequestedName = requestedName?.trim().toLowerCase();
    for (final store in backendStores) {
      if (store.id == slug ||
          store.id == canonicalSlug ||
          _canonicalSlug(store.id) == canonicalSlug ||
          StoreApi.backendSlug(slug) == store.id) {
        return store;
      }
    }
    if (normalizedRequestedName != null && normalizedRequestedName.isNotEmpty) {
      for (final store in backendStores) {
        if (store.name.trim().toLowerCase() == normalizedRequestedName) {
          return store;
        }
      }
    }
    return null;
  }

  static Store? _findMatchingLocalStore(
    List<Store> localStores, {
    required Store backendStore,
    required String slug,
    required String canonicalSlug,
  }) {
    for (final store in localStores) {
      if (store.id == slug ||
          store.id == canonicalSlug ||
          store.id == backendStore.id ||
          store.id == _canonicalSlug(backendStore.id) ||
          _isDuplicateAlias(backendStore.id, store.id)) {
        return store;
      }
    }
    return null;
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
    categoryId: backend.categoryId ?? local.categoryId,
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
