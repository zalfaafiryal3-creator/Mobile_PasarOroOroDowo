import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:frontend_flutter/features/categories/data/datasources/category_remote_data_source.dart';
import 'package:frontend_flutter/features/categories/data/datasources/local/category_local_data_source.dart';
import 'package:frontend_flutter/features/categories/data/repositories/category_repository_impl.dart';

void main() {
  group('CategoryRemoteDataSource', () {
    test('fetches and maps categories from backend successfully', () async {
      final client = MockClient((request) async {
        expect(request.url.path, '/api/categories');
        return http.Response(
          '''[
            {"id": 1, "name": "Makanan", "storeCount": 10},
            {"id": 2, "name": "Pakaian", "storeCount": 4}
          ]''',
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final dataSource = CategoryRemoteDataSource(client: client);
      final categories = await dataSource.fetchCategories();

      expect(categories.length, 2);
      expect(categories[0].id, 1);
      expect(categories[0].name, 'Makanan');
      expect(categories[0].storeCount, 10);
      expect(categories[1].name, 'Pakaian');
    });

    test('throws CategoryApiException when backend returns an error', () async {
      final client = MockClient((_) async => http.Response('Server error', 500));
      final dataSource = CategoryRemoteDataSource(client: client);

      expect(() => dataSource.fetchCategories(), throwsA(isA<CategoryApiException>()));
    });
  });

  group('CategoryRepositoryImpl', () {
    test('returns remote categories when fetch succeeds', () async {
      final client = MockClient((_) async => http.Response(
            '[{"id": 1, "name": "Sembako", "storeCount": 5}]',
            200,
            headers: {'content-type': 'application/json; charset=utf-8'},
          ));
      final remoteSource = CategoryRemoteDataSource(client: client);
      final localSource = CategoryLocalDataSource();
      final repository = CategoryRepositoryImpl(
        remoteDataSource: remoteSource,
        localDataSource: localSource,
      );

      final result = await repository.getCategories();
      expect(result.length, 1);
      expect(result.first.name, 'Sembako');
    });

    test('falls back to local data source when remote fetch fails', () async {
      final client = MockClient((_) async => http.Response('Network down', 503));
      final remoteSource = CategoryRemoteDataSource(client: client);
      final localSource = CategoryLocalDataSource();
      final repository = CategoryRepositoryImpl(
        remoteDataSource: remoteSource,
        localDataSource: localSource,
      );

      final result = await repository.getCategories();
      expect(result.isNotEmpty, true);
      expect(result.any((c) => c.name.toLowerCase().contains('sembako')), true);
    });
  });
}
