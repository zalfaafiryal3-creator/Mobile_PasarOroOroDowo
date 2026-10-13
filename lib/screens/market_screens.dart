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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    final matchingStores = marketStores.where((store) {
      final matchesCategory = _activeCategory == null ||
          store.category.toLowerCase() == _activeCategory!.toLowerCase() ||
          store.badge.toLowerCase().contains(_activeCategory!.toLowerCase()) ||
          store.displayCategory.toLowerCase().contains(_activeCategory!.toLowerCase());
      final matchesSearch = query.isEmpty ||
          '${store.name} ${store.displayCategory} ${store.badge}'
              .toLowerCase()
              .contains(query);
      return matchesCategory && matchesSearch;
    }).toList();

    return MarketPage(
      background: const Color(0xFFE1EDBF),
      child: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            children: [
              // 1. Header: Logo kuning dengan awan putih + Teks "Pasar Oro-Oro Dowo"
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFC21C),
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
                      color: Color(0xFF594045),
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Search Bar: Kapsul putih dengan border hijau muda tipis
              Container(
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: const Color(0x66C2DC80),
                    width: 1.2,
                  ),
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

              // 2. Kategori Belanja heading + chevron
              InkWell(
                onTap: () => goTo(context, '/toko'),
                child: const Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Kategori Belanja',
                        style: TextStyle(
                          color: Color(0xFF594045),
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: Color(0xFF594045),
                      size: 22,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Kategori Card Putih dengan Shadow cokelat keabu-abuan (6 Kategori)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x35594045),
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

              // 3. Daftar Toko Heading
              const Text(
                'Daftar Toko',
                style: TextStyle(
                  color: Color(0xFF594045),
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 14),

              // Grid Toko (2 Kolom)
              if (matchingStores.isEmpty)
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
                  itemCount: matchingStores.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 16,
                    mainAxisExtent: 288,
                  ),
                  itemBuilder: (context, index) {
                    final store = matchingStores[index];
                    return InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () => goTo(context, '/detail-toko/${store.id}'),
                      child: _HomeStoreCard(store: store),
                    );
                  },
                ),
            ],
          ),

          // Floating Bottom Navigation
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
            spreadRadius: 0,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.map((item) {
          final active = item.$1 == 'Home';
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

class _HomeStoreCard extends StatelessWidget {
  const _HomeStoreCard({required this.store});

  final StoreData store;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x28594045),
            blurRadius: 20,
            offset: Offset(0, 10),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Foto toko dengan badge kategori hijau tua
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
                        color: const Color(0xFF4B6515),
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
                // Tombol Lihat Toko kuning-oranye berbentuk kapsul dengan bayangan lembut
                Container(
                  width: double.infinity,
                  height: 38,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x66FFC21C),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () =>
                        goTo(context, '/detail-toko/${store.id}'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFC21C),
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
