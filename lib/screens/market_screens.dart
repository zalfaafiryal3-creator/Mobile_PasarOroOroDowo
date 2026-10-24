import 'package:flutter/material.dart';

import '../data/market_data.dart';
import '../widgets/market_ui.dart';

// Legacy HomeScreen moved to lib/screens/home/home_screen.dart
class LegacyHomeScreen extends StatefulWidget {
  const LegacyHomeScreen({super.key});

  @override
  State<LegacyHomeScreen> createState() => _LegacyHomeScreenState();
}

class _LegacyHomeScreenState extends State<LegacyHomeScreen> {
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
    final target = '${store.category} ${store.displayCategory} ${store.badge}'
        .toLowerCase();
    if (cat == 'pakaian') {
      return target.contains('pakaian') ||
          target.contains('baju') ||
          target.contains('mainan & baju');
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
        final matchesCat =
            _activeCategory == null ||
            _matchesCategory(store, _activeCategory!);
        final matchesSearch =
            query.isEmpty ||
            '${store.name} ${store.displayCategory} ${store.badge} ${store.category}'
                .toLowerCase()
                .contains(query);
        return matchesCat && matchesSearch;
      }).toList();
    } else {
      displayedStores = defaultStoreIds
          .map(
            (id) => marketStores.firstWhere(
              (s) => s.id == id,
              orElse: () => marketStores.first,
            ),
          )
          .toList();
    }

    return MarketPage(
      background: MarketColors.background,
      child: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 105),
            children: [
              // 1. Header: logo gradasi dengan ikon awan + nama pasar
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [MarketColors.yellow, MarketColors.green],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x334B6515),
                          blurRadius: 7,
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
                    color: MarketColors.green.withValues(alpha: .65),
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
                constraints: const BoxConstraints(minHeight: 176),
                padding: const EdgeInsets.fromLTRB(20, 18, 14, 18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [MarketColors.green, MarketColors.yellow],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x304B6515),
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
                              fontSize: 19.5,
                              fontWeight: FontWeight.w800,
                              height: 1.15,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Temukan berbagai toko menarik\ndi PasarKu',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.95),
                              fontSize: 11.5,
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 12),
                          InkWell(
                            onTap: () => goTo(context, '/toko'),
                            borderRadius: BorderRadius.circular(999),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 8,
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
                                        color: MarketColors.greenDark,
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 13,
                                      color: MarketColors.greenDark,
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
                    border: Border.all(color: MarketColors.brown, width: 1),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x40594045),
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
                              width: 138,
                              height: 100,
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
                                          color: MarketColors.brown,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isMarketFavorite =
                                              !_isMarketFavorite;
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                              SnackBar(
                                                duration: const Duration(
                                                  seconds: 1,
                                                ),
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
                                            : MarketColors.brown,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                const Text(
                                  'Pusat Belanja dan Kuliner\nTradisional di Tengah Kota',
                                  style: TextStyle(
                                    color: MarketColors.yellow,
                                    fontSize: 10,
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
                                    fontSize: 10,
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
                          vertical: 9,
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
                  border: Border.all(color: MarketColors.brown, width: 1),
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
                        greenAccent: true,
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
                        greenAccent: true,
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
                      greenAccent: false,
                      isSelected: _activeCategory == 'Pakaian',
                      onTap: () => setState(() {
                        _activeCategory = _activeCategory == 'Pakaian'
                            ? null
                            : 'Pakaian';
                      }),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _CategoryBox(
                      name: 'Sembako',
                      icon: Icons.shopping_basket_rounded,
                      greenAccent: true,
                      isSelected: _activeCategory == 'Sembako',
                      onTap: () => setState(() {
                        _activeCategory = _activeCategory == 'Sembako'
                            ? null
                            : 'Sembako';
                      }),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _CategoryBox(
                      name: 'Makanan',
                      icon: Icons.soup_kitchen_rounded,
                      greenAccent: false,
                      isSelected: _activeCategory == 'Makanan',
                      onTap: () => setState(() {
                        _activeCategory = _activeCategory == 'Makanan'
                            ? null
                            : 'Makanan';
                      }),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _CategoryBox(
                      name: 'Perabotan',
                      icon: Icons.work_outline_rounded,
                      greenAccent: true,
                      isSelected: _activeCategory == 'Perabotan',
                      onTap: () => setState(() {
                        _activeCategory = _activeCategory == 'Perabotan'
                            ? null
                            : 'Perabotan';
                      }),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _CategoryBox(
                      name: 'Lainnya',
                      icon: Icons.more_horiz_rounded,
                      greenAccent: false,
                      isSelected: _activeCategory == 'Lainnya',
                      onTap: () => setState(() {
                        _activeCategory = _activeCategory == 'Lainnya'
                            ? null
                            : 'Lainnya';
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
                    mainAxisExtent: 265,
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
                  gradient: const LinearGradient(
                    colors: [Colors.white, Color(0xFFF5F8E9)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: MarketColors.green, width: 1),
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
                                  color: const Color(0xFFEAF3D4),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  Icons.calendar_month_rounded,
                                  size: 15,
                                  color: MarketColors.greenDark,
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
                                  color: MarketColors.green,
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
                                        color: MarketColors.brown,
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 12,
                                      color: MarketColors.brown,
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
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
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
          final active = item.$1 == 'Home';
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
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFEAF3D4),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 14, color: MarketColors.greenDark),
          ),
          const SizedBox(width: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 9,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                main,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1F2937),
                ),
              ),
              Text(
                sub,
                style: const TextStyle(fontSize: 9, color: Color(0xFF9CA3AF)),
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
    this.greenAccent = false,
  });

  final String label;
  final IconData icon;
  final String route;
  final bool greenAccent;

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
            decoration: BoxDecoration(
              color: greenAccent
                  ? const Color(0xFFEAF3D4)
                  : const Color(0xFFFFF0C2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 20,
              color: greenAccent ? MarketColors.greenDark : MarketColors.brown,
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
    required this.greenAccent,
    required this.isSelected,
    required this.onTap,
  });

  final String name;
  final IconData icon;
  final bool greenAccent;
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
            color: isSelected ? MarketColors.green : MarketColors.brown,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0x30C2DC80)
                  : const Color(0x10594045),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 38,
              height: 38,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: greenAccent
                    ? const Color(0xFFEAF3D4)
                    : const Color(0xFFFFF0C2),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                icon,
                size: 21,
                color: greenAccent
                    ? MarketColors.greenDark
                    : MarketColors.brown,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              name,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? MarketColors.greenDark : MarketColors.brown,
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
                color: MarketColors.greenDark,
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
                    border: Border.all(color: MarketColors.greenDark, width: 3),
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
                    border: Border.all(color: MarketColors.greenDark, width: 3),
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
                      color: MarketColors.greenDark,
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
                color: const Color(0xFFFFF0C2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: MarketColors.yellow, width: 2.5),
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
                      color: const Color(0xFFFFF0C2),
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(color: MarketColors.yellow, width: 2),
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
                      color: const Color(0xFFFFF0C2),
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(color: MarketColors.yellow, width: 2),
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
                color: MarketColors.green,
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
                color: MarketColors.greenDark,
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
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: MarketColors.green, width: 1),
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
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: SizedBox(
              height: 122,
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
                        color: MarketColors.greenDark,
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
                      color: MarketColors.yellow,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      store.rating,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        color: MarketColors.yellow,
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
                        color: Color(0x35FBBF24),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () => goTo(context, '/detail-toko/${store.id}'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MarketColors.yellow,
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

// StoreListScreen moved to lib/screens/store_list/store_list_screen.dart
class LegacyStoreListScreen extends StatefulWidget {
  const LegacyStoreListScreen({this.initialCategory, super.key});

  final String? initialCategory;

  @override
  State<LegacyStoreListScreen> createState() => _LegacyStoreListScreenState();
}

class _LegacyStoreListScreenState extends State<LegacyStoreListScreen> {
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 16,
                ),
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
                      (
                        'Makanan',
                        Icons.restaurant_rounded,
                        Color(0xFFD97706),
                        Color(0xFFFDE68A),
                        Color(0x40F59E0B),
                      ),
                      (
                        'Sayur\n& Buah',
                        Icons.eco_rounded,
                        Color(0xFF15803D),
                        Color(0xFFDCFCE7),
                        Color(0x3510B981),
                      ),
                      (
                        'Kuliner\nLegend',
                        Icons.restaurant_menu_rounded,
                        Color(0xFFEA580C),
                        Color(0xFFFED7AA),
                        Color(0x40F97316),
                      ),
                      (
                        'Daging\n& Ikan',
                        Icons.set_meal_rounded,
                        Color(0xFF047857),
                        Color(0xFFD1FAE5),
                        Color(0x3510B981),
                      ),
                      (
                        'Sembako\n& Perabotan',
                        Icons.shopping_basket_rounded,
                        Color(0xFFEA580C),
                        Color(0xFFFED7AA),
                        Color(0x40F97316),
                      ),
                      (
                        'Mainan\n& Baju',
                        Icons.rocket_launch_rounded,
                        Color(0xFF15803D),
                        Color(0xFFDCFCE7),
                        Color(0x3510B981),
                      ),
                    ];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(categoryData.length, (index) {
                        final cat = categoryData[index];
                        final catName = cat.$1;
                        final isSelected =
                            _activeCategory != null &&
                            catName
                                .replaceAll('\n', ' ')
                                .toLowerCase()
                                .contains(
                                  _activeCategory!
                                      .toLowerCase()
                                      .split(' ')
                                      .first,
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
                                    color: cat.$4,
                                    shape: BoxShape.circle,
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: (index % 2 == 0)
                                                  ? const Color(0x738BC34A) // hijau muda untuk background kuning
                                                  : const Color(0x59FFC107), // kuning keemasan untuk background hijau muda
                                              blurRadius: 10,
                                              offset: const Offset(0, 6),
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Icon(cat.$2, size: 21, color: cat.$3),
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
            bottom: 16,
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
          final active = item.$1 == 'Toko';
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
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
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
                    onPressed: () => goTo(context, '/detail-toko/${store.id}'),
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

// StoreDetailScreen has been moved to lib/screens/store_detail/store_detail_screen.dart
// and is exported from there.

