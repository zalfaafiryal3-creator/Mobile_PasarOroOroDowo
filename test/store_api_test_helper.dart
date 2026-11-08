import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:frontend_flutter/data/market_data.dart';
import 'package:frontend_flutter/data/store_api.dart';

void installStoreApiMock({
  List<StoreData>? backendStores,
  Map<String, Object?> Function(Map<String, Object?> store)? transform,
}) {
  final stores = backendStores ?? marketStores;
  StoreApi.clientForTesting = MockClient((request) async {
    final pathParts = request.url.pathSegments;
    if (pathParts.length == 2 && pathParts[1] == 'stores') {
      final responseStores = stores
          .map(_toJson)
          .map(_transform(transform))
          .toList();
      return http.Response(
        jsonEncode(responseStores),
        200,
        headers: const {'content-type': 'application/json'},
      );
    }

    final slug = pathParts.isNotEmpty ? pathParts.last : '';
    final matches = stores.where((store) => store.id == slug);
    if (matches.isEmpty) {
      return http.Response(
        jsonEncode({'error': 'Toko tidak ditemukan.'}),
        404,
        headers: const {'content-type': 'application/json'},
      );
    }
    return http.Response(
      jsonEncode(_transform(transform)(_toJson(matches.first))),
      200,
      headers: const {'content-type': 'application/json'},
    );
  });
}

void clearStoreApiMock() {
  StoreApi.clientForTesting = null;
}

Map<String, Object?> Function(Map<String, Object?>) _transform(
  Map<String, Object?> Function(Map<String, Object?> store)? transform,
) => transform ?? (store) => store;

Map<String, Object?> _toJson(StoreData store) {
  final productCount =
      int.tryParse(RegExp(r'\d+').firstMatch(store.products)?.group(0) ?? '') ??
      0;
  return {
    'id': store.id,
    'slug': store.id,
    'name': store.name,
    'owner': store.owner,
    'category': store.category,
    'zone': store.zone,
    'status': store.status.isEmpty ? 'buka' : store.status,
    'openTime': '06:00',
    'closeTime': '17:00',
    'phone': store.phone,
    'description': store.description,
    'rating': double.tryParse(store.rating) ?? 0,
    'reviewCount': store.reviewCount,
    'productCount': productCount,
    'products': const [],
  };
}
