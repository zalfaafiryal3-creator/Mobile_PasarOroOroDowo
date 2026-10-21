import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/market_data.dart';
import '../../widgets/market_ui.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory;
  bool _isFavorite = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _matchesCategory(StoreData store, String category) {
    final cat = category.toLowerCase();
    final target =
        '${store.category} ${store.displayCategory} ${store.badge}'
            .toLowerCase();
    if (cat == 'pakaian') {
      return target.contains('pakaian') ||
          target.contains('baju') ||
          target.contains('mainan & baju');
    } else if (cat == 'sembako') {
      return target.contains('sembako');
    } else if (cat == 'makanan') {
      return target.contains('makanan') || target.contains('kuliner');
    } else if (cat == 'perabotan') {
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

    const defaultStoreIds = [
      'lumpur-kentang-27',
      'bakso-goreng-bangkit',
      'klepon-ku',
      'wiwit-sayur',
    ];

    final List<StoreData> displayedStores;
    if (query.isNotEmpty || _selectedCategory != null) {
      displayedStores = marketStores.where((store) {
        final matchesCat =
            _selectedCategory == null ||
            _matchesCategory(store, _selectedCategory!);
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
      background: Colors.white,
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFBFDF6),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0x40C2DC80), // rgba(194, 220, 128, 0.25)
              Color(0x20C2DC80),
              Colors.white,
            ],
          ),
          border: Border.symmetric(
            vertical: BorderSide(
              color: Color(0x33EA9CAF),
              width: 1,
            ),
          ),
        ),
        child: Stack(
          children: [
            // Scrollable Content
            Positioned.fill(
              child: CustomScrollView(
                slivers: [
                  // Top Header as pinned/scrollable
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildBrandHeader(),
                          const SizedBox(height: 12),
                          _buildSearchBar(),
                        ],
                      ),
                    ),
                  ),

                  // Main Content List
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _buildHeroBanner(context),
                        const SizedBox(height: 16),
                        _buildMarketHighlightCard(),
                        const SizedBox(height: 16),
                        _buildFeatureGrid(context),
                        const SizedBox(height: 16),
                        _buildCategorySection(context),
                        const SizedBox(height: 16),
                        _buildStoreListSection(context, displayedStores),
                        const SizedBox(height: 16),
                        _buildPlanVisitCallout(context),
                      ]),
                    ),
                  ),
                ],
              ),
            ),

            // Floating Bottom Navigation Bar
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: _buildBottomNavigationBar(context),
            ),
          ],
        ),
      ),
    );
  }

  // --- BRAND HEADER ---
  Widget _buildBrandHeader() {
    return Row(
      children: [
        // Brand Logo Icon Shape (Figma #495:733)
        Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFBBF24), Color(0xFFC2DC80)],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x66C2DC80),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
              BoxShadow(
                color: Color(0x33D56989),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: SvgPicture.string(
            '''<svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M9.99996 1.66667C8.15901 1.66667 6.66663 3.15905 6.66663 5C6.66754 5.56269 6.81088 6.11598 7.08329 6.60833C6.40046 6.4046 5.67032 6.42504 4.99996 6.66667C3.15901 6.66667 1.66663 8.15905 1.66663 10C1.66663 11.841 3.15901 13.3333 4.99996 13.3333C5.75656 13.3351 6.49125 13.0794 7.08329 12.6083C7.4676 13.9319 8.6268 14.8824 9.99996 15C11.3731 14.8824 12.5323 13.9319 12.9166 12.6083C13.5087 13.0794 14.2434 13.3351 15 13.3333C16.8409 13.3333 18.3333 11.841 18.3333 10C18.3272 8.64721 17.504 7.43229 16.25 6.925C16.0743 6.15559 15.6314 5.47346 15 5C15 3.15905 13.5076 1.66667 11.6666 1.66667L9.99996 1.66667" fill="white"/>
</svg>''',
            width: 20,
            height: 20,
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          'Pasar Oro-Oro Dowo',
          style: TextStyle(
            color: Color(0xFF594045),
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.6,
          ),
        ),
      ],
    );
  }

  // --- SEARCH BAR ---
  Widget _buildSearchBar() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: const Color(0xFFC2DC80), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (_) => setState(() {}),
        style: const TextStyle(fontSize: 13, color: Color(0xFF1F2937)),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 14, right: 10),
            child: SvgPicture.string(
              '''<svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M14 14L11.1067 11.1067" stroke-width="1.33333" stroke-linecap="round" stroke-linejoin="round" stroke="#9CA3AF"/>
<path d="M2 7.33333C2 10.2769 4.38979 12.6667 7.33333 12.6667C10.2769 12.6667 12.6667 10.2769 12.6667 7.33333C12.6667 4.38979 10.2769 2 7.33333 2C4.38979 2 2 4.38979 2 7.33333V7.33333" stroke-width="1.33333" stroke-linecap="round" stroke-linejoin="round" stroke="#9CA3AF"/>
</svg>''',
              width: 16,
              height: 16,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 16),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 16, color: Color(0xFF9CA3AF)),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                )
              : null,
          hintText: 'Cari toko, produk, atau pedagang...',
          hintStyle: const TextStyle(
            color: Color(0xFF9CA3AF),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  // --- HERO BANNER ---
  Widget _buildHeroBanner(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [Color(0xFFC2DC80), Color(0xFFC2DC80), Color(0xE6FBBF24)],
                stops: [0.0, 0.5, 1.0],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 6,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              clipBehavior: Clip.antiAlias,
              children: [
                // Decorative blur circles
                Positioned(
                  left: -30,
                  top: -30,
                  child: Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                ),
                Positioned(
                  right: -20,
                  bottom: -20,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFC2DC80).withValues(alpha: 0.3),
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Text Column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Pilih\nToko Favoritmu',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              height: 1.25,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            'Temukan berbagai toko menarik\ndi PasarKu',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.95),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 12),
                          InkWell(
                            onTap: () => goTo(context, '/toko'),
                            borderRadius: BorderRadius.circular(9999),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(9999),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x40FBBF24),
                                    blurRadius: 6,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Jelajahi Sekarang',
                                    style: TextStyle(
                                      color: Color(0xFFFBBF24),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  SvgPicture.string(
                                    '''<svg width="14" height="14" viewBox="0 0 14 14" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M2.91663 7H11.0833" stroke-width="1.16667" stroke-linecap="round" stroke-linejoin="round" stroke="#FBBF24"/>
<path d="M7 2.91666L11.0833 6.99999L7 11.0833" stroke-width="1.16667" stroke-linecap="round" stroke-linejoin="round" stroke="#FBBF24"/>
</svg>''',
                                    width: 14,
                                    height: 14,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Cute 3D Shopping bag graphic
                    SizedBox(
                      width: 96,
                      height: 112,
                      child: SvgPicture.string(
                        '''<svg width="96" height="112" viewBox="0 0 96 112" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M30 41C30 17 66 17 66 41" stroke-width="5.4" stroke-linecap="round" stroke="#F3EEF1"/>
<path d="M31.2 41C31.2 18.8 64.8 18.8 64.8 41" stroke-width="2.4" stroke-linecap="round" stroke="#594045"/>
<path d="M25.8 35H70.2C76.1647 35 81 39.8353 81 45.8V90.2C81 96.1647 76.1647 101 70.2 101H25.8C19.8353 101 15 96.1647 15 90.2V45.8C15 39.8353 19.8353 35 25.8 35V35" fill="white"/>
<path d="M15 41L24 101H72L81 41H15" fill="#C2DC80" fill-opacity="0.3"/>
<path d="M27 35L19.2 101" stroke-width="1.2" stroke="#4B6515"/>
<path d="M69 35L76.8 101" stroke-width="1.2" stroke="#4B6515"/>
<path d="M48 74C48 74 37.2 65 37.2 57.2C37.2 52.4 40.8 49.4 45 49.4C48 49.4 48 52.4 48 52.4C48 52.4 48 49.4 51 49.4C55.2 49.4 58.8 52.4 58.8 57.2C58.8 65 48 74 48 74V74" fill="#4B6515"/>
<path d="M81.6 23C81.6 24.3246 82.6754 25.4 84 25.4C85.3246 25.4 86.4 24.3246 86.4 23C86.4 21.6754 85.3246 20.6 84 20.6C82.6754 20.6 81.6 21.6754 81.6 23V23" fill="#4B6515"/>
<path d="M84 17V23M84 23V29M84 23H78M84 23H90" stroke-width="1.2" stroke-linecap="round" stroke="#4B6515"/>
</svg>''',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Carousel indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 16,
                height: 6,
                decoration: BoxDecoration(
                  color: const Color(0xFF594045),
                  borderRadius: BorderRadius.circular(9999),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: const Color(0xFF594045).withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: const Color(0xFF594045).withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: const Color(0xFF594045).withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- MARKET HIGHLIGHT CARD ---
  Widget _buildMarketHighlightCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF594045), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x35351903),
            blurRadius: 10,
            offset: Offset(2, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Market Gate Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    width: 120,
                    height: 96,
                    child: Image.network(
                      'https://api.builder.io/api/v1/image/assets/TEMP/8c7f14c72ec963e2a06640867a91ad0b7f072074?width=264',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const MarketAsset('1377a.png', fit: BoxFit.cover),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Market Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Text(
                              'Pasar Oro-Oro Dowo',
                              style: TextStyle(
                                color: Color(0xFF594045),
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isFavorite = !_isFavorite;
                              });
                            },
                            child: SvgPicture.string(
                              '''<svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M1.33331 6.33332C1.33334 4.81462 2.26961 3.45312 3.68772 2.90959C5.10583 2.36606 6.71224 2.75302 7.72731 3.88266C7.79791 3.95814 7.89663 4.00098 7.99998 4.00098C8.10333 4.00098 8.20205 3.95814 8.27265 3.88266C9.28473 2.74546 10.8951 2.35348 12.3166 2.89831C13.7381 3.44314 14.6739 4.811 14.6666 6.33332C14.6666 7.85999 13.6666 8.99999 12.6666 9.99999L9.00531 13.542C8.75402 13.8306 8.39084 13.9973 8.00817 13.9998C7.6255 14.0022 7.26024 13.8401 7.00531 13.5547L3.33331 9.99999C2.33331 8.99999 1.33331 7.86666 1.33331 6.33332" stroke-width="1.33333" stroke-linecap="round" stroke-linejoin="round" stroke="${_isFavorite ? '#E11D48' : '#594045'}" fill="${_isFavorite ? '#E11D48' : 'none'}"/>
</svg>''',
                              width: 16,
                              height: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Pusat Belanja dan Kuliner\nTradisional di Tengah Kota',
                        style: TextStyle(
                          color: Color(0xFFFBBF24),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Pasar yang sudah berdiri sejak lama dan menjadi ikon belanja masyarakat dengan beragam produk, harga...',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 10,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom Stats Strip (3 stats)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0x99F3EEF1),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(23)),
              border: Border(
                top: BorderSide(color: Color(0xFFF3EEF1), width: 1),
              ),
            ),
            child: Row(
              children: [
                // Item 1: Jam Buka
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Color(0x40C2DC80),
                          shape: BoxShape.circle,
                        ),
                        child: SvgPicture.string(
                          '''<svg width="14" height="14" viewBox="0 0 14 14" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M1.16663 6.99999C1.16663 10.2195 3.78045 12.8333 6.99996 12.8333C10.2195 12.8333 12.8333 10.2195 12.8333 6.99999C12.8333 3.78049 10.2195 1.16666 6.99996 1.16666C3.78045 1.16666 1.16663 3.78049 1.16663 6.99999V6.99999" stroke-width="1.16667" stroke-linecap="round" stroke-linejoin="round" stroke="#4B6515"/>
<path d="M7 3.5V7L9.33333 8.16667" stroke-width="1.16667" stroke-linecap="round" stroke-linejoin="round" stroke="#4B6515"/>
</svg>''',
                          width: 14,
                          height: 14,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jam Buka',
                            style: TextStyle(
                              color: Color(0xFF9CA3AF),
                              fontSize: 9,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            '06.00 - 17.00',
                            style: TextStyle(
                              color: Color(0xFF594045),
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Setiap Hari',
                            style: TextStyle(
                              color: Color(0xFF9CA3AF),
                              fontSize: 8.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 36,
                  color: const Color(0xFFF3F4F6),
                ),

                // Item 2: Jumlah Pedagang
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: Color(0x40C2DC80),
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.string(
                            '''<svg width="14" height="14" viewBox="0 0 14 14" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M9.33329 12.25V11.0833C9.33329 9.79553 8.28776 8.75 6.99996 8.75H3.49996C2.21216 8.75 1.16663 9.79553 1.16663 11.0833V12.25" stroke-width="1.16667" stroke-linecap="round" stroke-linejoin="round" stroke="#4B6515"/>
<path d="M9.33331 1.82468C10.3624 2.09147 11.0811 3.0202 11.0811 4.08334C11.0811 5.14649 10.3624 6.07521 9.33331 6.34201" stroke-width="1.16667" stroke-linecap="round" stroke-linejoin="round" stroke="#4B6515"/>
<path d="M12.8333 12.25V11.0833C12.8325 10.02 12.1129 9.09164 11.0833 8.82581" stroke-width="1.16667" stroke-linecap="round" stroke-linejoin="round" stroke="#4B6515"/>
<path d="M2.91669 4.08333C2.91669 5.37113 3.96222 6.41667 5.25002 6.41667C6.53782 6.41667 7.58335 5.37113 7.58335 4.08333C7.58335 2.79553 6.53782 1.75 5.25002 1.75C3.96222 1.75 2.91669 2.79553 2.91669 4.08333H2.91669" stroke-width="1.16667" stroke-linecap="round" stroke-linejoin="round" stroke="#4B6515"/>
</svg>''',
                            width: 14,
                            height: 14,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Jumlah Pedagang',
                              style: TextStyle(
                                color: Color(0xFF9CA3AF),
                                fontSize: 9,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              '± 251',
                              style: TextStyle(
                                color: Color(0xFF594045),
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Pedagang',
                              style: TextStyle(
                                color: Color(0xFF9CA3AF),
                                fontSize: 8.5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 36,
                  color: const Color(0xFFF3F4F6),
                ),

                // Item 3: Lokasi
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: Color(0x66C2DC80),
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.string(
                            '''<svg width="14" height="14" viewBox="0 0 14 14" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M11.6666 5.83332C11.6666 8.74591 8.43556 11.7792 7.35056 12.7161C7.14292 12.8722 6.85704 12.8722 6.6494 12.7161C5.5644 11.7792 2.33331 8.74591 2.33331 5.83332C2.33331 3.25772 4.42438 1.16666 6.99998 1.16666C9.57558 1.16666 11.6666 3.25772 11.6666 5.83332" stroke-width="1.16667" stroke-linecap="round" stroke-linejoin="round" stroke="#4B6515"/>
<path d="M5.25 5.83334C5.25 6.79919 6.03415 7.58334 7 7.58334C7.96585 7.58334 8.75 6.79919 8.75 5.83334C8.75 4.86749 7.96585 4.08334 7 4.08334C6.03415 4.08334 5.25 4.86749 5.25 5.83334V5.83334" stroke-width="1.16667" stroke-linecap="round" stroke-linejoin="round" stroke="#4B6515"/>
</svg>''',
                            width: 14,
                            height: 14,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Lokasi',
                                style: TextStyle(
                                  color: Color(0xFF9CA3AF),
                                  fontSize: 9,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                'Klojen, Kota Malang',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Color(0xFF594045),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  height: 1.15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

  // --- FEATURE GRID (5 Quick Actions) ---
  Widget _buildFeatureGrid(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF594045), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // 1. Denah Pasar
          _buildFeatureItem(
            context,
            label: 'Denah\nPasar',
            route: '/denah',
            bgColor: const Color(0x4DFBBF24),
            iconSvg: '''<svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M9.404 3.70197C9.77922 3.88947 10.2208 3.88947 10.596 3.70197L13.0353 2.48197C13.2421 2.37862 13.4877 2.38981 13.6843 2.51152C13.8809 2.63324 14.0003 2.84811 14 3.0793V11.5886C13.9999 11.8411 13.8572 12.0718 13.6313 12.1846L10.596 13.7026C10.2208 13.8901 9.77922 13.8901 9.404 13.7026L6.596 12.2986C6.22079 12.1111 5.77922 12.1111 5.404 12.2986L2.96467 13.5186C2.75775 13.622 2.51202 13.6108 2.31541 13.4889C2.11881 13.367 1.99943 13.152 2 12.9206V4.41197C2.00014 4.15953 2.14285 3.92881 2.36867 3.81597L5.404 2.29797C5.77922 2.11047 6.22079 2.11047 6.596 2.29797L9.404 3.70197" stroke-width="1.33333" stroke-linecap="round" stroke-linejoin="round" stroke="#F59E0B"/>
<path d="M10 3.84265V13.8427" stroke-width="1.33333" stroke-linecap="round" stroke-linejoin="round" stroke="#F59E0B"/>
<path d="M6 2.15735V12.1573" stroke-width="1.33333" stroke-linecap="round" stroke-linejoin="round" stroke="#F59E0B"/>
</svg>''',
          ),

          // 2. AI perencana
          _buildFeatureItem(
            context,
            label: 'AI\nPerencana',
            route: '/chatbot-rekomendasi',
            bgColor: const Color(0x4DC2DC80),
            iconSvg: '''<svg width="20" height="20" viewBox="0 0 25 22" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M7.60673 15.0701H10.4026L14.9859 10.4867C15.1234 10.3492 15.2265 10.1926 15.2953 10.0169C15.364 9.84125 15.3984 9.66937 15.3984 9.50132C15.3984 9.33326 15.3602 9.16903 15.2838 9.00861C15.2074 8.84819 15.1081 8.69923 14.9859 8.56174L14.1609 7.6909C14.0234 7.5534 13.8706 7.45028 13.7026 7.38153C13.5345 7.31278 13.3588 7.2784 13.1755 7.2784C13.0074 7.2784 12.8355 7.31278 12.6599 7.38153C12.4842 7.45028 12.3276 7.5534 12.1901 7.6909L7.60673 12.2742V15.0701V15.0701M14.0234 9.50132V9.50132L13.1755 8.6534V8.6534L14.0234 9.50132V9.50132M8.98173 13.6951V12.8242L11.2963 10.5097L11.7546 10.9222L12.1671 11.3805L9.85256 13.6951H8.98173V13.6951M11.7546 10.9222L12.1671 11.3805V11.3805L11.2963 10.5097V10.5097L11.7546 10.9222V10.9222M12.3505 15.0701H18.6067V13.2367H14.1838L12.3505 15.0701V15.0701M3.94006 22.4034V5.9034C3.94006 5.39924 4.11958 4.96764 4.47861 4.60861C4.83763 4.24958 5.26923 4.07007 5.7734 4.07007H20.4401C20.9442 4.07007 21.3758 4.24958 21.7349 4.60861C22.0939 4.96764 22.2734 5.39924 22.2734 5.9034V16.9034C22.2734 17.4076 22.0939 17.8392 21.7349 18.1982C21.3758 18.5572 20.9442 18.7367 20.4401 18.7367H7.60673L3.94006 22.4034V22.4034M6.82756 16.9034H20.4401V16.9034V16.9034V5.9034V5.9034V5.9034H5.7734V5.9034V5.9034V17.9347L6.82756 16.9034V16.9034M5.7734 16.9034V16.9034V5.9034V5.9034V5.9034V5.9034V5.9034V5.9034V16.9034V16.9034V16.9034V16.9034V16.9034" fill="#4B6515"/>
</svg>''',
          ),

          // 3. Fasilitas
          _buildFeatureItem(
            context,
            label: 'Fasilitas',
            route: '/fasilitas-pasar',
            bgColor: const Color(0x4DFBBF24),
            iconSvg: '''<svg width="17" height="17" viewBox="0 0 17 17" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M7.43339 15.8909V5.89086H1.19109C0.956182 5.89086 0.80514 5.78118 0.73796 5.56182C0.67078 5.34247 0.732148 5.16727 0.922064 5.03623L7.79254 0.186595C7.96524 0.0621982 8.14822 0 8.34145 0C8.53469 0 8.71766 0.0621982 8.89037 0.186595L15.7608 5.03623C15.9508 5.16727 16.0121 5.34247 15.9449 5.56182C15.8778 5.78118 15.7267 5.89086 15.4918 5.89086H9.24952V15.8909C9.24952 16.1469 9.16218 16.3622 8.98751 16.5369C8.81285 16.7116 8.59749 16.7989 8.34145 16.7989C8.08541 16.7989 7.87006 16.7116 7.69539 16.5369C7.52072 16.3622 7.43339 16.1469 7.43339 15.8909ZM0.53755 15.8909V12.3592L0.0167162 9.50997C-0.0282718 9.25393 0.0175466 9.02733 0.154171 8.83017C0.290796 8.633 0.487128 8.51027 0.743167 8.46196C0.988639 8.41365 1.21343 8.46128 1.41753 8.60485C1.62164 8.74842 1.74619 8.94294 1.79118 9.18841L2.2554 11.6495H4.8188C5.08481 11.6495 5.30929 11.7409 5.49226 11.9239C5.67524 12.1069 5.76672 12.3314 5.76672 12.5974V15.8909C5.76672 16.1469 5.67939 16.3622 5.50472 16.5369C5.33005 16.7116 5.1147 16.7989 4.85866 16.7989C4.60262 16.7989 4.38644 16.7108 4.21011 16.5344C4.03378 16.3581 3.94561 16.1419 3.94561 15.8859V13.4656H2.35368V15.8909C2.35368 16.1469 2.26634 16.3622 2.09167 16.5369C1.91701 16.7116 1.70165 16.7989 1.44561 16.7989C1.18957 16.7989 0.97422 16.7116 0.799552 16.5369C0.624884 16.3622 0.53755 16.1469 0.53755 15.8909ZM10.9162 15.8859V12.5974C10.9162 12.3314 11.0077 12.1069 11.1906 11.9239C11.3736 11.7409 11.5981 11.6495 11.8641 11.6495H14.4275L14.8917 9.18841C14.9367 8.94294 15.0586 8.74842 15.2574 8.60485C15.4563 8.46128 15.6837 8.41365 15.9397 8.46196C16.1958 8.51027 16.3921 8.633 16.5287 8.83017C16.6654 9.02733 16.7112 9.25393 16.6662 9.50997L16.1454 12.3592V15.8909C16.1454 16.1469 16.058 16.3622 15.8834 16.5369C15.7087 16.7116 15.4933 16.7989 15.2373 16.7989C14.9813 16.7989 14.7659 16.7116 14.5912 16.5369C14.4166 16.3622 14.3292 16.1469 14.3292 15.8909V13.4656H12.7373V15.8909C12.7373 16.1469 12.65 16.3622 12.4753 16.5369C12.3006 16.7116 12.0853 16.7989 11.8292 16.7989C11.5732 16.7989 11.357 16.7108 11.1807 16.5344C11.0043 16.3581 10.9162 16.1419 10.9162 15.8859Z" fill="#F59E0B"/>
</svg>''',
          ),

          // 4. Rekomendasi
          _buildFeatureItem(
            context,
            label: 'Rekomendasi',
            route: '/rekomendasi',
            bgColor: const Color(0x40C2DC80),
            iconSvg: '''<svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M2 8C2 11.3115 4.68851 14 8 14C11.3115 14 14 11.3115 14 8C14 4.68851 11.3115 2 8 2C6.32263 2.00631 4.71265 2.66082 3.50667 3.82667L2 5.33333" stroke-width="1.33333" stroke-linecap="round" stroke-linejoin="round" stroke="#4B6515"/>
<path d="M2 2V5.33333H5.33333" stroke-width="1.33333" stroke-linecap="round" stroke-linejoin="round" stroke="#4B6515"/>
<path d="M8 4.66669V8.00002L10.6667 9.33335" stroke-width="1.33333" stroke-linecap="round" stroke-linejoin="round" stroke="#4B6515"/>
</svg>''',
          ),

          // 5. Info Kunjungan
          _buildFeatureItem(
            context,
            label: 'Info\nKunjungan',
            route: '/info-kunjungan',
            bgColor: const Color(0x4DFBBF24),
            iconSvg: '''<svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M1.33331 7.99998C1.33331 11.6794 4.32055 14.6666 7.99998 14.6666C11.6794 14.6666 14.6666 11.6794 14.6666 7.99998C14.6666 4.32055 11.6794 1.33331 7.99998 1.33331C4.32055 1.33331 1.33331 4.32055 1.33331 7.99998V7.99998" stroke-width="1.33333" stroke-linecap="round" stroke-linejoin="round" stroke="#F59E0B"/>
<path d="M8 10.6667V8" stroke-width="1.33333" stroke-linecap="round" stroke-linejoin="round" stroke="#F59E0B"/>
<path d="M8 5.33331H8.00667" stroke-width="1.33333" stroke-linecap="round" stroke-linejoin="round" stroke="#F59E0B"/>
</svg>''',
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(
    BuildContext context, {
    required String label,
    required String route,
    required Color bgColor,
    required String iconSvg,
  }) {
    return InkWell(
      onTap: () => goTo(context, route),
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: SvgPicture.string(iconSvg),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF374151),
                fontSize: 9.5,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- CATEGORY SECTION ---
  Widget _buildCategorySection(BuildContext context) {
    const categories = [
      {'name': 'Pakaian', 'color': Color(0x80FBBF24), 'isGreen': false},
      {'name': 'Sembako', 'color': Color(0x4DC2DC80), 'isGreen': true},
      {'name': 'Makanan', 'color': Color(0x80FBBF24), 'isGreen': false},
      {'name': 'Perabotan', 'color': Color(0x4DC2DC80), 'isGreen': true},
      {'name': 'Lainnya', 'color': Color(0x80FBBF24), 'isGreen': false},
    ];

    return Column(
      children: [
        // Section Title Bar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Kategori Belanja',
              style: TextStyle(
                color: Color(0xFF594045),
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.4,
              ),
            ),
            InkWell(
              onTap: () => goTo(context, '/toko'),
              child: const Row(
                children: [
                  Text(
                    'Lihat Semua',
                    style: TextStyle(
                      color: Color(0xFF594045),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 11,
                    color: Color(0xFF594045),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Horizontal Category Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: categories.map((cat) {
            final isSelected = _selectedCategory == cat['name'];
            final name = cat['name'] as String;
            final overlayColor = cat['color'] as Color;

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (_selectedCategory == name) {
                      _selectedCategory = null;
                    } else {
                      _selectedCategory = name;
                    }
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFF0F7DF)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF4B6515)
                          : const Color(0xFF594045),
                      width: isSelected ? 1.5 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isSelected
                            ? const Color(0x204B6515)
                            : const Color(0x08000000),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: overlayColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: _getCategoryIcon(name),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isSelected
                              ? const Color(0xFF4B6515)
                              : const Color(0xFF374151),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _getCategoryIcon(String category) {
    switch (category) {
      case 'Pakaian':
        return SvgPicture.string(
          '''<svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M16.9833 2.88335L13.3333 1.66669C13.3333 3.5064 11.8397 5.00002 9.99995 5.00002C8.16023 5.00002 6.66661 3.5064 6.66661 1.66669L3.01661 2.88335C2.23731 3.14299 1.76337 3.9317 1.89995 4.74169L2.38328 7.63335C2.44883 8.03776 2.7986 8.33453 3.20828 8.33335H4.99995V16.6667C4.99995 17.5834 5.74995 18.3334 6.66661 18.3334H13.3333C14.2538 18.3334 14.9999 17.5872 14.9999 16.6667V8.33335H16.7916C17.2013 8.33453 17.5511 8.03776 17.6166 7.63335L18.0999 4.74169C18.2365 3.9317 17.7626 3.14299 16.9833 2.88335V2.88335" stroke-width="1.66667" stroke-linecap="round" stroke-linejoin="round" stroke="#F59E0B"/>
</svg>''',
        );
      case 'Sembako':
        return SvgPicture.string(
          '''<svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M12.5 9.16669L11.6666 16.6667" stroke-width="1.66667" stroke-linecap="round" stroke-linejoin="round" stroke="#4B6515"/>
<path d="M15.8333 9.16665L12.5 3.33331" stroke-width="1.66667" stroke-linecap="round" stroke-linejoin="round" stroke="#4B6515"/>
<path d="M1.66663 9.16669H18.3333" stroke-width="1.66667" stroke-linecap="round" stroke-linejoin="round" stroke="#4B6515"/>
<path d="M2.91663 9.16669L4.24996 15.3334C4.41075 16.1219 5.11202 16.6829 5.91663 16.6667H14.0833C14.8879 16.6829 15.5892 16.1219 15.75 15.3334L17.1666 9.16669" stroke-width="1.66667" stroke-linecap="round" stroke-linejoin="round" stroke="#4B6515"/>
<path d="M3.75 12.9167H16.25" stroke-width="1.66667" stroke-linecap="round" stroke-linejoin="round" stroke="#4B6515"/>
<path d="M4.16663 9.16665L7.49996 3.33331" stroke-width="1.66667" stroke-linecap="round" stroke-linejoin="round" stroke="#4B6515"/>
<path d="M7.5 9.16669L8.33333 16.6667" stroke-width="1.66667" stroke-linecap="round" stroke-linejoin="round" stroke="#4B6515"/>
</svg>''',
        );
      case 'Makanan':
        return SvgPicture.string(
          '''<svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M13.3333 1.66669L11.4167 3.58335C10.4638 4.55546 10.4638 6.11124 11.4167 7.08335L12.9167 8.58335C13.8888 9.53621 15.4446 9.53621 16.4167 8.58335L18.3333 6.66669" stroke-width="1.66667" stroke-linecap="round" stroke-linejoin="round" stroke="#F59E0B"/>
<path d="M12.5 12.5L2.74997 2.75C2.07809 3.40831 1.69946 4.30936 1.69946 5.25C1.69946 6.19064 2.07809 7.09169 2.74997 7.75L8.83331 13.8333C9.41664 14.4167 10.5 14.4167 11.1666 13.8333L12.5 12.5V12.5M12.5 12.5L18.3333 18.3333" stroke-width="1.66667" stroke-linecap="round" stroke-linejoin="round" stroke="#F59E0B"/>
<path d="M1.75 18.1667L7.08333 12.9167" stroke-width="1.66667" stroke-linecap="round" stroke-linejoin="round" stroke="#F59E0B"/>
<path d="M15.8333 4.16669L10 10" stroke-width="1.66667" stroke-linecap="round" stroke-linejoin="round" stroke="#F59E0B"/>
</svg>''',
        );
      case 'Perabotan':
        return SvgPicture.string(
          '''<svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M13.3334 16.6667V3.33335C13.3334 2.41288 12.5872 1.66669 11.6667 1.66669H8.33335C7.41288 1.66669 6.66669 2.41288 6.66669 3.33335V16.6667" stroke-width="1.66667" stroke-linecap="round" stroke-linejoin="round" stroke="#4B6515"/>
<path d="M3.33335 5H16.6667C17.5872 5 18.3334 5.74619 18.3334 6.66667V15C18.3334 15.9205 17.5872 16.6667 16.6667 16.6667H3.33335C2.41288 16.6667 1.66669 15.9205 1.66669 15V6.66667C1.66669 5.74619 2.41288 5 3.33335 5V5" stroke-width="1.66667" stroke-linecap="round" stroke-linejoin="round" stroke="#4B6515"/>
</svg>''',
        );
      default:
        return SvgPicture.string(
          '''<svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M9.16669 10C9.16669 10.4599 9.54009 10.8334 10 10.8334C10.4599 10.8334 10.8334 10.4599 10.8334 10C10.8334 9.54009 10.4599 9.16669 10 9.16669C9.54009 9.16669 9.16669 9.54009 9.16669 10V10" stroke-width="1.66667" stroke-linecap="round" stroke-linejoin="round" stroke="#F59E0B"/>
<path d="M15 10C15 10.4599 15.3734 10.8334 15.8333 10.8334C16.2933 10.8334 16.6667 10.4599 16.6667 10C16.6667 9.54009 16.2933 9.16669 15.8333 9.16669C15.3734 9.16669 15 9.54009 15 10V10" stroke-width="1.66667" stroke-linecap="round" stroke-linejoin="round" stroke="#F59E0B"/>
<path d="M3.33331 10C3.33331 10.4599 3.70672 10.8334 4.16665 10.8334C4.62658 10.8334 4.99998 10.4599 4.99998 10C4.99998 9.54009 4.62658 9.16669 4.16665 9.16669C3.70672 9.16669 3.33331 9.54009 3.33331 10V10" stroke-width="1.66667" stroke-linecap="round" stroke-linejoin="round" stroke="#F59E0B"/>
</svg>''',
        );
    }
  }

  // --- STORE LIST SECTION ---
  Widget _buildStoreListSection(BuildContext context, List<StoreData> stores) {
    return Column(
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Daftar Toko',
              style: TextStyle(
                color: Color(0xFF594045),
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.4,
              ),
            ),
            InkWell(
              onTap: () => goTo(context, '/toko'),
              child: const Row(
                children: [
                  Text(
                    'Lihat Semua',
                    style: TextStyle(
                      color: Color(0xFF503321),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 11,
                    color: Color(0xFFD56989),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Store Cards Grid (2 columns)
        if (stores.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Text(
              'Tidak ada toko yang cocok dengan pencarian.',
              style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
            ),
          )
        else
          GridView.builder(
            itemCount: stores.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 12,
              mainAxisExtent: 260,
            ),
            itemBuilder: (context, index) {
              return _buildStoreCard(context, stores[index]);
            },
          ),
      ],
    );
  }

  Widget _buildStoreCard(BuildContext context, StoreData store) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0x4DEA9CAF), // rgba(234, 156, 175, 0.30)
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Store Image + Category Badge
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 116,
              color: const Color(0x40C2DC80), // rgba(194, 220, 128, 0.25)
              child: Stack(
                fit: StackFit.expand,
                children: [
                  MarketAsset(store.image, fit: BoxFit.cover),
                  Positioned(
                    left: 5,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4B6515),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Text(
                        store.badge.isNotEmpty ? store.badge : 'Makanan',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Store Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Column(
                    children: [
                      Text(
                        store.name,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          color: Color(0xFF1F2937),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          height: 1.33,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        store.displayCategory,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          color: Color(0xFF9CA3AF),
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '★ ${store.rating}',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              color: Color(0xFFF59E0B),
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              height: 1.5,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              '|',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: Color(0xFFD1D5DB),
                                fontSize: 10,
                                height: 1.5,
                              ),
                            ),
                          ),
                          Text(
                            store.products,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              color: Color(0xFF6B7280),
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // CTA Button
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: InkWell(
                    onTap: () => goTo(context, '/detail-toko/${store.id}'),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFBBF24),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xFFC2DC80),
                            blurRadius: 4,
                            spreadRadius: 0,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'Lihat Toko',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            height: 1.5,
                          ),
                        ),
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

  // --- PLAN VISIT CALLOUT ---
  Widget _buildPlanVisitCallout(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 14, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFC2DC80).withValues(alpha: 0.6),
          width: 1,
        ),
        gradient: const LinearGradient(
          colors: [Color(0xFFF2F8E7), Color(0xFFFAFDF5)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          // Content Left
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
                        color: const Color(0xFFC2DC80).withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SvgPicture.string(
                        '''<svg width="14" height="14" viewBox="0 0 14 14" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M4.66663 1.16663V2.91663" stroke-width="1.16667" stroke-linecap="round" stroke-linejoin="round" stroke="#4B6515"/>
<path d="M9.33337 1.16663V2.91663" stroke-width="1.16667" stroke-linecap="round" stroke-linejoin="round" stroke="#4B6515"/>
<path d="M2.91667 1.75H11.0833C11.7272 1.75 12.25 2.27277 12.25 2.91667V11.0833C12.25 11.7272 11.7272 12.25 11.0833 12.25H2.91667C2.27277 12.25 1.75 11.7272 1.75 11.0833V2.91667C1.75 2.27277 2.27277 1.75 2.91667 1.75V1.75" stroke-width="1.16667" stroke-linecap="round" stroke-linejoin="round" stroke="#4B6515"/>
<path d="M1.75 5.25H12.25" stroke-width="1.16667" stroke-linecap="round" stroke-linejoin="round" stroke="#4B6515"/>
</svg>''',
                        width: 14,
                        height: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Rencanakan Kunjunganmu',
                      style: TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                const Text(
                  'Cek info terbaru, event, dan promo menarik di Pasar Oro-Oro Dowo.',
                  style: TextStyle(
                    color: Color(0xFF4B5563),
                    fontSize: 10,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () => goTo(context, '/info-kunjungan'),
                  borderRadius: BorderRadius.circular(9999),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(9999),
                      border: Border.all(color: const Color(0xFFC2DC80)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x334B6515),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Lihat Info Kunjungan',
                          style: TextStyle(
                            color: Color(0xFF594045),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 4),
                        SvgPicture.string(
                          '''<svg width="12" height="12" viewBox="0 0 12 12" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M2.5 6H9.5" stroke-linecap="round" stroke-linejoin="round" stroke="#594045"/>
<path d="M6 2.5L9.5 6L6 9.5" stroke-linecap="round" stroke-linejoin="round" stroke="#594045"/>
</svg>''',
                          width: 12,
                          height: 12,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Market Stall 3D Graphic (Figma SVG)
          SizedBox(
            width: 64,
            height: 64,
            child: SvgPicture.string(
              '''<svg width="64" height="64" viewBox="0 0 64 64" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M9.59998 25.6H54.4L51.2 16H12.8L9.59998 25.6" fill="#FBBF24"/>
<path d="M16 16L14.08 25.6L16 16M25.6 16L24.32 25.6L25.6 16M35.2 16L34.56 25.6L35.2 16M44.8 16L45.44 25.6L44.8 16" fill="black" stroke-width="2.56" stroke="white"/>
<path d="M9.59998 26.8801C9.59998 28.6462 11.0338 30.0801 12.8 30.0801C14.5661 30.0801 16 28.6462 16 26.8801C16 25.1139 14.5661 23.6801 12.8 23.6801C11.0338 23.6801 9.59998 25.1139 9.59998 26.8801V26.8801" fill="#FBBF24"/>
<path d="M19.2 26.8801C19.2 28.6462 20.6339 30.0801 22.4 30.0801C24.1661 30.0801 25.6 28.6462 25.6 26.8801C25.6 25.1139 24.1661 23.6801 22.4 23.6801C20.6339 23.6801 19.2 25.1139 19.2 26.8801V26.8801" fill="white"/>
<path d="M28.8 26.8801C28.8 28.6462 30.2339 30.0801 32 30.0801C33.7661 30.0801 35.2 28.6462 35.2 26.8801C35.2 25.1139 33.7661 23.6801 32 23.6801C30.2339 23.6801 28.8 25.1139 28.8 26.8801V26.8801" fill="#FBBF24"/>
<path d="M38.4 26.8801C38.4 28.6462 39.8339 30.0801 41.6 30.0801C43.3662 30.0801 44.8 28.6462 44.8 26.8801C44.8 25.1139 43.3662 23.6801 41.6 23.6801C39.8339 23.6801 38.4 25.1139 38.4 26.8801V26.8801" fill="white"/>
<path d="M48 26.8801C48 28.6462 49.4339 30.0801 51.2 30.0801C52.9661 30.0801 54.4 28.6462 54.4 26.8801C54.4 25.1139 52.9661 23.6801 51.2 23.6801C49.4339 23.6801 48 25.1139 48 26.8801V26.8801" fill="#FBBF24"/>
<path d="M16.64 28.16H47.36C48.7729 28.16 49.92 29.3071 49.92 30.72V47.36C49.92 48.7729 48.7729 49.92 47.36 49.92H16.64C15.2271 49.92 14.08 48.7729 14.08 47.36V30.72C14.08 29.3071 15.2271 28.16 16.64 28.16V28.16" fill="#FBBF24" fill-opacity="0.3"/>
<path d="M21.12 33.28H42.88C43.9404 33.28 44.8 34.1396 44.8 35.2V44.16C44.8 45.2204 43.9404 46.08 42.88 46.08H21.12C20.0596 46.08 19.2 45.2204 19.2 44.16V35.2C19.2 34.1396 20.0596 33.28 21.12 33.28V33.28" fill="white"/>
<path d="M32 6.40002C28.16 6.40002 24.96 9.60002 24.96 13.44C24.96 18.56 32 24.32 32 24.32C32 24.32 39.04 18.56 39.04 13.44C39.04 9.60002 35.84 6.40002 32 6.40002V6.40002" fill="#C2DC80"/>
<path d="M29.44 12.8C29.44 14.2129 30.5871 15.36 32 15.36C33.4129 15.36 34.56 14.2129 34.56 12.8C34.56 11.3871 33.4129 10.24 32 10.24C30.5871 10.24 29.44 11.3871 29.44 12.8V12.8" fill="white"/>
</svg>''',
            ),
          ),
        ],
      ),
    );
  }

  // --- FLOATING BOTTOM NAVIGATION BAR ---
  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      height: 68,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: const Color(0xFFC2DC80), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x20D56989),
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
        children: [
          // 1. Home (Active)
          _buildNavItem(
            label: 'Home',
            isActive: true,
            iconSvg: '''<svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M10 14V8.66667C10 8.29872 9.70128 8 9.33333 8H6.66667C6.29872 8 6 8.29872 6 8.66667V14" stroke-width="1.33333" stroke-linecap="round" stroke-linejoin="round" stroke="#4B6515"/>
<path d="M2 6.66666C1.99991 6.27408 2.17283 5.90141 2.47267 5.64799L7.13933 1.64799C7.63626 1.22801 8.36374 1.22801 8.86067 1.64799L13.5273 5.64799C13.8272 5.90141 14.0001 6.27408 14 6.66666V12.6667C14 13.4025 13.4026 14 12.6667 14H3.33333C2.59745 14 2 13.4025 2 12.6667V6.66666" stroke-width="1.33333" stroke-linecap="round" stroke-linejoin="round" stroke="#4B6515"/>
</svg>''',
            onTap: () {},
          ),

          // 2. Toko
          _buildNavItem(
            label: 'Toko',
            isActive: false,
            iconSvg: '''<svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M12.5 17.5V13.3333C12.5 12.8731 12.1269 12.5 11.6667 12.5H8.33333C7.8731 12.5 7.5 12.8731 7.5 13.3333V17.5" stroke-width="1.66667" stroke-linecap="round" stroke-linejoin="round" stroke="#6B7280"/>
<path d="M14.8116 8.59163C14.4507 8.24612 13.8817 8.24612 13.5208 8.59163C12.7159 9.35935 11.4498 9.35935 10.6449 8.59163C10.2841 8.24665 9.71575 8.24665 9.35494 8.59163C8.54994 9.35988 7.28329 9.35988 6.47828 8.59163C6.11736 8.24612 5.54836 8.24612 5.18744 8.59163C4.41195 9.33165 3.20147 9.36243 2.38937 8.66277C1.57726 7.96311 1.42862 6.7614 2.04578 5.88496L4.45328 2.39829C4.76345 1.94061 5.28039 1.66652 5.83328 1.66663H14.1666C14.7178 1.66641 15.2335 1.93876 15.5441 2.39413L17.9566 5.88746C18.5739 6.76463 18.4243 7.96718 17.6109 8.66637C16.7975 9.36556 15.5861 9.33286 14.8116 8.59079" stroke-width="1.66667" stroke-linecap="round" stroke-linejoin="round" stroke="#6B7280"/>
<path d="M3.33337 9.125V15.8333C3.33337 16.7538 4.07957 17.5 5.00004 17.5H15C15.9205 17.5 16.6667 16.7538 16.6667 15.8333V9.125" stroke-width="1.66667" stroke-linecap="round" stroke-linejoin="round" stroke="#6B7280"/>
</svg>''',
            onTap: () => goTo(context, '/toko'),
          ),

          // 3. Promo
          _buildNavItem(
            label: 'Promo',
            isActive: false,
            iconSvg: '''<svg width="22" height="22" viewBox="0 0 23 23" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M16.9211 17.8795C13.9271 20.8735 9.07285 20.8735 6.07883 17.8795C4.58182 16.3825 3.83332 14.4204 3.83331 12.4583C3.83331 10.4963 4.58181 8.53418 6.07883 7.03717C6.07883 7.03717 6.70836 8.62496 8.62502 9.58329C8.62502 7.66662 9.10419 4.79162 11.4865 2.875C13.4166 4.79167 15.4207 5.53672 16.9211 7.03717C18.4181 8.53418 19.1666 10.4963 19.1666 12.4583C19.1666 14.4204 18.4181 16.3825 16.9211 17.8795ZM13.5329 15.4496C12.4102 16.5723 10.5898 16.5723 9.46705 15.4496C8.90568 14.8882 8.62499 14.1524 8.62498 13.4167L10.5416 13.4166L11.5139 10.5417C12.2451 10.5452 12.9751 10.8259 13.5329 11.3837C14.0943 11.9451 14.375 12.6809 14.375 13.4167C14.375 14.1524 14.0943 14.8882 13.5329 15.4496Z" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" stroke="#6B7280"/>
</svg>''',
            onTap: () => goTo(context, '/promo'),
          ),

          // 4. Review Pasar
          _buildNavItem(
            label: 'Review Pasar',
            isActive: false,
            iconSvg: '''<svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M5.96672 12H8.76255L13.3459 7.41667C13.4834 7.27917 13.5865 7.12257 13.6553 6.94688C13.724 6.77118 13.7584 6.59931 13.7584 6.43125C13.7584 6.26319 13.7202 6.09896 13.6438 5.93854C13.5674 5.77813 13.4681 5.62917 13.3459 5.49167L12.5209 4.62083C12.3834 4.48333 12.2306 4.38021 12.0625 4.31146C11.8945 4.24271 11.7188 4.20833 11.5355 4.20833C11.3674 4.20833 11.1955 4.24271 11.0198 4.31146C10.8441 4.38021 10.6875 4.48333 10.55 4.62083L5.96672 9.20417V12V12M12.3834 6.43125V6.43125L11.5355 5.58333V5.58333L12.3834 6.43125V6.43125M7.34172 10.625V9.75417L9.6563 7.43958L10.1146 7.85208L10.5271 8.31042L8.21255 10.625H7.34172V10.625M10.1146 7.85208L10.5271 8.31042V8.31042L9.6563 7.43958V7.43958L10.1146 7.85208V7.85208M10.7105 12H16.9667V10.1667H12.5438L10.7105 12V12M2.30005 19.3333V2.83333C2.30005 2.32917 2.47956 1.89757 2.83859 1.53854C3.19762 1.17951 3.62922 1 4.13338 1H18.8C19.3042 1 19.7358 1.17951 20.0948 1.53854C20.4539 1.89757 20.6334 2.32917 20.6334 2.83333V13.8333C20.6334 14.3375 20.4539 14.7691 20.0948 15.1281C19.7358 15.4872 19.3042 15.6667 18.8 15.6667H5.96672L2.30005 19.3333V19.3333M5.18755 13.8333H18.8V13.8333V13.8333V2.83333V2.83333V2.83333H4.13338V2.83333V2.83333V14.8646L5.18755 13.8333V13.8333M4.13338 13.8333V13.8333V2.83333V2.83333V2.83333V2.83333V2.83333V2.83333V13.8333V13.8333V13.8333V13.8333V13.8333" fill="#6B7280"/>
</svg>''',
            onTap: () => goTo(context, '/review-pasar'),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required String label,
    required bool isActive,
    required String iconSvg,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
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
              color: isActive
                  ? const Color(0xFFC2DC80).withValues(alpha: 0.5)
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.string(iconSvg),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: isActive
                  ? const Color(0xFF4B6515)
                  : const Color(0xFF9CA3AF),
              fontSize: label == 'Review Pasar' ? 9 : 10,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
