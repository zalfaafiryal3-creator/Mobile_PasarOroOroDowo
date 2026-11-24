class Store {
  const Store({
    required this.id,
    required this.name,
    required this.category,
    required this.displayCategory,
    required this.badge,
    required this.rating,
    required this.products,
    required this.image,
    this.categoryId,
    this.owner = '',
    this.zone = '',
    this.status = '',
    this.openTime,
    this.closeTime,
    this.phone = '',
    this.description = '',
    this.productCount = 0,
    this.reviewCount = 0,
    this.catalogProducts = const [],
    this.isLocalFallback = true,
  });

  final String id;
  final String name;
  final String category;
  final String displayCategory;
  final String badge;
  final String rating;
  final String products;
  final String image;
  final int? categoryId;
  final String owner;
  final String zone;
  final String status;
  final String? openTime;
  final String? closeTime;
  final String phone;
  final String description;
  final int productCount;
  final int reviewCount;
  final List<StoreProduct> catalogProducts;
  final bool isLocalFallback;
}

class StoreProduct {
  const StoreProduct({
    required this.name,
    required this.price,
    required this.description,
    this.photoUrl,
  });

  final String name;
  final int price;
  final String description;
  final String? photoUrl;
}

typedef StoreData = Store;
typedef StoreProductData = StoreProduct;
