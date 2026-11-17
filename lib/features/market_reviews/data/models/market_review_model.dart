class MarketReview {
  const MarketReview({
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

  factory MarketReview.fromJson(Map<String, dynamic> json) {
    final rawPhotos = json['photos'];
    final rating =
        json['overallRating'] ?? json['overall_rating'] ?? json['rating'];
    return MarketReview(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? 'Anonim',
      date: json['date']?.toString() ?? '',
      text: json['text']?.toString() ?? '',
      rating: (rating as num?)?.toInt() ?? 0,
      photos: (rawPhotos is List ? rawPhotos : const [])
          .whereType<Map<String, dynamic>>()
          .map((photo) => photo['url']?.toString() ?? '')
          .where((url) => url.isNotEmpty)
          .toList(),
    );
  }
}

class MarketReviewPage {
  const MarketReviewPage({
    required this.reviews,
    required this.totalCount,
    required this.page,
    required this.limit,
  });

  final List<MarketReview> reviews;
  final int totalCount;
  final int page;
  final int limit;

  factory MarketReviewPage.fromJson(Map<String, dynamic> json) {
    final rawReviews = json['data'];
    if (rawReviews is! List) {
      throw const FormatException('Format daftar ulasan pasar tidak sesuai.');
    }
    return MarketReviewPage(
      reviews: rawReviews
          .whereType<Map<String, dynamic>>()
          .map(MarketReview.fromJson)
          .toList(),
      totalCount: (json['total_count'] as num?)?.toInt() ?? 0,
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 10,
    );
  }
}

class MarketReviewStatistics {
  const MarketReviewStatistics({
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

  factory MarketReviewStatistics.fromJson(Map<String, dynamic> json) =>
      MarketReviewStatistics(
        totalReviews: (json['total_reviews'] as num?)?.toInt() ?? 0,
        withPhoto: (json['with_photo'] as num?)?.toInt() ?? 0,
        star5: (json['star_5'] as num?)?.toInt() ?? 0,
        star4: (json['star_4'] as num?)?.toInt() ?? 0,
        star1To3: (json['star_1_3'] as num?)?.toInt() ?? 0,
      );
}
