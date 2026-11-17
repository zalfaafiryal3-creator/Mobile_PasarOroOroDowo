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
  });

  final int totalReviews;
  final int withPhoto;
  final int star5;
  final int star4;
  final int star1To3;
}
