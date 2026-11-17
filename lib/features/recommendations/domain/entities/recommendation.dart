class RecommendedStore {
  const RecommendedStore({
    required this.id,
    required this.slug,
    required this.name,
    required this.category,
    required this.location,
    required this.status,
    required this.rating,
    required this.photoUrl,
  });

  final int id;
  final String slug;
  final String name;
  final String category;
  final String location;
  final String status;
  final double rating;
  final String? photoUrl;
}

class FeaturedProduct {
  const FeaturedProduct({
    required this.id,
    required this.name,
    required this.photoUrl,
    required this.storeId,
    required this.storeName,
    required this.description,
    required this.price,
    required this.rating,
    required this.storeRating,
    required this.isAvailable,
  });

  final int id;
  final String name;
  final String? photoUrl;
  final int storeId;
  final String storeName;
  final String description;
  final int price;
  final double? rating;
  final double storeRating;
  final bool isAvailable;
}
