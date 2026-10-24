import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../data/review_api.dart';
import '../widgets/market_ui.dart';

class _MarketReviewPreview {
  _MarketReviewPreview({
    required this.name,
    required this.rating,
    required this.date,
    required this.text,
    required this.helpfulIndex,
    this.helpfulCount = 0,
    this.tags = const [],
    this.photos = const [],
  });

  final String name;
  final int rating;
  final String date;
  final String text;
  final int helpfulIndex;
  int helpfulCount;
  final List<String> tags;
  final List<String> photos;
}
void addGlobalMarketReview({
  required String name,
  required int rating,
  required String text,
  List<String> tags = const [],
  List<String> photos = const [],
}) {
  final newReview = _MarketReviewPreview(
    name: name.isEmpty ? 'Pengunjung Pasar' : name,
    rating: rating,
    date: 'Baru saja',
    text: text,
    helpfulIndex: _globalMarketReviews.length,
    helpfulCount: 0,
    tags: tags.isNotEmpty ? tags : ['Ulasan Pengunjung'],
    photos: photos,
  );
  _globalMarketReviews.insert(0, newReview);
}

final List<_MarketReviewPreview> _globalMarketReviews = [
  _MarketReviewPreview(
    name: 'ZALFAA',
    rating: 5,
    date: 'Kemarin',
    text:
        'Pasar tradisional paling bersih dan estetik di Malang! Lorongnya luas, tidak becek sama sekali, dan belanja sayur segar sampai jajanan di sini nyaman banget. Pedagangnya juga ramah-ramah.',
    helpfulIndex: 0,
    helpfulCount: 34,
    tags: ['Kebersihan: Luar Biasa', 'Parkir: Tertata'],
    photos: ['2312e.png', 'e576e.png'],
  ),
  _MarketReviewPreview(
    name: 'Rani',
    rating: 5,
    date: '3 hari lalu',
    text:
        'Sekarang makin modern, sudah banyak kios yang terima pembayaran QRIS. Kuliner legendaris di bagian belakang juga lengkap dan enak. Wajib cobain kue lumpur dan mie ayamnya!',
    helpfulIndex: 1,
    helpfulCount: 19,
  ),
  _MarketReviewPreview(
    name: 'Mifta',
    rating: 4,
    date: '1 minggu lalu',
    text:
        'Tempatnya asri dan bersih. Parkir motor dan mobil tertata rapi. Kalau pagi hari sekitar jam 7-8 cukup ramai tapi arus belanjanya tetap teratur karena lorongnya satu arah.',
    helpfulIndex: 2,
    helpfulCount: 8,
  ),
  _MarketReviewPreview(
    name: 'Budi Santoso',
    rating: 5,
    date: '2 minggu lalu',
    text:
        'Pasar rakyat yang sangat bersih dan terawat dengan baik. Aneka kue basah dan jajanan tradisionalnya juara! Sangat nyaman berbelanja pagi bersama keluarga.',
    helpfulIndex: 3,
    helpfulCount: 12,
  ),
  _MarketReviewPreview(
    name: 'Siti Aminah',
    rating: 4,
    date: '3 minggu lalu',
    text:
        'Pedagang sayur dan buah sangat ramah dan timbangannya pas. Tempat belanja andalan keluarga setiap akhir pekan.',
    helpfulIndex: 4,
    helpfulCount: 7,
  ),
  _MarketReviewPreview(
    name: 'Hendra Wijaya',
    rating: 5,
    date: '1 bulan lalu',
    text:
        'Toilet bersih, mushola nyaman di lantai atas. Suasana pasar tidak bau dan sirkulasi udaranya sejuk. Parkir juga aman dan teratur.',
    helpfulIndex: 5,
    helpfulCount: 15,
  ),
];

class MarketReviewsScreen extends StatefulWidget {
  const MarketReviewsScreen({super.key});

  @override
  State<MarketReviewsScreen> createState() => _MarketReviewsScreenState();
}

class _MarketReviewsScreenState extends State<MarketReviewsScreen> {
  final _searchController = TextEditingController();
  String _filter = 'all';
  bool _newestFirst = true;
  int _visibleCount = 3;

  List<_MarketReviewPreview> get _filteredReviews {
    final query = _searchController.text.trim().toLowerCase();
    final reviews = _globalMarketReviews.where((review) {
      final matchesFilter = switch (_filter) {
        'photo' => review.photos.isNotEmpty,
        '5' => review.rating == 5,
        '4' => review.rating >= 4 && review.rating < 5,
        'low' => review.rating < 4,
        _ => true,
      };
      final matchesQuery =
          '${review.name} ${review.text}'.toLowerCase().contains(query);
      return matchesFilter && matchesQuery;
    }).toList();
    if (!_newestFirst) return reviews.reversed.toList();
    return reviews;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredReviews;
    final displayedReviews = filtered.take(_visibleCount).toList();

    return MarketPage(
      background: const Color(0xFFF0F6DF),
      child: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 105),
            children: [
              // 1. Header: Brand Logo + Nama Pasar (standard Home & Toko)
              const BrandHeader(),
              const SizedBox(height: 14),

              // Title & Subtitle
              const Text(
                'Review & Ulasan',
                style: TextStyle(
                  color: Color(0xFF594045),
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Pasar Oro-Oro Dowo, Malang',
                style: TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 14),

              // Search Bar: Kapsul putih dengan border halus
              Container(
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: const Color(0x55B8D66D),
                    width: 1.2,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x10000000),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(fontSize: 13, color: MarketColors.ink),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: Color(0xFF9CA3AF),
                      size: 22,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.close_rounded,
                              size: 18,
                              color: Color(0xFF9CA3AF),
                            ),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    hintText: 'Cari review pasar...',
                    hintStyle: const TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF9CA3AF),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 2. Card Ringkasan Rating Pasar
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x18594045),
                      blurRadius: 16,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Identitas Pasar & Foto
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF7ED),
                                  border: Border.all(
                                    color: const Color(0xFFFDBA74),
                                  ),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: const FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.storefront_outlined,
                                        size: 12,
                                        color: Color(0xFFD97706),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Pasar Wisata Cagar Budaya',
                                        style: TextStyle(
                                          color: Color(0xFFD97706),
                                          fontSize: 9.5,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Pasar Oro-Oro Dowo',
                                style: TextStyle(
                                  color: Color(0xFF594045),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 3),
                              const Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 13,
                                    color: Color(0xFFD97706),
                                  ),
                                  SizedBox(width: 2),
                                  Expanded(
                                    child: Text(
                                      'Klojen, Kota Malang, Jawa Timur',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Color(0xFF6B7280),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: const SizedBox(
                            width: 68,
                            height: 56,
                            child: MarketAsset(
                              '204f2.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Highlight Rating Box
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2F0C2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x10000000),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  '4.8',
                                  style: TextStyle(
                                    color: Color(0xFF526B31),
                                    fontSize: 26,
                                    fontWeight: FontWeight.w900,
                                    height: 1,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: List.generate(
                                    5,
                                    (_) => const Icon(
                                      Icons.star_rounded,
                                      size: 13,
                                      color: Color(0xFFFFC928),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sangat Direkomendasikan',
                                  style: TextStyle(
                                    color: Color(0xFF526B31),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Dari 1.240+ ulasan terverifikasi',
                                  style: TextStyle(
                                    color: Color(0xFF526B31),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  '(98% pengunjung puas)',
                                  style: TextStyle(
                                    color: Color(0xFF526B31),
                                    fontSize: 9.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Aspect Ratings
                    const _ReviewAspectRow(
                      icon: Icons.person_outline_rounded,
                      label: 'Kebersihan & Kerapian',
                      rating: '4.9',
                      progress: 0.98,
                      color: Color(0xFFB8D66D),
                    ),
                    const _ReviewAspectRow(
                      icon: Icons.shopping_basket_outlined,
                      label: 'Kelengkapan Komoditas',
                      rating: '4.8',
                      progress: 0.95,
                      color: Color(0xFFF59E0B),
                    ),
                    const _ReviewAspectRow(
                      icon: Icons.sentiment_satisfied_outlined,
                      label: 'Keramahan Pedagang',
                      rating: '4.9',
                      progress: 0.98,
                      color: Color(0xFFFBBF24),
                    ),
                    const _ReviewAspectRow(
                      icon: Icons.local_parking_rounded,
                      label: 'Keamanan & Parkir',
                      rating: '4.6',
                      progress: 0.88,
                      color: Color(0xFF594045),
                    ),
                    const SizedBox(height: 14),

                    // Tombol Kuning: Tulis Ulasan Pasar
                    Container(
                      width: double.infinity,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFC928),
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x35FFC928),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () =>
                            goTo(context, '/tulis-ulasan-pasar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFC928),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.rate_review_outlined,
                              size: 18,
                              color: Colors.white,
                            ),
                            SizedBox(width: 6),
                            Text(
                              '+ Tulis Ulasan Pasar',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // 3. Card Ajakan Menulis Ulasan (UMKM)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2F0C2),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0x60B8D66D)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x10000000),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.toll_rounded,
                        color: Color(0xFFD97706),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ulasan Anda Menghidupkan UMKM',
                            style: TextStyle(
                              color: Color(0xFF594045),
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Ulasan jujur membantu kemajuan kebersihan dan mengangkat 251+ lapak pasar kita.',
                            style: TextStyle(
                              color: Color(0xFF526B31),
                              fontSize: 9.5,
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // 4. Bagian "Semua Ulasan" & Sort Control
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'Semua Ulasan',
                      style: TextStyle(
                        color: Color(0xFF594045),
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => setState(() => _newestFirst = !_newestFirst),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _newestFirst ? 'Urutkan: Terbaru' : 'Urutkan: Terlama',
                          style: const TextStyle(
                            color: Color(0xFF594045),
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 14,
                          color: Color(0xFF594045),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Filter Chips Kapsul
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _filterChip(
                      label: 'Semua (1.2k)',
                      value: 'all',
                    ),
                    const SizedBox(width: 6),
                    _filterChip(
                      label: 'Dengan Foto (1)',
                      value: 'photo',
                      icon: Icons.camera_alt_outlined,
                    ),
                    const SizedBox(width: 6),
                    _filterChip(
                      label: 'Bintang 5 (2)',
                      value: '5',
                      icon: Icons.star_rounded,
                    ),
                    const SizedBox(width: 6),
                    _filterChip(
                      label: 'Bintang 4 (1)',
                      value: '4',
                      icon: Icons.star_rounded,
                    ),
                    const SizedBox(width: 6),
                    _filterChip(
                      label: 'Bintang 1-3 (0)',
                      value: 'low',
                      icon: Icons.star_rounded,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // 5. Daftar Card Ulasan Pengunjung
              if (displayedReviews.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(28),
                  child: Text(
                    'Tidak ada ulasan yang cocok.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: MarketColors.muted,
                      fontSize: 12,
                    ),
                  ),
                )
              else
                ...displayedReviews.map(_reviewCard),

              // 6. Tombol "Muat Ulasan Lainnya"
              if (filtered.length > _visibleCount) ...[
                const SizedBox(height: 14),
                Center(
                  child: InkWell(
                    onTap: () => setState(() => _visibleCount += 3),
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: const Color(0xFFFFC928),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x10000000),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Muat Ulasan Lainnya',
                            style: TextStyle(
                              color: Color(0xFFD97706),
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 16,
                            color: Color(0xFFD97706),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),

          // 7. Floating Bottom Navigation
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: _marketBottomNavigation(context),
          ),
        ],
      ),
    );
  }

  Widget _filterChip({
    required String label,
    required String value,
    IconData? icon,
  }) {
    final selected = _filter == value;
    return GestureDetector(
      onTap: () => setState(() {
        _filter = value;
        _visibleCount = 3;
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFC928) : const Color(0xFFE2F0C2),
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            if (selected)
              const BoxShadow(
                color: Color(0x25FFC928),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 13,
                color: selected ? Colors.white : const Color(0xFF526B31),
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : const Color(0xFF526B31),
                fontSize: 11,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _reviewCard(_MarketReviewPreview review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12594045),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User profile row
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: const Color(0xFFE2F0C2),
                child: Text(
                  review.name.isNotEmpty ? review.name[0].toUpperCase() : 'U',
                  style: const TextStyle(
                    color: Color(0xFF526B31),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  review.name,
                  style: const TextStyle(
                    color: Color(0xFF594045),
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Icon(
                Icons.more_vert_rounded,
                size: 18,
                color: Color(0xFF9CA3AF),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Rating stars & date
          Row(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  5,
                  (i) => Icon(
                    i < review.rating
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    size: 14,
                    color: const Color(0xFFFFC928),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '${review.rating}.0',
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF594045),
                ),
              ),
              const Spacer(),
              Text(
                review.date,
                style: const TextStyle(
                  fontSize: 9.5,
                  color: Color(0xFF9CA3AF),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          // Tags row
          if (review.tags.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: review.tags.map((tag) {
                final isParking = tag.toLowerCase().contains('parkir');
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 3.5,
                  ),
                  decoration: BoxDecoration(
                    color: isParking
                        ? const Color(0xFFFEF3C7)
                        : const Color(0xFFDCFCE7),
                    border: Border.all(
                      color: isParking
                          ? const Color(0xFFFDE68A)
                          : const Color(0xFF86EFAC),
                    ),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      color: isParking
                          ? const Color(0xFFD97706)
                          : const Color(0xFF15803D),
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: 8),

          // Review text
          Text(
            review.text,
            style: const TextStyle(
              color: Color(0xFF1F2937),
              fontSize: 11,
              height: 1.45,
            ),
          ),

          // Photos thumbnail row
          if (review.photos.isNotEmpty) ...[
            const SizedBox(height: 8),
            SizedBox(
              height: 80,
              child: Row(
                children: review.photos.map((photo) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: MarketAsset(
                          photo,
                          fit: BoxFit.cover,
                          height: 80,
                          width: double.infinity,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
          const SizedBox(height: 8),

          // Helpful button
          InkWell(
            onTap: () => setState(() => review.helpfulCount++),
            borderRadius: BorderRadius.circular(999),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                border: Border.all(color: const Color(0xFFE5E7EB)),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.thumb_up_alt_outlined,
                    size: 12,
                    color: Color(0xFF594045),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Membantu (${review.helpfulCount})',
                    style: const TextStyle(
                      color: Color(0xFF594045),
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _marketBottomNavigation(BuildContext context) {
    const items = <(String, String, String)>[
      ('Home', '/home', 'dfd0c.svg'),
      ('Toko', '/toko', '2781e.svg'),
      ('Promo', '/promo', '75326.svg'),
      ('Review Pasar', '/review-pasar', '3de6e.svg'),
    ];
    return Container(
      height: 68,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: const Color(0xFFC2DC80), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x20C2DC80),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items.map((item) {
          final active = item.$1 == 'Review Pasar';
          return InkWell(
            onTap: () => goTo(context, item.$2),
            borderRadius: BorderRadius.circular(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: active
                        ? const Color(0xFFC2DC80).withValues(alpha: 0.5)
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: MarketAsset(
                    item.$3,
                    width: item.$1 == 'Home'
                        ? 16
                        : item.$1 == 'Promo'
                            ? 22
                            : 20,
                    height: item.$1 == 'Home'
                        ? 16
                        : item.$1 == 'Promo'
                            ? 22
                            : 20,
                    color: active
                        ? const Color(0xFF4B6515)
                        : const Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.$1,
                  style: TextStyle(
                    color: active
                        ? const Color(0xFF4B6515)
                        : const Color(0xFF9CA3AF),
                    fontSize: item.$1 == 'Review Pasar' ? 9 : 10,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ReviewAspectRow extends StatelessWidget {
  const _ReviewAspectRow({
    required this.icon,
    required this.label,
    required this.rating,
    required this.progress,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String rating;
  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, size: 13, color: color),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF594045),
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    rating,
                    style: const TextStyle(
                      color: Color(0xFF1F2937),
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(
                    Icons.star_rounded,
                    size: 11,
                    color: Color(0xFFFFC928),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 3),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: const Color(0xFFE5E7EB),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}

class WriteMarketReviewScreen extends StatefulWidget {
  const WriteMarketReviewScreen({super.key});

  @override
  State<WriteMarketReviewScreen> createState() =>
      _WriteMarketReviewScreenState();
}

class _WriteMarketReviewScreenState extends State<WriteMarketReviewScreen> {
  final _nameController = TextEditingController();
  final _experienceController = TextEditingController();
  final _picker = ImagePicker();
  final Map<String, int> _ratings = {
    'Kebersihan & Kerapian': 5,
    'Kelengkapan Komoditas': 5,
    'Keramahan Pedagang': 5,
    'Keamanan & Parkir': 5,
  };
  final List<XFile> _photos = [];
  int _rating = 5;
  String _selectedAspect = 'Semua';
  bool _umkm = true;
  bool _sending = false;
  String? _error;

  static const _aspects = <(String, String, IconData)>[
    ('Kebersihan', 'Kebersihan & Kerapian', Icons.cleaning_services),
    ('Keramahan', 'Keramahan Pedagang', Icons.sentiment_satisfied_alt),
    ('Parkir Tertata', 'Keamanan & Parkir', Icons.local_parking),
    ('Kelengkapan Komoditas', 'Kelengkapan Komoditas', Icons.inventory_2),
  ];

  static const _ratingLabels = {
    1: 'Sangat Kecewa',
    2: 'Kurang Puas',
    3: 'Cukup Baik',
    4: 'Puas! / Direkomendasikan',
    5: 'Sangat Puas! / Sangat Direkomendasikan',
  };

  @override
  void dispose() {
    _nameController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  Future<void> _pickPhotos() async {
    final remaining = 2 - _photos.length;
    if (remaining <= 0) return;
    try {
      final selected = await _picker.pickMultiImage(
        limit: remaining,
        imageQuality: 85,
      );
      if (selected.isNotEmpty && mounted) {
        setState(() => _photos.addAll(selected.take(remaining)));
      }
    } on Exception catch (error) {
      if (mounted) setState(() => _error = 'Foto tidak dapat dipilih: $error');
    }
  }

  void _selectOverallRating(int value) {
    setState(() {
      _rating = value;
      for (final key in _ratings.keys.toList()) {
        _ratings[key] = value;
      }
    });
  }

  void _toggleAspect(String title, String category) {
    setState(() {
      _selectedAspect = title;
      final current = _ratings[category] ?? 5;
      _ratings[category] = current == 1 ? 5 : current - 1;
    });
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    final text = _experienceController.text.trim();
    if (text.isEmpty) {
      setState(() => _error = 'Mohon isi komentar atau ulasan pengalaman Anda.');
      return;
    }

    setState(() {
      _sending = true;
      _error = null;
    });

    await Future.delayed(const Duration(milliseconds: 300));

    final newReview = _MarketReviewPreview(
      name: name.isEmpty ? 'Pengunjung Pasar' : name,
      rating: _rating,
      date: 'Baru saja',
      text: text,
      helpfulIndex: _globalMarketReviews.length,
      helpfulCount: 0,
      tags: _selectedAspect.isNotEmpty && _selectedAspect != 'Semua'
          ? ['Aspek: $_selectedAspect']
          : ['Ulasan Pengunjung'],
      photos: _photos.map((p) => p.name).toList(),
    );

    _globalMarketReviews.insert(0, newReview);

    if (mounted) {
      setState(() {
        _sending = false;
        _error = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ulasan Anda berhasil dikirim dan ditambahkan!'),
          duration: Duration(seconds: 2),
        ),
      );
      goBack(context, fallback: '/review-pasar');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MarketPage(
      child: Column(
        children: [
          PageTitleBar(
            title: 'Tulis Ulasan Pasar',
            subtitle: 'Pasar Oro-Oro Dowo, Malang',
            onBack: () => goBack(context, fallback: '/review-pasar'),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              children: [
                _marketIdentityCard(),
                const SizedBox(height: 10),
                _ratingCard(),
                const SizedBox(height: 10),
                _aspectCard(),
                const SizedBox(height: 10),
                _nameCard(),
                const SizedBox(height: 10),
                _experienceCard(),
                const SizedBox(height: 10),
                _photoCard(),
                const SizedBox(height: 10),
                _umkmCard(),
                if (_error != null) ...[
                  const SizedBox(height: 9),
                  ErrorNotice(_error!),
                ],
                const SizedBox(height: 10),
                PrimaryMarketButton(
                  label: _sending ? 'Mengirim...' : 'Kirim Ulasan Pasar',
                  icon: Icons.chevron_right,
                  onPressed: _sending ? () {} : _submit,
                ),
              ],
            ),
          ),
          const BottomNavigation(active: 'Review Pasar'),
        ],
      ),
    );
  }

  Widget _marketIdentityCard() {
    return RoundedCard(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: const MarketAsset(
              '204f2.png',
              width: 96,
              height: 76,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _BadgeText('Pasar Tradisional'),
                SizedBox(height: 6),
                Text(
                  'Pasar Oro-Oro Dowo',
                  style: TextStyle(
                    color: MarketColors.ink,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  '★ 4.8  •  Ulasan pengunjung',
                  style: TextStyle(
                    color: MarketColors.yellow,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _ratingCard() {
    return RoundedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Beri Penilaian Anda',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 3),
          const Text(
            'Bagikan pengalaman kunjungan Anda ke pasar ini',
            style: TextStyle(fontSize: 10, color: MarketColors.muted),
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(5, (index) {
              final value = index + 1;
              return IconButton(
                onPressed: () => _selectOverallRating(value),
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.all(4),
                icon: Icon(
                  value <= _rating ? Icons.star : Icons.star_border,
                  color: MarketColors.yellow,
                  size: 27,
                ),
              );
            }),
          ),
          Text(
            '●  ${_ratingLabels[_rating]}',
            style: const TextStyle(
              color: MarketColors.greenDark,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _aspectCard() {
    return RoundedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PENILAIAN ASPEK PASAR',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 3),
          const Text(
            'Pilih aspek unggulan yang Anda rasakan',
            style: TextStyle(color: MarketColors.muted, fontSize: 10),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _aspects.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              mainAxisExtent: 53,
            ),
            itemBuilder: (context, index) {
              final aspect = _aspects[index];
              final selected = aspect.$1 == _selectedAspect;
              return Material(
                color: selected
                    ? const Color(0xFFFFE3EB)
                    : const Color(0xFFF8F5F3),
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => _toggleAspect(aspect.$1, aspect.$2),
                  child: Row(
                    children: [
                      const SizedBox(width: 9),
                      Icon(aspect.$3, size: 17, color: MarketColors.pink),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          aspect.$1,
                          maxLines: 2,
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        '${_ratings[aspect.$2]}★',
                        style: const TextStyle(
                          color: MarketColors.yellow,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _nameCard() {
    return RoundedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nama Pengunjung / Penulis',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _nameController,
            decoration: _inputDecoration('Masukkan nama', Icons.person_outline),
          ),
        ],
      ),
    );
  }

  Widget _experienceCard() {
    return RoundedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Ceritakan Pengalaman Anda',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                '${_experienceController.text.length}/500',
                style: const TextStyle(color: MarketColors.muted, fontSize: 9),
              ),
            ],
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _experienceController,
            maxLength: 500,
            minLines: 4,
            maxLines: 5,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              hintText: 'Bagikan pengalaman kamu tentang pasar ini...',
              hintStyle: TextStyle(fontSize: 10, color: Color(0xFF9CA3AF)),
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(10),
              counterText: '',
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '✓ Ulasan membantu orang lain',
            style: TextStyle(
              color: MarketColors.greenDark,
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _photoCard() {
    return RoundedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Tambah Foto Kunjungan (Opsional)',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                '${_photos.length}/2 Terpilih',
                style: const TextStyle(color: MarketColors.muted, fontSize: 9),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (_photos.length < 2)
                InkWell(
                  onTap: _pickPhotos,
                  child: Container(
                    width: 72,
                    height: 70,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F5F3),
                      border: Border.all(color: const Color(0x33D56989)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: MarketColors.pink),
                        Text(
                          '+ Foto',
                          style: TextStyle(
                            color: MarketColors.pink,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ..._photos.asMap().entries.map(
                (entry) => Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(entry.value.path),
                        width: 72,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          width: 72,
                          height: 70,
                          color: const Color(0xFFF3EEF1),
                          child: const Icon(Icons.photo),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 1,
                      top: 1,
                      child: IconButton(
                        onPressed: () =>
                            setState(() => _photos.removeAt(entry.key)),
                        icon: const Icon(Icons.close, size: 13),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          minimumSize: const Size(22, 22),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _umkmCard() {
    return RoundedCard(
      child: Row(
        children: [
          const Icon(Icons.storefront, color: MarketColors.pink, size: 19),
          const SizedBox(width: 9),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ulasan Anda Menghidupkan UMKM',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 3),
                Text(
                  'Ulasan jujur Anda sangat membantu menjaga kualitas layanan pasar serta mendukung pedagang lokal.',
                  style: TextStyle(
                    color: MarketColors.muted,
                    fontSize: 9,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: _umkm,
            activeTrackColor: MarketColors.green,
            onChanged: (value) => setState(() => _umkm = value),
          ),
        ],
      ),
    );
  }
}

class LegacyWriteStoreReviewScreen extends StatefulWidget {
  const LegacyWriteStoreReviewScreen({super.key});

  @override
  State<LegacyWriteStoreReviewScreen> createState() => _LegacyWriteStoreReviewScreenState();
}

class _LegacyWriteStoreReviewScreenState extends State<LegacyWriteStoreReviewScreen> {
  final _nameController = TextEditingController();
  final _experienceController = TextEditingController();
  final _picker = ImagePicker();
  final List<XFile> _photos = [];
  int _rating = 5;
  int? _reviewCount;
  bool _showBadge = true;
  bool _sending = false;
  bool _submitted = false;
  String? _error;

  static const _ratingLabels = {
    1: 'Sangat Kecewa',
    2: 'Kurang Puas',
    3: 'Cukup Baik',
    4: 'Puas! / Direkomendasikan',
    5: 'Sangat Puas! / Sangat Direkomendasikan',
  };

  @override
  void initState() {
    super.initState();
    StoreReviewApi.fetchFormReviews()
        .then((reviews) {
          if (mounted) setState(() => _reviewCount = reviews.length);
        })
        .catchError((Object error) {
          if (mounted) {
            setState(() {
              _error =
                  'Gagal mengambil data ulasan toko dari API :4000: $error';
              _reviewCount = 0;
            });
          }
        });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  Future<void> _pickPhotos() async {
    final remaining = 2 - _photos.length;
    if (remaining <= 0) return;
    try {
      final selected = await _picker.pickMultiImage(
        limit: remaining,
        imageQuality: 85,
      );
      if (selected.isNotEmpty && mounted) {
        setState(() => _photos.addAll(selected.take(remaining)));
      }
    } on Exception catch (error) {
      if (mounted) setState(() => _error = 'Foto tidak dapat dipilih: $error');
    }
  }

  Future<void> _submit() async {
    setState(() {
      _error = null;
      _sending = true;
    });
    try {
      final reviews = await StoreReviewApi.submitFormReview(
        name: _nameController.text.trim().isEmpty
            ? 'Anonim'
            : _nameController.text.trim(),
        text: _experienceController.text.trim().isEmpty
            ? 'Pengunjung belum menambahkan cerita.'
            : _experienceController.text.trim(),
        rating: _rating,
      );
      if (!mounted) return;
      setState(() {
        _reviewCount = reviews.length;
        _submitted = true;
      });
      await Future<void>.delayed(const Duration(milliseconds: 900));
      if (mounted) {
        Navigator.of(context)
            .pushReplacementNamed('/detail-toko/lumpur-kentang-27');
      }
    } catch (error) {
      if (mounted) {
        setState(() => _error = 'Gagal mengirim ulasan toko: $error');
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MarketPage(
      child: Column(
        children: [
          PageTitleBar(
            title: 'Tulis Ulasan Toko',
            subtitle: 'Pasar Oro-Oro Dowo, Malang',
            onBack: () => goTo(context, '/detail-toko/lumpur-kentang-27'),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              children: [
                _storeIdentity(),
                const SizedBox(height: 10),
                _ratingSection(),
                const SizedBox(height: 10),
                _nameSection(),
                const SizedBox(height: 10),
                _experienceSection(),
                const SizedBox(height: 10),
                _photoSection(),
                const SizedBox(height: 10),
                _supportSection(),
                if (_error != null) ...[
                  const SizedBox(height: 9),
                  ErrorNotice(_error!),
                ],
                const SizedBox(height: 10),
                PrimaryMarketButton(
                  label: _submitted
                      ? 'Ulasan Terkirim'
                      : _sending
                      ? 'Mengirim...'
                      : 'Kirim Ulasan',
                  onPressed: _sending ? () {} : _submit,
                ),
              ],
            ),
          ),
          const BottomNavigation(active: 'Toko'),
        ],
      ),
    );
  }

  Widget _storeIdentity() {
    return RoundedCard(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: const MarketAsset(
              'c83b1.png',
              width: 96,
              height: 76,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _BadgeText('Toko Makanan'),
                const SizedBox(height: 5),
                const Text(
                  'Lumpur Kentang 27',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: MarketColors.ink,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '★ 4.9  •  ${_reviewCount ?? '…'} ulasan',
                  style: const TextStyle(
                    color: MarketColors.yellow,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _ratingSection() {
    return RoundedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Beri Penilaian Anda',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 3),
          const Text(
            'Bagikan pengalaman kamu tentang toko ini',
            style: TextStyle(fontSize: 10, color: MarketColors.muted),
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(5, (index) {
              final value = index + 1;
              return IconButton(
                onPressed: () => setState(() => _rating = value),
                padding: const EdgeInsets.all(4),
                visualDensity: VisualDensity.compact,
                icon: Icon(
                  value <= _rating ? Icons.star : Icons.star_border,
                  color: MarketColors.yellow,
                  size: 25,
                ),
              );
            }),
          ),
          Text(
            '●  ${_ratingLabels[_rating]}',
            style: const TextStyle(
              color: MarketColors.greenDark,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _nameSection() {
    return RoundedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nama Pengunjung / Penulis',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _nameController,
            decoration: _inputDecoration('Masukkan nama', Icons.person_outline),
          ),
        ],
      ),
    );
  }

  Widget _experienceSection() {
    return RoundedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Ceritakan Pengalaman Anda',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                '${_experienceController.text.length}/500',
                style: const TextStyle(color: MarketColors.muted, fontSize: 9),
              ),
            ],
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _experienceController,
            maxLength: 500,
            minLines: 4,
            maxLines: 5,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              hintText: 'Bagikan pengalaman kamu tentang toko ini...',
              hintStyle: TextStyle(fontSize: 10, color: Color(0xFF9CA3AF)),
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(10),
              counterText: '',
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '✓ Ulasan membantu orang lain',
            style: TextStyle(
              color: MarketColors.greenDark,
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _photoSection() {
    return RoundedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Tambah Foto Kunjungan (Opsional)',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                '${_photos.length}/2 Terpilih',
                style: const TextStyle(color: MarketColors.muted, fontSize: 9),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              if (_photos.length < 2)
                InkWell(
                  onTap: _pickPhotos,
                  child: Container(
                    width: 72,
                    height: 70,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F5F3),
                      border: Border.all(color: const Color(0x33D56989)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: MarketColors.pink),
                        Text(
                          '+ Foto',
                          style: TextStyle(
                            color: MarketColors.pink,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ..._photos.asMap().entries.map(
                (entry) => Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(entry.value.path),
                        width: 72,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          width: 72,
                          height: 70,
                          color: const Color(0xFFF3EEF1),
                          child: const Icon(Icons.photo),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 1,
                      top: 1,
                      child: IconButton(
                        onPressed: () =>
                            setState(() => _photos.removeAt(entry.key)),
                        icon: const Icon(Icons.close, size: 13),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          minimumSize: const Size(22, 22),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _supportSection() {
    return RoundedCard(
      child: Row(
        children: [
          const Icon(Icons.storefront, color: MarketColors.pink, size: 19),
          const SizedBox(width: 9),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ulasan Anda Menghidupkan UMKM',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 3),
                Text(
                  'Ulasan jujur Anda membantu toko meningkatkan kualitas layanan dan mendukung pedagang lokal Pasar Oro-Oro Dowo.',
                  style: TextStyle(
                    color: MarketColors.muted,
                    fontSize: 9,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: _showBadge,
            activeTrackColor: MarketColors.green,
            onChanged: (value) => setState(() => _showBadge = value),
          ),
        ],
      ),
    );
  }
}

class _BadgeText extends StatelessWidget {
  const _BadgeText(this.value);

  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE3EB),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        value,
        style: const TextStyle(
          color: MarketColors.pink,
          fontSize: 8,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

InputDecoration _inputDecoration(String hint, IconData icon) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(fontSize: 10, color: Color(0xFF9CA3AF)),
    prefixIcon: Icon(icon, size: 16, color: MarketColors.muted),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0x33D56989)),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 9, vertical: 9),
    isDense: true,
  );
}
