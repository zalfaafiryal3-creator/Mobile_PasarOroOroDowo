import 'package:http/http.dart' as http;

import '../../domain/entities/store.dart';
import 'store_api_client.dart';

class StoreRemoteDataSource {
  const StoreRemoteDataSource({this.client});

  final http.Client? client;

  Future<List<Store>> fetchStores() => StoreApi.fetchStores(client: client);

  Future<Store> fetchStore(String slug) =>
      StoreApi.fetchStore(slug, client: client);
}
