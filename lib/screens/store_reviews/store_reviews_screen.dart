import 'package:flutter/material.dart';

import '../../data/review_api.dart';
import '../../widgets/market_ui.dart';

class StoreReviewsScreen extends StatefulWidget {
  const StoreReviewsScreen({
    required this.storeId,
    required this.storeName,
    super.key,
  });

  final String storeId;
  final String storeName;

  @override
  State<StoreReviewsScreen> createState() => _StoreReviewsScreenState();
}

class _StoreReviewsScreenState extends State<StoreReviewsScreen> {
  static const _filters = [
    ('all', 'Semua'),
    ('photo', 'Dengan Foto'),
    ('5', 'Bintang 5'),
    ('4', 'Bintang 4'),
    ('1-3', 'Bintang 1–3'),
  ];

  final TextEditingController _searchController = TextEditingController();
  StoreReviewStatistics? _statistics;
  final List<StoreReview> _reviews = [];
  String _filter = 'all';
  String? _error;
  String? _statisticsError;
  bool _loading = true;
  bool _loadingMore = false;
  int _page = 1;
  int _totalCount = 0;
  bool _hasMore = false;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
    _loadReviews(reset: true);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadStatistics() async {
    try {
      final statistics =
          await StoreReviewApi.fetchStoreStatistics(widget.storeId);
      if (mounted) {
        setState(() {
          _statistics = statistics;
          _statisticsError = null;
        });
      }
    } catch (error) {
      if (mounted) setState(() => _statisticsError = error.toString());
    }
  }

  Future<void> _loadReviews({required bool reset}) async {
    if (reset) {
      setState(() {
        _loading = true;
        _error = null;
        _page = 1;
        _reviews.clear();
      });
    } else {
      setState(() => _loadingMore = true);
    }

    try {
      final result = await StoreReviewApi.fetchStoreReviews(
        widget.storeId,
        filter: _filter,
        search: _searchController.text,
        page: reset ? 1 : _page + 1,
      );
      if (!mounted) return;
      setState(() {
        _reviews.addAll(result.reviews);
        _totalCount = result.totalCount;
        _page = result.page;
        _hasMore = _reviews.length < result.totalCount;
        _loading = false;
        _loadingMore = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.toString();
        _loading = false;
        _loadingMore = false;
      });
    }
  }

  int _countFor(String filter) {
    final statistics = _statistics;
    if (statistics == null) return 0;
    return switch (filter) {
      'photo' => statistics.withPhoto,
      '5' => statistics.star5,
      '4' => statistics.star4,
      '1-3' => statistics.star1To3,
      _ => statistics.totalReviews,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MarketColors.canvas,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: MarketColors.ink,
        title: const Text(
          'Review Toko',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 402),
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.storeName,
                      style: const TextStyle(
                        color: MarketColors.ink,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => _loadReviews(reset: true),
                    decoration: InputDecoration(
                      hintText: 'Cari ulasan...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        onPressed: () {
                          _searchController.clear();
                          _loadReviews(reset: true);
                        },
                        icon: const Icon(Icons.close),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 46,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    children: _filters.map((entry) {
                      final (value, label) = entry;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ChoiceChip(
                          label: Text('$label (${_countFor(value)})'),
                          selected: _filter == value,
                          onSelected: (_) {
                            setState(() => _filter = value);
                            _loadReviews(reset: true);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                if (_statisticsError != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Statistik ulasan gagal dimuat: $_statisticsError',
                      style: const TextStyle(
                        color: Color(0xFFB91C1C),
                        fontSize: 12,
                      ),
                    ),
                  ),
                const Divider(height: 1),
                Expanded(
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : _error != null && _reviews.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _error!,
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 12),
                                    OutlinedButton(
                                      onPressed: () {
                                        _loadStatistics();
                                        _loadReviews(reset: true);
                                      },
                                      child: const Text('Coba Lagi'),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : _reviews.isEmpty
                              ? const Center(
                                  child: Text('Belum ada ulasan untuk filter ini.'),
                                )
                              : ListView.separated(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: _reviews.length + (_hasMore ? 1 : 0),
                                  separatorBuilder: (_, _) =>
                                      const SizedBox(height: 12),
                                  itemBuilder: (context, index) {
                                    if (index == _reviews.length) {
                                      return Center(
                                        child: OutlinedButton(
                                          onPressed: _loadingMore
                                              ? null
                                              : () => _loadReviews(reset: false),
                                          child: Text(
                                            _loadingMore
                                                ? 'Memuat...'
                                                : 'Muat Ulasan Lainnya',
                                          ),
                                        ),
                                      );
                                    }
                                    return _ReviewCard(review: _reviews[index]);
                                  },
                                ),
                ),
                if (!_loading && _reviews.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      '${_reviews.length} dari $_totalCount ulasan',
                      style: const TextStyle(color: MarketColors.muted),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});

  final StoreReview review;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  review.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: MarketColors.ink,
                  ),
                ),
              ),
              Text(
                review.date,
                style: const TextStyle(
                  fontSize: 12,
                  color: MarketColors.muted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: List.generate(
              5,
              (index) => Icon(
                index < review.rating ? Icons.star : Icons.star_border,
                size: 18,
                color: const Color(0xFFF59E0B),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(review.text, style: const TextStyle(color: MarketColors.ink)),
          if (review.photos.isNotEmpty) ...[
            const SizedBox(height: 10),
            SizedBox(
              height: 72,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: review.photos.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) => ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    review.photos[index],
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const SizedBox(
                      width: 72,
                      height: 72,
                      child: Icon(Icons.broken_image_outlined),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
