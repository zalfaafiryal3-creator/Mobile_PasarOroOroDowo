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

  /// Nilai aspek per ulasan (1–5) jika dipilih pengguna; null jika tidak dipilih / data lama.
  final int? ratingCleanliness;
  final int? ratingVariety;
  final int? ratingHospitality;
  final int? ratingParking;

  List<String> get selectedAspectLabels {
    bool valid(int? v) => v != null && v >= 1 && v <= 5;
    return <String>[
      if (valid(ratingCleanliness)) 'Kebersihan',
      if (valid(ratingHospitality)) 'Keramahan',
      if (valid(ratingParking)) 'Parkir Tertata',
      if (valid(ratingVariety)) 'Kelengkapan Komoditas',
    ];
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

  /// Rata-rata rating ulasan pasar secara keseluruhan (skala 1–5, 0.0 jika belum ada ulasan)
  final double averageRating;

  /// Rata-rata aspek Kebersihan & Kerapian (skala 1–5, 0.0 jika belum ada ulasan)
  final double aspectCleanliness;

  /// Rata-rata aspek Kelengkapan Komoditas (skala 1–5)
  final double aspectVariety;

  /// Rata-rata aspek Keramahan Pedagang (skala 1–5)
  final double aspectHospitality;

  /// Rata-rata aspek Keamanan & Parkir (skala 1–5)
  final double aspectParking;
}
