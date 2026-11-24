class MarketReview {
  const MarketReview({
    required this.id,
    required this.name,
    required this.date,
    required this.text,
    required this.rating,
    this.photos = const [],
    this.ratingCleanliness,
    this.ratingVariety,
    this.ratingHospitality,
    this.ratingParking,
  });

  final int id;
  final String name;
  final String date;
  final String text;
  final int rating;
  final List<String> photos;
  final int? ratingCleanliness;
  final int? ratingVariety;
  final int? ratingHospitality;
  final int? ratingParking;

  factory MarketReview.fromJson(Map<String, dynamic> json) {
    final rawPhotos = json['photos'];
    final rating =
        json['overallRating'] ?? json['overall_rating'] ?? json['rating'];

    int? parseAspect(dynamic v) {
      if (v == null) return null;
      final n = (v as num?)?.toInt();
      if (n == null || n < 1 || n > 5) return null;
      return n;
    }

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
      ratingCleanliness:
          parseAspect(json['ratingCleanliness'] ?? json['rating_cleanliness']),
      ratingVariety:
          parseAspect(json['ratingVariety'] ?? json['rating_variety']),
      ratingHospitality: parseAspect(
        json['ratingHospitality'] ?? json['rating_hospitality'],
      ),
      ratingParking:
          parseAspect(json['ratingParking'] ?? json['rating_parking']),
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
    this.averageRating = 0.0,
    this.aspectCleanliness = 0.0,
    this.aspectVariety = 0.0,
    this.aspectHospitality = 0.0,
    this.aspectParking = 0.0,
  });

  final int totalReviews;
  final int withPhoto;
  final int star5;
  final int star4;
  final int star1To3;
  final double averageRating;
  final double aspectCleanliness;
  final double aspectVariety;
  final double aspectHospitality;
  final double aspectParking;

  factory MarketReviewStatistics.fromJson(Map<String, dynamic> json) {
    double safeDouble(dynamic v) {
      if (v == null) return 0.0;
      final d = (v as num).toDouble();
      return d.isNaN || d.isInfinite ? 0.0 : d;
    }

    return MarketReviewStatistics(
      totalReviews: (json['total_reviews'] as num?)?.toInt() ?? 0,
      withPhoto: (json['with_photo'] as num?)?.toInt() ?? 0,
      star5: (json['star_5'] as num?)?.toInt() ?? 0,
      star4: (json['star_4'] as num?)?.toInt() ?? 0,
      star1To3: (json['star_1_3'] as num?)?.toInt() ?? 0,
      averageRating: safeDouble(json['average_rating']),
      aspectCleanliness: safeDouble(json['aspect_cleanliness']),
      aspectVariety: safeDouble(json['aspect_variety']),
      aspectHospitality: safeDouble(json['aspect_hospitality']),
      aspectParking: safeDouble(json['aspect_parking']),
    );
  }
}
