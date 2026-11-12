import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';

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
    final rating = json['overallRating'] ?? json['overall_rating'] ?? json['rating'];
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

class MarketReviewApi {
  static http.Client? clientForTesting;

  static Uri _uri(String path, [Map<String, String>? query]) =>
      Uri.parse('${ApiConfig.baseUrl}/api/market-reviews$path').replace(
        queryParameters: query,
      );

  static Future<http.Response> _get(Uri uri) {
    final client = clientForTesting;
    return client == null ? http.get(uri) : client.get(uri);
  }

  static Future<http.Response> _post(
    Uri uri, {
    required Map<String, String> headers,
    required String body,
  }) {
    final client = clientForTesting;
    return client == null
        ? http.post(uri, headers: headers, body: body)
        : client.post(uri, headers: headers, body: body);
  }

  static Future<MarketReviewPage> fetchReviews({
    required int page,
    int limit = 10,
    String filter = 'all',
    String search = '',
  }) async {
    final uri = _uri('/page', {
      'page': '$page',
      'limit': '$limit',
      'filter': filter,
      if (search.trim().isNotEmpty) 'search': search.trim(),
    });
    final response = await _get(uri).timeout(const Duration(seconds: 12));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Gagal mengambil ulasan pasar (${response.statusCode}).',
      );
    }
    final body = jsonDecode(response.body);
    if (body is! Map<String, dynamic>) {
      throw const FormatException('Format daftar ulasan pasar tidak sesuai.');
    }
    return MarketReviewPage.fromJson(body);
  }

  static Future<MarketReviewStatistics> fetchStatistics() async {
    final response = await _get(_uri('/statistics'))
        .timeout(const Duration(seconds: 12));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Gagal mengambil statistik ulasan pasar (${response.statusCode}).',
      );
    }
    final body = jsonDecode(response.body);
    if (body is! Map<String, dynamic> ||
        body['data'] is! Map<String, dynamic>) {
      throw const FormatException('Format statistik ulasan pasar tidak sesuai.');
    }
    return MarketReviewStatistics.fromJson(
      body['data'] as Map<String, dynamic>,
    );
  }

  static Future<void> submitReview({
    required String name,
    required String date,
    required String text,
    required int rating,
  }) async {
    final response = await _post(
      _uri(''),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'date': date,
        'text': text,
        'rating': rating,
      }),
    ).timeout(const Duration(seconds: 12));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      String message = 'Gagal mengirim ulasan pasar (${response.statusCode}).';
      try {
        final body = jsonDecode(response.body);
        if (body is Map && body['error'] is String) {
          message = body['error'] as String;
        }
      } on FormatException {
        // Keep the status-based message for non-JSON responses.
      }
      throw Exception(message);
    }
  }
}

class StoreReviewApi {
  static Uri _uri() =>
      Uri.parse('${ApiConfig.baseUrl}/api/store-reviews');

  static Uri _storeUri(String storeId, [String suffix = '']) => Uri.parse(
    '${ApiConfig.baseUrl}/api/stores/${Uri.encodeComponent(storeId)}/reviews$suffix',
  );

  static Future<List<StoreReview>> fetchDetailReviews() => _fetchReviews();

  static Future<List<StoreReview>> fetchFormReviews() => _fetchReviews();

  static Future<List<StoreReview>> _fetchReviews() async {
    final response = await http
        .get(_uri())
        .timeout(const Duration(seconds: 12));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Gagal mengambil data ulasan toko (${response.statusCode}).',
      );
    }
    final body = jsonDecode(response.body);
    if (body is! List) {
      throw const FormatException('Format data ulasan toko tidak sesuai.');
    }
    return body
        .whereType<Map<String, dynamic>>()
        .map(StoreReview.fromJson)
        .toList();
  }

  static Future<StoreReviewStatistics> fetchStoreStatistics(
    String storeId,
  ) async {
    final response = await http
        .get(_storeUri(storeId, '/statistics'))
        .timeout(const Duration(seconds: 12));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Gagal mengambil statistik ulasan toko (${response.statusCode}).',
      );
    }
    final body = jsonDecode(response.body);
    if (body is! Map<String, dynamic> ||
        body['data'] is! Map<String, dynamic>) {
      throw const FormatException('Format statistik ulasan toko tidak sesuai.');
    }
    return StoreReviewStatistics.fromJson(body['data'] as Map<String, dynamic>);
  }

  static Future<StoreReviewPage> fetchStoreReviews(
    String storeId, {
    String filter = 'all',
    String search = '',
    int page = 1,
    int limit = 20,
  }) async {
    final uri = _storeUri(storeId).replace(
      queryParameters: {
        'filter': filter,
        'page': '$page',
        'limit': '$limit',
        if (search.trim().isNotEmpty) 'search': search.trim(),
      },
    );
    final response = await http
        .get(uri)
        .timeout(const Duration(seconds: 12));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Gagal mengambil daftar ulasan toko (${response.statusCode}).',
      );
    }
    final body = jsonDecode(response.body);
    if (body is! Map<String, dynamic>) {
      throw const FormatException('Format daftar ulasan toko tidak sesuai.');
    }
    return StoreReviewPage.fromJson(body);
  }

  static Future<List<StoreReview>> submitFormReview({
    required String name,
    required String text,
    required int rating,
    String? storeId,
  }) async {
    final response = await http
        .post(
          storeId == null ? _uri() : _storeUri(storeId),
          headers: const {'Content-Type': 'application/json'},
          body: jsonEncode({
            'name': name,
            'date': 'Baru saja • Pembeli Terverifikasi',
            'text': text,
            'rating': rating,
          }),
        )
        .timeout(const Duration(seconds: 12));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      String message = 'Gagal mengirim ulasan (${response.statusCode}).';
      try {
        final decoded = jsonDecode(response.body);
        if (decoded is Map && decoded['error'] is String) {
          message = decoded['error'] as String;
        }
      } on FormatException {
        // Retain the status-based message when the API does not return JSON.
      }
      throw Exception(message);
    }
    final body = jsonDecode(response.body);
    final reviewList = body is Map<String, dynamic> ? body['data'] : body;
    if (reviewList is! List) {
      throw const FormatException('Format respons ulasan toko tidak sesuai.');
    }
    return reviewList
        .whereType<Map<String, dynamic>>()
        .map(StoreReview.fromJson)
        .toList();
  }

  static Future<List<StoreReview>> submitDetailReview({
    required String name,
    required String text,
  }) async {
    final response = await http
        .post(
        _uri(),
          headers: const {'Content-Type': 'application/json'},
          body: jsonEncode({
            'name': name,
            'date': 'Baru saja • Pembeli',
            'text': text,
            'rating': 5,
          }),
        )
        .timeout(const Duration(seconds: 12));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Gagal mengirim ulasan (${response.statusCode}).');
    }
    final body = jsonDecode(response.body);
    if (body is! List) {
      throw const FormatException('Format respons ulasan toko tidak sesuai.');
    }
    return body
        .whereType<Map<String, dynamic>>()
        .map(StoreReview.fromJson)
        .toList();
  }
}
