import 'package:flutter/foundation.dart';

import '../../domain/entities/store.dart';
import '../../domain/repositories/store_repository.dart';
import '../datasources/store_local_data_source.dart';
import '../datasources/store_remote_data_source.dart';
import '../datasources/store_api_client.dart';

class StoreRepositoryImpl implements StoreRepository {
  const StoreRepositoryImpl({
    required StoreRemoteDataSource remoteDataSource,
    required StoreLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

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
      debugPrint('Koneksi backend gagal: $e.');
      if (_lastKnownStores.isNotEmpty) {
        return _lastKnownStores;
      }
      return const [];
    }

    // Hanya toko dari backend (yang diinputkan melalui admin) yang ditampilkan.
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

    final result = storesBySlug.values
        .where(
          (store) =>
              store.status.isEmpty || StoreApi.isPublicStatus(store.status),
        )
        .toList();

    _lastKnownStores = result;
    return result;
  }

  @override
  List<Store> fetchLocalStores() => _localDataSource.fetchStores();

  @override
  Future<Store> fetchStore(String slug, {String? expectedName}) async {
    final canonicalSlug = _canonicalSlug(slug);
    Store? backendStore;
    Exception? lastError;

    // Ambil langsung dari backend
    try {
      backendStore = await _remoteDataSource.fetchStore(slug);
    } on Exception catch (error) {
      lastError = error;
    }

    // Jika gagal, cari padanan slug di daftar toko backend
    if (backendStore == null) {
      try {
        final backendStores =
            await _getBackendStoresForLookup(forceRefresh: true);
        final resolved = _findMatchingBackendStore(
          backendStores,
          slug: slug,
          canonicalSlug: canonicalSlug,
          requestedName: expectedName,
        );
        if (resolved != null) {
          try {
            backendStore = await _remoteDataSource.fetchStore(resolved.id);
          } on Exception {
            backendStore = resolved;
          }
        }
      } on Exception catch (error) {
        lastError ??= error;
      }
    }

    if (backendStore != null) {
      if (!StoreApi.isPublicStatus(backendStore.status)) {
        throw const StoreApiException('Toko belum tersedia untuk publik.');
      }
      return backendStore;
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

  static String _canonicalSlug(String slug) =>
      _backendToCanonical[slug] ?? slug;
}
