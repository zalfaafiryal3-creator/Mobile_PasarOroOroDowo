import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../data/review_api.dart';
import '../widgets/market_ui.dart';

class _MarketReviewPreview {
  const _MarketReviewPreview({
    required this.name,
    required this.rating,
    required this.date,
    required this.text,
    required this.helpfulIndex,
    this.tags = const [],
    this.photos = const [],
  });

  final String name;
  final int rating;
  final String date;
  final String text;
  final int helpfulIndex;
  final List<String> tags;
  final List<String> photos;
}

const _marketReviewPreviews = <_MarketReviewPreview>[
  _MarketReviewPreview(
    name: 'ZALFAA',
    rating: 5,
    date: 'Kemarin',
    text:
        'Pasar tradisional paling bersih dan estetik di Malang! Lorongnya luas, tidak becek sama sekali, dan belanja sayur segar sampai jajanan di sini nyaman banget. Pedagangnya juga ramah-ramah.',
    helpfulIndex: 0,
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
  ),
  _MarketReviewPreview(
    name: 'Mifta',
    rating: 4,
    date: '1 minggu lalu',
    text:
        'Tempatnya asri dan bersih. Parkir motor dan mobil tertata rapi. Kalau pagi hari sekitar jam 7-8 cukup ramai tapi arus belanjanya tetap teratur karena lorongnya satu arah.',
    helpfulIndex: 2,
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
  final List<int> _helpfulCounts = [34, 19, 8];

  List<_MarketReviewPreview> get _visibleReviews {
    final query = _searchController.text.trim().toLowerCase();
    final reviews = _marketReviewPreviews.where((review) {
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
    final visibleReviews = _visibleReviews;
    return MarketPage(
      background: const Color(0xFFF5F8ED),
      child: Column(
        children: [
          PageTitleBar(
            title: 'Review Pasar',
            subtitle: 'Pasar Oro-Oro Dowo, Malang',
            asset: 'c03df.svg',
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
              children: [
                RoundedCard(
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: const MarketAsset(
                          '204f2.png',
                          height: 140,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 11),
                      const Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pasar Oro-Oro Dowo',
                                  style: TextStyle(
                                    color: MarketColors.ink,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  'Ulasan dan pengalaman pengunjung',
                                  style: TextStyle(
                                    color: MarketColors.muted,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '4.8  ★',
                            style: TextStyle(
                              color: MarketColors.yellow,
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 13),
                      const _ReviewAspectRow(
                        label: 'Kebersihan & Kerapian',
                        rating: '4.9',
                        progress: .98,
                        color: MarketColors.green,
                      ),
                      const SizedBox(height: 7),
                      const _ReviewAspectRow(
                        label: 'Kelengkapan Komoditas',
                        rating: '4.8',
                        progress: .94,
                        color: MarketColors.yellow,
                      ),
                      const SizedBox(height: 7),
                      const _ReviewAspectRow(
                        label: 'Keramahan Pedagang',
                        rating: '4.9',
                        progress: .97,
                        color: MarketColors.yellow,
                      ),
                      const SizedBox(height: 7),
                      const _ReviewAspectRow(
                        label: 'Keamanan & Parkir',
                        rating: '4.6',
                        progress: .88,
                        color: MarketColors.brown,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SearchField(
                  controller: _searchController,
                  hint: 'Cari ulasan...',
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 9),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children:
                        [
                          ('Semua (3)', 'all'),
                          ('Dengan Foto (1)', 'photo'),
                          ('Bintang 5 (2)', '5'),
                          ('Bintang 4 (1)', '4'),
                          ('Bintang 1-3 (0)', 'low'),
                        ].map((filter) {
                          final selected = filter.$2 == _filter;
                          return Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: ChoiceChip(
                              label: Text(filter.$1),
                              selected: selected,
                              onSelected: (_) =>
                                  setState(() => _filter = filter.$2),
                              labelStyle: TextStyle(
                                fontSize: 9,
                                color: selected
                                    ? Colors.white
                                    : MarketColors.brown,
                              ),
                              selectedColor: MarketColors.brown,
                              backgroundColor: Colors.white,
                              visualDensity: VisualDensity.compact,
                            ),
                          );
                        }).toList(),
                  ),
                ),
                const SizedBox(height: 9),
                RoundedCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Ulasan Pengunjung',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () =>
                                setState(() => _newestFirst = !_newestFirst),
                            child: Text(
                              _newestFirst ? 'Terbaru ↓' : 'Terlama ↑',
                              style: const TextStyle(
                                fontSize: 10,
                                color: MarketColors.pink,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      if (visibleReviews.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(12),
                          child: Text(
                            'Tidak ada ulasan yang cocok.',
                            style: TextStyle(
                              color: MarketColors.muted,
                              fontSize: 10,
                            ),
                          ),
                        )
                      else
                        ...visibleReviews.map(_reviewCard),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const ErrorNotice(
                  'Ulasan terbaru dari backend tidak dapat dimuat: backend/src/clients/reviewApi yang digunakan project React tidak tersedia pada folder project ini. Tiga ulasan contoh dari halaman sumber tetap ditampilkan.',
                ),
                const SizedBox(height: 12),
                PrimaryMarketButton(
                  label: '+ Tulis Ulasan Pasar',
                  icon: Icons.rate_review_outlined,
                  onPressed: () => goTo(context, '/tulis-ulasan-pasar'),
                ),
                const SizedBox(height: 10),
                RoundedCard(
                  child: const Row(
                    children: [
                      Icon(Icons.favorite, color: MarketColors.pink, size: 20),
                      SizedBox(width: 9),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ulasan Anda Menghidupkan UMKM',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'Pengalaman Anda membantu pedagang lokal dan pengunjung lainnya.',
                              style: TextStyle(
                                color: MarketColors.muted,
                                fontSize: 9,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const BottomNavigation(active: 'Review Pasar'),
        ],
      ),
    );
  }

  Widget _reviewCard(_MarketReviewPreview review) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 17,
                backgroundColor: const Color(0xFFE8EED8),
                child: Text(
                  review.name.substring(0, 1),
                  style: const TextStyle(
                    color: MarketColors.brown,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.name,
                      style: const TextStyle(
                        color: MarketColors.ink,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      review.date,
                      style: const TextStyle(
                        color: MarketColors.muted,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${review.rating}.0  ★',
                style: const TextStyle(
                  color: MarketColors.yellow,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          if (review.tags.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 5,
              children: review.tags
                  .map(
                    (tag) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0x47C2DC80),
                        border: Border.all(color: const Color(0xFFC2DC80)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          color: Color(0xFF354B0E),
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
          const SizedBox(height: 7),
          Text(
            review.text,
            style: const TextStyle(
              color: MarketColors.ink,
              fontSize: 11,
              height: 1.55,
            ),
          ),
          if (review.photos.isNotEmpty) ...[
            const SizedBox(height: 8),
            SizedBox(
              height: 92,
              child: Row(
                children: review.photos
                    .map(
                      (photo) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: MarketAsset(
                              photo,
                              fit: BoxFit.cover,
                              height: 92,
                              width: double.infinity,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => setState(
                () => _helpfulCounts[review.helpfulIndex]++,
              ),
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                foregroundColor: MarketColors.brown,
              ),
              icon: const Icon(Icons.thumb_up_alt_outlined, size: 13),
              label: Text(
                'Membantu (${_helpfulCounts[review.helpfulIndex]})',
                style: const TextStyle(fontSize: 9),
              ),
            ),
          ),
          const Divider(height: 8, color: Color(0xFFECEFE5)),
        ],
      ),
    );
  }
}

class _ReviewAspectRow extends StatelessWidget {
  const _ReviewAspectRow({
    required this.label,
    required this.rating,
    required this.progress,
    required this.color,
  });

  final String label;
  final String rating;
  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: MarketColors.ink,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              '$rating ★',
              style: const TextStyle(
                color: MarketColors.ink,
                fontSize: 9,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: const Color(0xFFDEE8FF),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
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
    setState(() {
      _sending = true;
      _error = 'Ulasan tidak dapat dikirim karena backend/src/clients/reviewApi yang digunakan project React tidak tersedia. Formulir dan data Anda belum disimpan.';
    });
    setState(() => _sending = false);
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

class WriteStoreReviewScreen extends StatefulWidget {
  const WriteStoreReviewScreen({super.key});

  @override
  State<WriteStoreReviewScreen> createState() => _WriteStoreReviewScreenState();
}

class _WriteStoreReviewScreenState extends State<WriteStoreReviewScreen> {
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
