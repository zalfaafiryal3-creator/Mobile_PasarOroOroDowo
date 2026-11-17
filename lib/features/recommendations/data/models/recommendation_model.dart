import '../../domain/entities/recommendation.dart';

class RecommendedStoreModel extends RecommendedStore {
  const RecommendedStoreModel({
    required super.id,
    required super.slug,
    required super.name,
    required super.category,
    required super.location,
    required super.status,
    required super.rating,
    required super.photoUrl,
  });

  factory RecommendedStoreModel.fromJson(
    Map<String, dynamic> json, {
    required String baseUrl,
  }) {
    final id = json['id'];
    if (id is! int) {
      throw const FormatException('ID toko rekomendasi tidak sesuai.');
    }
    return RecommendedStoreModel(
      id: id,
      slug: _requiredString(json, 'slug'),
      name: _requiredString(json, 'name'),
      category: _requiredString(json, 'category'),
      location: _requiredString(json, 'location'),
      status: _requiredString(json, 'status'),
      rating: _number(json['rating']),
      photoUrl: _imageUrl(json['photoUrl'], baseUrl),
    );
  }
}

class FeaturedProductModel extends FeaturedProduct {
  const FeaturedProductModel({
    required super.id,
    required super.name,
    required super.photoUrl,
    required super.storeId,
    required super.storeName,
    required super.description,
    required super.price,
    required super.rating,
    required super.storeRating,
    required super.isAvailable,
  });

  factory FeaturedProductModel.fromJson(
    Map<String, dynamic> json, {
    required String baseUrl,
  }) {
    final id = json['id'];
    final storeId = json['storeId'];
    final rawPrice = json['price'];
    if (id is! int || storeId is! int || rawPrice is! num) {
      throw const FormatException('Data produk pilihan tidak sesuai.');
    }
    return FeaturedProductModel(
      id: id,
      name: _requiredString(json, 'name'),
      photoUrl: _imageUrl(json['photoUrl'], baseUrl),
      storeId: storeId,
      storeName: _requiredString(json, 'storeName'),
      description: _string(json['description']),
      price: rawPrice.toInt(),
      rating: json['rating'] is num ? _number(json['rating']) : null,
      storeRating: _number(json['storeRating']),
      isAvailable: json['isAvailable'] == true,
    );
  }
}

String? _imageUrl(Object? value, String baseUrl) {
  if (value is! String || value.trim().isEmpty) return null;
  final image = value.trim();
  if (image.startsWith('http://') || image.startsWith('https://')) {
    return image;
  }
  if (image.startsWith('/')) return '$baseUrl$image';
  return image;
}

String _requiredString(Map<String, dynamic> json, String field) {
  final value = json[field];
  if (value is! String || value.trim().isEmpty) {
    throw FormatException('Field $field dari server tidak sesuai.');
  }
  return value.trim();
}

String _string(Object? value) => value is String ? value : '';

double _number(Object? value) => value is num ? value.toDouble() : 0;
