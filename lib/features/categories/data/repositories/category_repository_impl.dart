import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_remote_data_source.dart';
import '../datasources/local/category_local_data_source.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  const CategoryRepositoryImpl({
    required CategoryRemoteDataSource remoteDataSource,
    required CategoryLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  final CategoryRemoteDataSource _remoteDataSource;
  final CategoryLocalDataSource _localDataSource;

  @override
  Future<List<StoreCategory>> getCategories() async {
    try {
      final remote = await _remoteDataSource.fetchCategories();
      if (remote.isNotEmpty) {
        return remote;
      }
    } catch (_) {
      // Fallback ke data lokal jika koneksi gagal atau server offline
    }
    return _localDataSource.getCategories();
  }

  @override
  List<StoreCategory> getLocalCategories() => _localDataSource.getCategories();
}
