import 'package:flutter/material.dart';

import '../data/market_data.dart';
import '../data/review_api.dart';
import '../widgets/market_ui.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  String? _activeCategory;
  bool _isMarketFavorite = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _matchesCategory(StoreData store, String category) {
    final cat = category.toLowerCase();
    final target = '${store.category} ${store.displayCategory} ${store.badge}'.toLowerCase();
    if (cat == 'pakaian') {
      return target.contains('pakaian') || target.contains('baju') || target.contains('mainan & baju');
    } else if (cat == 'sembako') {
      return target.contains('sembako');
    } else if (cat == 'makanan') {
      return target.contains('makanan') || target.contains('kuliner');
    } else if (cat == 'perabotan' || cat == 'peralatan') {
      return target.contains('perabotan') || target.contains('peralatan');
    } else if (cat == 'lainnya') {
      return !target.contains('baju') &&
          !target.contains('pakaian') &&
          !target.contains('sembako') &&
          !target.contains('makanan') &&
          !target.contains('kuliner');
    }
    return target.contains(cat);
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();

    // Default 4 stores shown in the reference screenshot
    const defaultStoreIds = [
      'lumpur-kentang-27',
      'bakso-goreng-bangkit',
      'klepon-ku',
      'wiwit-sayur',
    ];

    final List<StoreData> displayedStores;
    if (query.isNotEmpty || _activeCategory != null) {
      displayedStores = marketStores.where((store) {
        final matchesCat = _activeCategory == null ||
            _matchesCategory(store, _activeCategory!);
        final matchesSearch = query.isEmpty ||
            '${store.name} ${store.displayCategory} ${store.badge} ${store.category}'
                .toLowerCase()
                .contains(query);
        return matchesCat && matchesSearch;
      }).toList();
    } else {
      displayedStores = defaultStoreIds
          .map((id) => marketStores.firstWhere(
                (s) => s.id == id,
                orElse: () => marketStores.first,
              ))
          .toList();
    }

    return MarketPage(
      background: const Color(0xFFF0F6DF),
      child: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 105),
            children: [
              // 1. Header: Logo kuning dengan ikon awan putih + Nama Pasar
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFC928),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x2B000000),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.cloud_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Pasar Oro-Oro Dowo',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xFF594045),
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 2. Search Bar: Kapsul putih dengan border halus
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
                    hintText: 'Cari toko, produk, atau pedagang...',
                    hintStyle: const TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF9CA3AF),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // 3. Banner Gradasi Hijau Muda ke Kuning
              Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFB8D66D),
                      Color(0xFFFFC928),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x20526B31),
                      blurRadius: 14,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Pilih\nToko Favoritmu',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.5,
                              fontWeight: FontWeight.w800,
                              height: 1.15,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Temukan berbagai toko menarik\ndi PasarKu',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.95),
                              fontSize: 10.5,
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 12),
                          InkWell(
                            onTap: () => goTo(context, '/toko'),
                            borderRadius: BorderRadius.circular(999),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(999),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x18000000),
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Jelajahi Sekarang',
                                      style: TextStyle(
                                        color: Color(0xFFD97706),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 13,
                                      color: Color(0xFFD97706),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const _BannerShoppingBag(),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // 4. Slide Indicator Dots di Bawah Banner
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 14,
                    height: 4.5,
                    decoration: BoxDecoration(
                      color: const Color(0xFF594045),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 4.5,
                    height: 4.5,
                    decoration: const BoxDecoration(
                      color: Color(0x55594045),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 4.5,
                    height: 4.5,
                    decoration: const BoxDecoration(
                      color: Color(0x55594045),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 4.5,
                    height: 4.5,
                    decoration: const BoxDecoration(
                      color: Color(0x55594045),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // 5. Card Informasi Pasar Oro-Oro Dowo
              InkWell(
                onTap: () => goTo(context, '/info-kunjungan'),
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x18594045),
                        blurRadius: 16,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: const SizedBox(
                              width: 110,
                              height: 80,
                              child: MarketAsset(
                                '204f2.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        'Pasar Oro-Oro Dowo',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Color(0xFF594045),
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isMarketFavorite = !_isMarketFavorite;
                                        });
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            duration: const Duration(seconds: 1),
                                            content: Text(
                                              _isMarketFavorite
                                                  ? 'Pasar Oro-Oro Dowo ditambahkan ke favorit'
                                                  : 'Dihapus dari favorit',
                                            ),
                                          ),
                                        );
                                      },
                                      child: Icon(
                                        _isMarketFavorite
                                            ? Icons.favorite_rounded
                                            : Icons.favorite_border_rounded,
                                        size: 19,
                                        color: _isMarketFavorite
                                            ? const Color(0xFFE11D48)
                                            : const Color(0xFF594045),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                const Text(
                                  'Pusat Belanja dan Kuliner\nTradisional di Tengah Kota',
                                  style: TextStyle(
                                    color: Color(0xFFD97706),
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w700,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                const Text(
                                  'Pasar yang sudah berdiri sejak lama dan menjadi ikon belanja masyarakat dengan beragam produk, harga...',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Color(0xFF6B7280),
                                    fontSize: 9,
                                    height: 1.25,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Statistik Pasar (Jam Buka, Jumlah Pedagang, Lokasi)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7FAF2),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Row(
                          children: [
                            Expanded(
                              child: _MarketStatItem(
                                icon: Icons.access_time_rounded,
                                title: 'Jam Buka',
                                main: '06.00 - 17.00',
                                sub: 'Setiap Hari',
                              ),
                            ),
                            Expanded(
                              child: _MarketStatItem(
                                icon: Icons.people_alt_rounded,
                                title: 'Pedagang',
                                main: '± 251',
                                sub: 'Pedagang',
                              ),
                            ),
                            Expanded(
                              child: _MarketStatItem(
                                icon: Icons.location_on_rounded,
                                title: 'Lokasi',
                                main: 'Klojen',
                                sub: 'Jawa Timur',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // 6. Menu Pintasan Ikon (Denah Pasar, AI-perencana, Fasilitas, Rekomendasi, Info Kunjungan)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 12,
                ),
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
                child: const Row(
                  children: [
                    Expanded(
                      child: _HomeShortcutItem(
                        label: 'Denah\nPasar',
                        icon: Icons.map_outlined,
                        route: '/denah',
                      ),
                    ),
                    Expanded(
                      child: _HomeShortcutItem(
                        label: 'AI-\nperencana',
                        icon: Icons.image_outlined,
                        route: '/chatbot-rekomendasi',
                      ),
                    ),
                    Expanded(
                      child: _HomeShortcutItem(
                        label: 'Fasilitas\n',
                        icon: Icons.storefront_outlined,
                        route: '/fasilitas-pasar',
                      ),
                    ),
                    Expanded(
                      child: _HomeShortcutItem(
                        label: 'Rekomendasi\n',
                        icon: Icons.history_rounded,
                        route: '/rekomendasi',
                      ),
                    ),
                    Expanded(
                      child: _HomeShortcutItem(
                        label: 'Info\nKunjungan',
                        icon: Icons.assignment_outlined,
                        route: '/info-kunjungan',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // 7. Kategori Belanja
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Kategori Belanja',
                      style: TextStyle(
                        color: Color(0xFF594045),
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => goTo(context, '/toko'),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Lihat Semua',
                          style: TextStyle(
                            color: Color(0xFF594045),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 2),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: Color(0xFF594045),
                          size: 17,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // 5 Kotak Kategori Belanja (Pakaian, Sembako, Makanan, Perabotan, Lainnya)
              Row(
                children: [
                  Expanded(
                    child: _CategoryBox(
                      name: 'Pakaian',
                      icon: Icons.checkroom_rounded,
                      iconColor: const Color(0xFFF59E0B),
                      isSelected: _activeCategory == 'Pakaian',
                      onTap: () => setState(() {
                        _activeCategory =
                            _activeCategory == 'Pakaian' ? null : 'Pakaian';
                      }),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _CategoryBox(
                      name: 'Sembako',
                      icon: Icons.shopping_basket_rounded,
                      iconColor: const Color(0xFF10B981),
                      isSelected: _activeCategory == 'Sembako',
                      onTap: () => setState(() {
                        _activeCategory =
                            _activeCategory == 'Sembako' ? null : 'Sembako';
                      }),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _CategoryBox(
                      name: 'Makanan',
                      icon: Icons.soup_kitchen_rounded,
                      iconColor: const Color(0xFFF59E0B),
                      isSelected: _activeCategory == 'Makanan',
                      onTap: () => setState(() {
                        _activeCategory =
                            _activeCategory == 'Makanan' ? null : 'Makanan';
                      }),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _CategoryBox(
                      name: 'Perabotan',
                      icon: Icons.work_outline_rounded,
                      iconColor: const Color(0xFF10B981),
                      isSelected: _activeCategory == 'Perabotan',
                      onTap: () => setState(() {
                        _activeCategory =
                            _activeCategory == 'Perabotan' ? null : 'Perabotan';
                      }),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _CategoryBox(
                      name: 'Lainnya',
                      icon: Icons.more_horiz_rounded,
                      iconColor: const Color(0xFFF59E0B),
                      isSelected: _activeCategory == 'Lainnya',
                      onTap: () => setState(() {
                        _activeCategory =
                            _activeCategory == 'Lainnya' ? null : 'Lainnya';
                      }),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // 8. Daftar Toko
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Daftar Toko',
                      style: TextStyle(
                        color: Color(0xFF594045),
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => goTo(context, '/toko'),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Lihat Semua',
                          style: TextStyle(
                            color: Color(0xFF594045),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 2),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: Color(0xFF594045),
                          size: 17,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Grid 2 Kolom Toko
              if (displayedStores.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(28),
                  child: Text(
                    'Tidak ada toko yang cocok dengan pencarian.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: MarketColors.muted),
                  ),
                )
              else
                GridView.builder(
                  itemCount: displayedStores.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 14,
                    mainAxisExtent: 282,
                  ),
                  itemBuilder: (context, index) {
                    final store = displayedStores[index];
                    return InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => goTo(context, '/detail-toko/${store.id}'),
                      child: _HomeStoreCard(store: store),
                    );
                  },
                ),
              const SizedBox(height: 16),

              // 9. Card Rencanakan Kunjunganmu
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x18594045),
                      blurRadius: 14,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDCFCE7),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  Icons.calendar_month_rounded,
                                  size: 15,
                                  color: Color(0xFF526B31),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Text(
                                  'Rencanakan Kunjunganmu',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Color(0xFF594045),
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Cek info terbaru, event, dan promo menarik di Pasar Oro-Oro Dowo.',
                            style: TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 10,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 9),
                          InkWell(
                            onTap: () => goTo(context, '/info-kunjungan'),
                            borderRadius: BorderRadius.circular(999),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: const Color(0x60526B31),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(999),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x0C000000),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Lihat Info Kunjungan',
                                      style: TextStyle(
                                        color: Color(0xFF526B31),
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 12,
                                      color: Color(0xFF526B31),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const _VisitPlannerIllustration(),
                  ],
                ),
              ),
            ],
          ),

          // 10. Floating Bottom Navigation
          Positioned(
            left: 15,
            right: 15,
            bottom: 12,
            child: _homeBottomNavigation(context),
          ),
        ],
      ),
    );
  }

  Widget _homeBottomNavigation(BuildContext context) {
    const items = <(String, String, String)>[
      ('Home', '/home', 'dfd0c.svg'),
      ('Toko', '/toko', '2781e.svg'),
      ('Promo', '/promo', '75326.svg'),
      ('Review Pasar', '/review-pasar', '3de6e.svg'),
    ];
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.98),
        border: Border.all(color: const Color(0x99B8D66D), width: 1.5),
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22526B31),
            blurRadius: 22,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items.map((item) {
          final active = item.$1 == 'Home';
          return InkWell(
            onTap: () => goTo(context, item.$2),
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              width: 58,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 34,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: active
                          ? const Color(0xFFE2F0C2)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: MarketAsset(
                      item.$3,
                      width: 20,
                      height: 20,
                      color: active
                          ? const Color(0xFF526B31)
                          : const Color(0xFF9CA3AF),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.$1,
                    maxLines: 1,
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                      color: active
                          ? const Color(0xFF526B31)
                          : const Color(0xFF9CA3AF),
                      fontSize: item.$1 == 'Review Pasar' ? 9 : 10,
                      fontWeight:
                          active ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _MarketStatItem extends StatelessWidget {
  const _MarketStatItem({
    required this.icon,
    required this.title,
    required this.main,
    required this.sub,
  });

  final IconData icon;
  final String title;
  final String main;
  final String sub;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 22,
            height: 22,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFE2F0C2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 12, color: const Color(0xFF526B31)),
          ),
          const SizedBox(width: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 7.5,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                main,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1F2937),
                ),
              ),
              Text(
                sub,
                style: const TextStyle(
                  fontSize: 7.5,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HomeShortcutItem extends StatelessWidget {
  const _HomeShortcutItem({
    required this.label,
    required this.icon,
    required this.route,
  });

  final String label;
  final IconData icon;
  final String route;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => goTo(context, route),
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFFEF3C7),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 20,
              color: const Color(0xFFD97706),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF594045),
              fontSize: 9,
              height: 1.15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryBox extends StatelessWidget {
  const _CategoryBox({
    required this.name,
    required this.icon,
    required this.iconColor,
    required this.isSelected,
    required this.onTap,
  });

  final String name;
  final IconData icon;
  final Color iconColor;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFFB8D66D) : const Color(0x35594045),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected ? const Color(0x30B8D66D) : const Color(0x10594045),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 21, color: iconColor),
            const SizedBox(height: 4),
            Text(
              name,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? const Color(0xFF526B31) : const Color(0xFF594045),
                fontSize: 9.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BannerShoppingBag extends StatelessWidget {
  const _BannerShoppingBag();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 82,
      height: 86,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Positioned(
            right: 4,
            top: 1,
            child: Text(
              '✦',
              style: TextStyle(
                color: Color(0xFF526B31),
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            bottom: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 32,
                  height: 18,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFF526B31),
                      width: 3,
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                ),
                Container(
                  width: 62,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FDE8),
                    border: Border.all(
                      color: const Color(0xFF526B31),
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1E000000),
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.favorite_rounded,
                      color: Color(0xFF526B31),
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VisitPlannerIllustration extends StatelessWidget {
  const _VisitPlannerIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 68,
      height: 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 2,
            child: Container(
              width: 52,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFF59E0B),
                  width: 2.5,
                ),
              ),
              child: Center(
                child: Container(
                  width: 2.5,
                  height: double.infinity,
                  color: const Color(0xFFF59E0B),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 33,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.rotate(
                  angle: -0.32,
                  child: Container(
                    width: 23,
                    height: 9,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDE68A),
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(
                        color: const Color(0xFFF59E0B),
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Transform.rotate(
                  angle: 0.32,
                  child: Container(
                    width: 23,
                    height: 9,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDE68A),
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(
                        color: const Color(0xFFF59E0B),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 2,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Color(0xFFB8D66D),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.location_on_rounded,
                color: Color(0xFF526B31),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeStoreCard extends StatelessWidget {
  const _HomeStoreCard({required this.store});

  final StoreData store;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18594045),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
            child: SizedBox(
              height: 126,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  MarketAsset(store.image, fit: BoxFit.cover),
                  Positioned(
                    left: 9,
                    top: 9,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3.5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF526B31),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        store.badge,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  store.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF1E293B),
                    fontSize: 13,
                    height: 1.2,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  store.displayCategory,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 15,
                      color: Color(0xFFF59E0B),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      store.rating,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFF59E0B),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 10,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      color: const Color(0xFFD1D5DB),
                    ),
                    Text(
                      store.products,
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  height: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x35FFC928),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () => goTo(context, '/detail-toko/${store.id}'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFC928),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    child: const Text(
                      'Lihat Toko',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StoreListScreen extends StatefulWidget {
  const StoreListScreen({this.initialCategory, super.key});

  final String? initialCategory;

  @override
  State<StoreListScreen> createState() => _StoreListScreenState();
}

class _StoreListScreenState extends State<StoreListScreen> {
  final _searchController = TextEditingController();
  String? _activeCategory;

  @override
  void initState() {
    super.initState();
    _activeCategory = widget.initialCategory;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final search = _searchController.text.trim().toLowerCase();
    final stores = marketStores.where((store) {
      final matchesCategory =
          _activeCategory == null ||
          store.category.toLowerCase() == _activeCategory!.toLowerCase() ||
          store.badge.toLowerCase().contains(_activeCategory!.toLowerCase()) ||
          store.displayCategory.toLowerCase().contains(
            _activeCategory!.toLowerCase(),
          );
      final matchesSearch =
          search.isEmpty ||
          '${store.name} ${store.displayCategory} ${store.badge}'
              .toLowerCase()
              .contains(search);
      return matchesCategory && matchesSearch;
    }).toList();

    return MarketPage(
      background: MarketColors.background,
      child: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            children: [
              // Header: Logo Kuning dengan Awan Putih + Judul
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1C538),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x35000000),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.cloud,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Pasar Oro-Oro Dowo',
                    style: TextStyle(
                      color: Color(0xFF3D3830),
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Search bar
              Container(
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x12000000),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(fontSize: 13, color: MarketColors.ink),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: Color(0xFF9CA3AF),
                      size: 24,
                    ),
                    hintText: 'Cari toko, produk, atau pedagang...',
                    hintStyle: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF9CA3AF),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 13),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Kategori Belanja heading + chevron
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Kategori Belanja',
                      style: TextStyle(
                        color: Color(0xFF1E2614),
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFF374151),
                    size: 22,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Kategori Card Putih dengan Shadow Tebal (6 Kategori)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x35283216),
                      blurRadius: 18,
                      offset: Offset(0, 8),
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final itemW = (constraints.maxWidth - 5 * 4) / 6;
                    const categoryData = [
                      ('Makanan', Icons.restaurant_rounded, Color(0xFFD97706), Color(0xFFFDE68A), Color(0x40F59E0B)),
                      ('Sayur\n& Buah', Icons.eco_rounded, Color(0xFF15803D), Color(0xFFDCFCE7), Color(0x3510B981)),
                      ('Kuliner\nLegend', Icons.restaurant_menu_rounded, Color(0xFFEA580C), Color(0xFFFED7AA), Color(0x40F97316)),
                      ('Daging\n& Ikan', Icons.set_meal_rounded, Color(0xFF047857), Color(0xFFD1FAE5), Color(0x3510B981)),
                      ('Sembako\n& Perabotan', Icons.shopping_basket_rounded, Color(0xFFEA580C), Color(0xFFFED7AA), Color(0x40F97316)),
                      ('Mainan\n& Baju', Icons.rocket_launch_rounded, Color(0xFF15803D), Color(0xFFDCFCE7), Color(0x3510B981)),
                    ];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(categoryData.length, (index) {
                        final cat = categoryData[index];
                        final catName = cat.$1;
                        final isSelected = _activeCategory != null &&
                            catName.replaceAll('\n', ' ').toLowerCase().contains(
                              _activeCategory!.toLowerCase().split(' ').first,
                            );
                        return GestureDetector(
                          onTap: () => setState(() {
                            final label = catName.replaceAll('\n', ' ');
                            _activeCategory = isSelected ? null : label;
                          }),
                          child: SizedBox(
                            width: itemW,
                            child: Column(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? cat.$3.withValues(alpha: 0.3)
                                        : cat.$4,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: cat.$5,
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    cat.$2,
                                    size: 21,
                                    color: cat.$3,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  catName,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: isSelected
                                        ? cat.$3
                                        : const Color(0xFF1F2937),
                                    fontSize: 9.5,
                                    height: 1.15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Daftar Toko Heading
              const Text(
                'Daftar Toko',
                style: TextStyle(
                  color: Color(0xFF1E2614),
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 14),

              // Grid Toko
              if (stores.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'Tidak ada toko yang cocok.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: MarketColors.muted),
                  ),
                )
              else
                GridView.builder(
                  itemCount: stores.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 16,
                        mainAxisExtent: 288,
                      ),
                  itemBuilder: (context, index) {
                    final store = stores[index];
                    return InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () => goTo(context, '/detail-toko/${store.id}'),
                      child: _TokoStoreCard(store: store),
                    );
                  },
                ),
            ],
          ),

          // Floating Bottom Navigation
          Positioned(
            left: 16,
            right: 16,
            bottom: 12,
            child: _tokoBottomNavigation(context),
          ),
        ],
      ),
    );
  }

  Widget _tokoBottomNavigation(BuildContext context) {
    const items = <(String, String, String)>[
      ('Home', '/home', 'dfd0c.svg'),
      ('Toko', '/toko', '2781e.svg'),
      ('Promo', '/promo', '75326.svg'),
      ('Review Pasar', '/review-pasar', '3de6e.svg'),
    ];
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xBBC2DC80), width: 1.5),
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(
            color: Color(0x254B6515),
            blurRadius: 24,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.map((item) {
          final active = item.$1 == 'Toko';
          return InkWell(
            onTap: () => goTo(context, item.$2),
            borderRadius: BorderRadius.circular(16),
            splashColor: const Color(0x30C2DC80),
            highlightColor: const Color(0x18C2DC80),
            child: SizedBox(
              width: 64,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: active
                          ? const Color(0x55C2DC80)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: MarketAsset(
                      item.$3,
                      width: 22,
                      height: 22,
                      color: active
                          ? MarketColors.greenDark
                          : const Color(0xFF9CA3AF),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.$1,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: active
                          ? MarketColors.greenDark
                          : const Color(0xFF9CA3AF),
                      fontSize: item.$1 == 'Review Pasar' ? 9 : 10,
                      fontWeight:
                          active ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _TokoStoreCard extends StatelessWidget {
  const _TokoStoreCard({required this.store});

  final StoreData store;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2E000000),
            blurRadius: 20,
            offset: Offset(0, 10),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Gambar toko dengan badge kategori hijau
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(24),
            ),
            child: SizedBox(
              height: 132,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  MarketAsset(store.image, fit: BoxFit.cover),
                  Positioned(
                    left: 10,
                    top: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4C6D1F),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        store.badge,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Info toko
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  store.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF1E293B),
                    fontSize: 13.5,
                    height: 1.25,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  store.displayCategory,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 15,
                      color: Color(0xFFF59E0B),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      store.rating,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFF59E0B),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 11,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      color: const Color(0xFFD1D5DB),
                    ),
                    Text(
                      store.products,
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Tombol Lihat Toko kuning bulat dengan glow shadow
                Container(
                  width: double.infinity,
                  height: 38,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x66F5A623),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () =>
                        goTo(context, '/detail-toko/${store.id}'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF9B824),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    child: const Text(
                      'Lihat Toko',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class StoreDetailScreen extends StatefulWidget {
  const StoreDetailScreen({required this.storeId, super.key});

  final String storeId;

  @override
  State<StoreDetailScreen> createState() => _StoreDetailScreenState();
}

class _StoreDetailScreenState extends State<StoreDetailScreen> {
  final _reviewNameController = TextEditingController();
  final _reviewTextController = TextEditingController();
  late Future<List<StoreReview>> _reviews;
  String? _reviewError;
  bool _reviewSending = false;
  bool _showAllReviews = false;
  int _galleryIndex = 0;
  static const _gallery = ['b55ea.png', '4ef0e.png', 'c83b1.png'];

  StoreData get _store => marketStores.firstWhere(
    (store) => store.id == widget.storeId,
    orElse: () => marketStores.first,
  );

  @override
  void initState() {
    super.initState();
    _reviews = StoreReviewApi.fetchDetailReviews();
  }

  @override
  void dispose() {
    _reviewNameController.dispose();
    _reviewTextController.dispose();
    super.dispose();
  }

  Future<void> _submitInlineReview() async {
    if (_reviewNameController.text.trim().isEmpty ||
        _reviewTextController.text.trim().isEmpty) {
      setState(() => _reviewError = 'Nama dan pengalaman wajib diisi.');
      return;
    }
    setState(() {
      _reviewSending = true;
      _reviewError = null;
    });
    try {
      final reviews = await StoreReviewApi.submitDetailReview(
        name: _reviewNameController.text.trim(),
        text: _reviewTextController.text.trim(),
      );
      if (!mounted) return;
      setState(() {
        _reviews = Future.value(reviews);
        _showAllReviews = true;
        _reviewNameController.clear();
        _reviewTextController.clear();
      });
    } catch (error) {
      if (mounted) setState(() => _reviewError = error.toString());
    } finally {
      if (mounted) setState(() => _reviewSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MarketPage(
      child: Column(
        children: [
          PageTitleBar(
            title: _store.name,
            subtitle: 'Pasar Oro-Oro Dowo, Malang',
            onBack: () => goTo(context, '/toko'),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 18),
              children: [
                _gallerySection(),
                const SizedBox(height: 12),
                RoundedCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _smallBadge(_store.category),
                      const SizedBox(height: 8),
                      Text(
                        _store.name,
                        style: const TextStyle(
                          fontSize: 20,
                          color: MarketColors.ink,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 15,
                            color: MarketColors.yellow,
                          ),
                          Text(
                            ' 4.9  •  Pasar Oro-Oro Dowo',
                            style: TextStyle(
                              color: MarketColors.ink,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Kunjungi toko dan temukan produk pilihan dari pedagang lokal Pasar Oro-Oro Dowo.',
                        style: TextStyle(
                          color: MarketColors.muted,
                          fontSize: 11,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      PrimaryMarketButton(
                        label: 'Tulis Ulasan Toko',
                        onPressed: () => goTo(context, '/tulis-ulasan-toko'),
                        icon: Icons.rate_review_outlined,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                const SectionHeading('Produk Toko'),
                const SizedBox(height: 8),
                SizedBox(
                  height: 184,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: storeProducts.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 9),
                    itemBuilder: (context, index) =>
                        _productCard(context, storeProducts[index]),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Expanded(child: SectionHeading('Ulasan Pembeli')),
                    TextButton(
                      onPressed: () =>
                          setState(() => _showAllReviews = !_showAllReviews),
                      child: Text(
                        _showAllReviews ? 'Ringkas' : 'Lihat Semua',
                        style: const TextStyle(
                          color: MarketColors.pink,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
                FutureBuilder<List<StoreReview>>(
                  future: _reviews,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(
                            color: MarketColors.pink,
                          ),
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return ErrorNotice(
                        'Ulasan toko belum dapat dimuat: ${snapshot.error}',
                      );
                    }
                    final reviews = snapshot.data ?? const <StoreReview>[];
                    if (reviews.isEmpty) {
                      return const ErrorNotice('Belum ada ulasan toko.');
                    }
                    final visibleReviews = _showAllReviews
                        ? reviews
                        : reviews.take(2).toList();
                    return Column(
                      children: visibleReviews.map(_reviewCard).toList(),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _inlineReviewForm(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _gallerySection() {
    return Column(
      children: [
        GestureDetector(
          onTap: () => showDialog<void>(
            context: context,
            builder: (context) => Dialog(
              backgroundColor: Colors.transparent,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  InteractiveViewer(
                    child: MarketAsset(
                      _gallery[_galleryIndex],
                      fit: BoxFit.contain,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Stack(
              children: [
                MarketAsset(
                  _gallery[_galleryIndex],
                  width: double.infinity,
                  height: 212,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  left: 12,
                  bottom: 12,
                  child: _smallBadge('TOKO ${_store.category.toUpperCase()}'),
                ),
                Positioned(
                  right: 12,
                  bottom: 12,
                  child: _smallBadge('${_galleryIndex + 1}/${_gallery.length}'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 7),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_gallery.length, (index) {
            return GestureDetector(
              onTap: () => setState(() => _galleryIndex = index),
              child: Container(
                width: 48,
                height: 43,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(
                    color: index == _galleryIndex
                        ? MarketColors.pink
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: MarketAsset(_gallery[index], fit: BoxFit.cover),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _productCard(BuildContext context, MarketProduct product) {
    return InkWell(
      onTap: () => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (context) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: MarketAsset(
                    product.image,
                    width: double.infinity,
                    height: 210,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  product.price,
                  style: const TextStyle(
                    color: MarketColors.pink,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
      child: Container(
        width: 126,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0x22D56989)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MarketAsset(
              product.image,
              width: 126,
              height: 104,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.price,
                    style: const TextStyle(
                      color: MarketColors.pink,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '★ ${product.rating} (${product.reviewCount})',
                    style: const TextStyle(
                      color: MarketColors.muted,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _reviewCard(StoreReview review) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0x22D56989)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: const Color(0x33C2DC80),
                child: Text(
                  review.name.isEmpty ? '?' : review.name[0].toUpperCase(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  review.name,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                review.date,
                style: const TextStyle(fontSize: 9, color: MarketColors.muted),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            '★ ${review.rating}',
            style: const TextStyle(color: MarketColors.yellow, fontSize: 11),
          ),
          const SizedBox(height: 4),
          Text(review.text, style: const TextStyle(fontSize: 11, height: 1.4)),
        ],
      ),
    );
  }

  Widget _inlineReviewForm() {
    return RoundedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bagikan pengalaman Anda',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _reviewNameController,
            decoration: const InputDecoration(
              labelText: 'Nama Pengunjung',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _reviewTextController,
            minLines: 2,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Tulis ulasan',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          if (_reviewError != null) ...[
            const SizedBox(height: 8),
            ErrorNotice(_reviewError!),
          ],
          const SizedBox(height: 8),
          PrimaryMarketButton(
            label: _reviewSending ? 'Mengirim...' : 'Kirim Ulasan',
            icon: Icons.send,
            onPressed: _reviewSending ? () {} : _submitInlineReview,
          ),
        ],
      ),
    );
  }

  Widget _smallBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .94),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: MarketColors.brown,
          fontSize: 9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
