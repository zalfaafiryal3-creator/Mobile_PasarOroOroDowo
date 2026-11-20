import '../../domain/entities/store.dart';

class StoreModel extends Store {
  const StoreModel({
    required super.id,
    required super.name,
    required super.category,
    required super.displayCategory,
    required super.badge,
    required super.rating,
    required super.products,
    required super.image,
    super.owner,
    super.zone,
    super.status,
    super.openTime,
    super.closeTime,
    super.phone,
    super.description,
    super.productCount,
    super.reviewCount,
    super.catalogProducts,
    super.isLocalFallback,
  });

  factory StoreModel.fromJson(
    Map<String, dynamic> json, {
    required String baseUrl,
    required Store? matchingLocalStore,
  }) {
    final slug = _requiredString(json, 'slug');
    final productCount = _number(json['productCount']).toInt();
    final rawProducts = json['products'];
    final products = rawProducts is List
        ? rawProducts
              .whereType<Map<String, dynamic>>()
              .map(StoreProductModel.fromJson)
              .toList()
        : const <StoreProduct>[];
    final backendImage =
        _nullableString(json['bannerUrl']) ??
        _nullableString(json['logoUrl']) ??
        _nullableString(json['image']) ??
        _nullableString(json['photoUrl']);
    final image = backendImage == null || backendImage.trim().isEmpty
        ? ''
        : backendImage.startsWith('http://') ||
              backendImage.startsWith('https://')
        ? backendImage
        : backendImage.startsWith('/')
        ? '$baseUrl$backendImage'
        : backendImage;
    return StoreModel(
      id: slug,
      name: _requiredString(json, 'name'),
      category: _requiredString(json, 'category'),
      displayCategory: _requiredString(json, 'category'),
      badge: matchingLocalStore?.badge ?? '',
      rating: _number(json['rating']) > 0
          ? _number(json['rating']).toString()
          : '',
      products: '$productCount Produk',
      image: image,
      owner: _string(json['owner']),
      zone: _string(json['zone']),
      status: _string(json['status']),
      openTime: _nullableString(json['openTime']),
      closeTime: _nullableString(json['closeTime']),
      phone: _string(json['phone']),
      description: _string(json['description']),
      productCount: productCount,
      reviewCount: _number(json['reviewCount']).toInt(),
      catalogProducts: products,
      isLocalFallback: false,
    );
  }
}

class StoreProductModel extends StoreProduct {
  const StoreProductModel({
    required super.name,
    required super.price,
    required super.description,
    super.photoUrl,
  });

  factory StoreProductModel.fromJson(Map<String, dynamic> json) {
    final price = json['price'];
    if (price is! num) {
      throw const FormatException('Harga produk dari server tidak sesuai.');
    }
    return StoreProductModel(
      name: _requiredString(json, 'name'),
      price: price.toInt(),
      description: _string(json['description']),
      photoUrl: _nullableString(json['photoUrl']),
    );
  }
}

String _requiredString(Map<String, dynamic> json, String field) {
  final value = json[field];
  if (value is! String || value.trim().isEmpty) {
    throw FormatException('Field $field dari server tidak sesuai.');
  }
  return value.trim();
}

String _string(Object? value) => value is String ? value : '';

String? _nullableString(Object? value) =>
    value is String && value.trim().isNotEmpty ? value.trim() : null;

num _number(Object? value) => value is num ? value : 0;
