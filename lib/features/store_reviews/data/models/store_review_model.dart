class StoreReview {
  const StoreReview({
    required this.id,
    required this.name,
    required this.date,
    required this.text,
    required this.rating,
    this.photos = const [],
  });

  final int id;
  final String name;
  final String date;
  final String text;
  final int rating;
  final List<String> photos;

  factory StoreReview.fromJson(Map<String, dynamic> json) {
    return StoreReview(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? 'Anonim',
      date: json['date']?.toString() ?? '',
      text: json['text']?.toString() ?? '',
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      photos: (json['photos'] is List ? json['photos'] as List : const [])
          .whereType<Map<String, dynamic>>()
          .map((photo) => photo['url']?.toString() ?? '')
          .where((url) => url.isNotEmpty)
          .toList(),
    );
  }
}

class StoreReviewStatistics {
  const StoreReviewStatistics({
    required this.totalReviews,
    required this.withPhoto,
    required this.star5,
    required this.star4,
    required this.star1To3,
  });

  final int totalReviews;
  final int withPhoto;
  final int star5;
  final int star4;
  final int star1To3;

  factory StoreReviewStatistics.fromJson(Map<String, dynamic> json) =>
      StoreReviewStatistics(
        totalReviews: (json['total_reviews'] as num?)?.toInt() ?? 0,
        withPhoto: (json['with_photo'] as num?)?.toInt() ?? 0,
        star5: (json['star_5'] as num?)?.toInt() ?? 0,
        star4: (json['star_4'] as num?)?.toInt() ?? 0,
        star1To3: (json['star_1_3'] as num?)?.toInt() ?? 0,
      );
}

class StoreReviewPage {
  const StoreReviewPage({
    required this.reviews,
    required this.totalCount,
    required this.currentPageCount,
    required this.page,
    required this.limit,
  });

  final List<StoreReview> reviews;
  final int totalCount;
  final int currentPageCount;
  final int page;
  final int limit;

  factory StoreReviewPage.fromJson(Map<String, dynamic> json) {
    final rawReviews = json['data'];
    if (rawReviews is! List) {
      throw const FormatException('Format daftar ulasan toko tidak sesuai.');
    }
    return StoreReviewPage(
      reviews: rawReviews
          .whereType<Map<String, dynamic>>()
          .map(StoreReview.fromJson)
          .toList(),
      totalCount: (json['total_count'] as num?)?.toInt() ?? 0,
      currentPageCount: (json['current_page_count'] as num?)?.toInt() ?? 0,
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 20,
    );
  }
}
