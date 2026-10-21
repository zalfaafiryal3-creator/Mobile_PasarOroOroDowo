import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/market_data.dart';
import '../../widgets/market_ui.dart';

class StoreListScreen extends StatefulWidget {
  const StoreListScreen({this.initialCategory, super.key});

  final String? initialCategory;

  @override
  State<StoreListScreen> createState() => _StoreListScreenState();
}

class _StoreListScreenState extends State<StoreListScreen> {
  final TextEditingController _searchController = TextEditingController();
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

  bool _matchesCategory(StoreData store, String category) {
    final cat = category.toLowerCase().trim();
    final sCat = store.category.toLowerCase();
    final sBadge = store.badge.toLowerCase();
    final sDisplay = store.displayCategory.toLowerCase();
    final combined = '$sCat $sBadge $sDisplay';

    if (cat.contains('makanan') && !cat.contains('minuman')) {
      return combined.contains('makanan') || combined.contains('kuliner');
    } else if (cat.contains('sayur') || cat.contains('buah')) {
      return combined.contains('sayur') || combined.contains('buah') || combined.contains('organic');
    } else if (cat.contains('kuliner') || cat.contains('legend')) {
      return combined.contains('kuliner') || combined.contains('legend') || sCat.contains('kuliner');
    } else if (cat.contains('daging') || cat.contains('ikan')) {
      return combined.contains('daging') || combined.contains('ikan') || store.id == 'norriture';
    } else if (cat.contains('sembako') || cat.contains('perabotan')) {
      return combined.contains('sembako') || combined.contains('perabotan') || combined.contains('peralatan');
    } else if (cat.contains('mainan') || cat.contains('baju')) {
      return combined.contains('mainan') || combined.contains('baju') || combined.contains('pakaian');
    }
    return combined.contains(cat);
  }

  @override
  Widget build(BuildContext context) {
    final search = _searchController.text.trim().toLowerCase();
    final stores = marketStores.where((store) {
      final matchesCat = _activeCategory == null ||
          _matchesCategory(store, _activeCategory!);
      final matchesSearch = search.isEmpty ||
          '${store.name} ${store.displayCategory} ${store.badge} ${store.category}'
              .toLowerCase()
              .contains(search);
      return matchesCat && matchesSearch;
    }).toList();

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
                  // Top Header (Brand + Search)
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

                  // Main Content
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // Section Title Bar: Kategori Belanja
                        _buildCategorySectionHeader(),
                        const SizedBox(height: 12),

                        // Feature Grid (6 Kategori)
                        _buildCategoryGridCard(),
                        const SizedBox(height: 20),

                        // Daftar Toko Section Header
                        _buildStoreListHeader(stores.length),
                        const SizedBox(height: 14),

                        // Store Cards Grid (2 Kolom)
                        _buildStoreGrid(stores),
                      ]),
                    ),
                  ),
                ],
              ),
            ),

            // Floating Bottom Navigation Bar (Tab Toko Active)
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
        // Brand Logo Icon Shape (Figma gradient #C2DC80 to #FBBF24 with flower)
        Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFC2DC80), Color(0xFFFBBF24)],
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
<path d="M9.99996 1.66667C8.15901 1.66667 6.66663 3.15905 6.66663 5C6.66754 5.56269 6.81088 6.11598 7.08329 6.60833C6.40046 6.4046 5.67032 6.42504 4.99996 6.66667C3.15901 6.66667 1.66663 8.15905 1.66663 10C1.66663 11.8409 3.15901 13.3333 4.99996 13.3333C5.75656 13.3351 6.49125 13.0794 7.08329 12.6083C7.4676 13.9319 8.6268 14.8824 9.99996 15C11.3731 14.8824 12.5323 13.9319 12.9166 12.6083C13.5087 13.0794 14.2434 13.3351 15 13.3333C16.8409 13.3333 18.3333 11.8409 18.3333 10C18.3272 8.64721 17.504 7.43229 16.25 6.925C16.0743 6.15559 15.6314 5.47346 15 5C15 3.15905 13.5076 1.66667 11.6666 1.66667L9.99996 1.66667" fill="white"/>
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

  // --- SECTION TITLE: KATEGORI BELANJA ---
  Widget _buildCategorySectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Text(
              'Kategori Belanja',
              style: TextStyle(
                color: Color(0xFF111827),
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.4,
              ),
            ),
            if (_activeCategory != null) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => setState(() => _activeCategory = null),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF3D4),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: const Color(0xFFC2DC80)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _activeCategory!,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF4B6515),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.close, size: 12, color: Color(0xFF4B6515)),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
        SvgPicture.string(
          '''<svg width="14" height="14" viewBox="0 0 14 14" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M5.25 10.5L8.75 7L5.25 3.5" stroke-width="1.16667" stroke-linecap="round" stroke-linejoin="round" stroke="#4B6515"/>
</svg>''',
          width: 14,
          height: 14,
        ),
      ],
    );
  }

  // --- 6 CATEGORY GRID CARD (White card from Figma) ---
  Widget _buildCategoryGridCard() {
    final categories = [
      (
        'Makanan',
        'Makanan',
        const Color(0x59FBBF24),
        '''<svg width="17" height="17" viewBox="0 0 17 17" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M12.2543 1.41667L9.95425 3.71667C8.81082 4.8832 8.81082 6.75014 9.95425 7.91667L11.7543 9.71667C12.9208 10.8601 14.7877 10.8601 15.9543 9.71667L18.2543 7.41667" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" stroke="#FBBF24"/>
<path d="M11.0824 10.5112L2.47655 2.42761C1.88351 2.97341 1.54932 3.72046 1.54932 4.50034C1.54932 5.28022 1.88351 6.02727 2.47655 6.57307L7.84598 11.6167C8.36086 12.1003 9.31706 12.1003 9.90549 11.6167L11.0824 10.5112ZM11.0824 10.5112L16.2311 15.3476" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" stroke="#FBBF24"/>
<path d="M1.48755 17.2792L7.88755 10.9792" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" stroke="#FBBF24"/>
<path d="M15.5 3.54167L8.5 10.5417" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" stroke="#FBBF24"/>
</svg>''',
      ),
      (
        'Sayur\n& Buah',
        'Sayur & Buah',
        const Color(0x40C2DC80),
        '''<svg width="19" height="17" viewBox="0 0 19 17" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M3.95837 14.875C4.35421 11.6875 5.93754 9.20834 9.50004 7.79167" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" stroke="#4B6515"/>
<path d="M7.12506 12.75C12.0476 12.75 15.4376 10.421 15.8334 4.24999V2.83333H12.6556C5.53064 2.83333 3.16672 5.66666 3.15564 9.20833C3.15564 9.91666 3.15564 11.3333 4.73897 12.75H7.11397H7.12506Z" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" stroke="#4B6515"/>
</svg>''',
      ),
      (
        'Kuliner\nLegend',
        'Kuliner Legendaris',
        const Color(0x59FBBF24),
        '''<svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M2 1.33333V6C2 6.73333 2.6 7.33333 3.33333 7.33333H6C6.73589 7.33333 7.33333 6.73588 7.33333 6V1.33333" stroke-width="1.33333" stroke-linecap="round" stroke-linejoin="round" stroke="#FBBF24"/>
<path d="M4.66663 1.33333V14.6667" stroke-width="1.33333" stroke-linecap="round" stroke-linejoin="round" stroke="#FBBF24"/>
<path d="M14 10V1.33333C12.159 1.33333 10.6666 2.82571 10.6666 4.66666V8.66666C10.6666 9.4 11.2666 10 12 10H14V10M14 10V14.6667" stroke-width="1.33333" stroke-linecap="round" stroke-linejoin="round" stroke="#FBBF24"/>
</svg>''',
      ),
      (
        'Daging\n& Ikan',
        'Daging & Ikan',
        const Color(0x40C2DC80),
        '''<svg width="22" height="17" viewBox="0 0 22 17" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M15.2992 5.27C14.2979 6.16813 13.7481 7.31457 13.75 8.5C13.75 9.73746 14.3367 10.8694 15.3074 11.7378" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" stroke="#4B6515"/>
<path d="M1.83337 6.732C8.90546 12.857 15.3542 14.003 20.1667 8.50142C15.3542 3.00404 8.90546 4.15083 1.83337 10.2751" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" stroke="#4B6515"/>
<path d="M16.5 7.79167V7.79876" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" stroke="#4B6515"/>
<path d="M10.5417 7.4375C9.93028 8.14583 9.93028 8.85417 10.5417 9.5625" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" stroke="#4B6515"/>
</svg>''',
      ),
      (
        'Sembako\n& Perabot',
        'Sembako & Perabotan',
        const Color(0x59FBBF24),
        '''<svg width="24" height="20" viewBox="0 0 24 20" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M15 9.16667L14 18.1667" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" stroke="#FBBF24"/>
<path d="M19 10.3333L15 3.33333" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" stroke="#FBBF24"/>
<path d="M2 9.16667H22" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" stroke="#FBBF24"/>
<path d="M3.5 9.16667L5.1 16.5667C5.29295 17.5129 6.13448 18.1861 7.1 18.1667H16.9C17.8655 18.1861 18.7071 17.5129 18.9 16.5667L20.6 9.16667" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" stroke="#FBBF24"/>
<path d="M4.5 12.9167H19.5" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" stroke="#FBBF24"/>
<path d="M5 10.3333L9 3.33333" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" stroke="#FBBF24"/>
<path d="M9 9.16667L10 18.1667" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" stroke="#FBBF24"/>
</svg>''',
      ),
      (
        'Mainan\n& Baju',
        'Mainan & Baju',
        const Color(0x40C2DC80),
        '''<svg width="19" height="16" viewBox="0 0 19 16" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M14.9767 1.10768C15.7732 0.98865 16.5355 0.96246 17.1544 1.0896C17.2935 1.11772 17.4203 1.17846 17.5201 1.2648C17.6187 1.35013 17.687 1.45699 17.7171 1.57324C17.8625 2.10986 17.8323 2.75727 17.6905 3.43307C17.547 4.11745 17.2817 4.86473 16.9226 5.61486C16.2072 7.10964 15.0967 8.66246 13.7585 9.7835C13.3652 10.1167 12.9437 10.4253 12.4974 10.7069C12.5266 11.3204 12.4435 11.9553 12.1466 12.5291L12.1463 12.5297C11.6652 13.4564 10.7984 14.0382 9.9635 14.3996C9.13107 14.7598 8.29439 14.9173 7.79788 14.9845C7.65747 15.0036 7.51372 14.9953 7.37774 14.9602C7.24176 14.925 7.1172 14.864 7.01367 14.7819C6.91015 14.6998 6.83045 14.5987 6.78072 14.4864C6.73098 14.3742 6.71256 14.2539 6.72687 14.1347C6.72704 14.1333 6.72721 14.1319 6.7274 14.1305L6.98895 12.1236C6.96246 12.1214 6.93599 12.119 6.90953 12.1166C6.61809 12.0912 6.34606 11.9817 6.13973 11.8065C6.13926 11.8061 6.13879 11.8057 6.13831 11.8053L4.97833 10.8284C4.97785 10.828 4.97737 10.8276 4.9769 10.8272C4.76892 10.6536 4.63879 10.4246 4.60863 10.1793C4.60554 10.1559 4.60262 10.1325 4.59985 10.109L2.21455 10.3295L2.21209 10.3297L2.21025 10.3299C2.06856 10.3421 1.92542 10.3267 1.79194 10.2848C1.65845 10.243 1.53821 10.1758 1.44053 10.0885C1.34285 10.0012 1.27034 9.89614 1.22864 9.78145C1.18694 9.66675 1.17716 9.54551 1.20005 9.42712L1.20023 9.42624C1.28176 9.00944 1.46967 8.30593 1.89812 7.60534C2.32769 6.90293 3.01841 6.17351 4.11803 5.76636L4.11961 5.76578C4.80133 5.51534 5.55927 5.44546 6.29236 5.47241C6.62674 5.09795 6.99294 4.74426 7.38814 4.41413C8.72321 3.29092 10.5951 2.35624 12.3818 1.75415C13.2786 1.45196 14.1689 1.22841 14.9767 1.10768Z" fill="#4B6515"/>
</svg>''',
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFFCE7F3).withValues(alpha: 0.6),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x35594045),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: categories.map((cat) {
          final label = cat.$1;
          final value = cat.$2;
          final bg = cat.$3;
          final svgIcon = cat.$4;
          final isSelected = _activeCategory != null &&
              (_activeCategory!.toLowerCase() == value.toLowerCase() ||
                  value.toLowerCase().contains(_activeCategory!.toLowerCase()));

          return GestureDetector(
            onTap: () {
              setState(() {
                if (_activeCategory == value) {
                  _activeCategory = null;
                } else {
                  _activeCategory = value;
                }
              });
            },
            child: SizedBox(
              width: 52,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFC2DC80)
                          : bg,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: isSelected
                          ? const [
                              BoxShadow(
                                color: Color(0x404B6515),
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ]
                          : const [
                              BoxShadow(
                                color: Color(0x33C2DC80),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                    ),
                    child: SvgPicture.string(svgIcon),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(
                      color: isSelected
                          ? const Color(0xFF4B6515)
                          : const Color(0xFF374151),
                      fontFamily: 'Inter',
                      fontSize: 9,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
                      height: 1.2,
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

  // --- SECTION TITLE: DAFTAR TOKO ---
  Widget _buildStoreListHeader(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Daftar Toko',
          style: TextStyle(
            color: Color(0xFF111827),
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.4,
          ),
        ),
        Text(
          '$count Toko',
          style: const TextStyle(
            color: Color(0xFF6B7280),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // --- STORE GRID (2 KOLOM) ---
  Widget _buildStoreGrid(List<StoreData> stores) {
    if (stores.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Column(
            children: [
              const Icon(Icons.storefront_outlined, size: 48, color: Color(0xFF9CA3AF)),
              const SizedBox(height: 8),
              const Text(
                'Tidak ada toko yang cocok dengan pencarian.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() => _activeCategory = null);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFBBF24),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                ),
                child: const Text('Reset Filter', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      itemCount: stores.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 14,
        mainAxisExtent: 260,
      ),
      itemBuilder: (context, index) {
        return _buildStoreCard(context, stores[index]);
      },
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

  // --- FLOATING BOTTOM NAVIGATION BAR (Tab Toko Active) ---
  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      height: 68,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(
          color: const Color(0x4DEA9CAF), // rgba(234, 156, 175, 0.30)
          width: 1,
        ),
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
          // 1. Home
          _buildNavItem(
            label: 'Home',
            isActive: false,
            iconSvg: '''<svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M10 14V8.66667C10 8.29872 9.70128 8 9.33333 8H6.66667C6.29872 8 6 8.29872 6 8.66667V14" stroke-width="1.33333" stroke-linecap="round" stroke-linejoin="round" stroke="#6B7280"/>
<path d="M2 6.66666C1.99991 6.27408 2.17283 5.90141 2.47267 5.64799L7.13933 1.64799C7.63626 1.22801 8.36374 1.22801 8.86067 1.64799L13.5273 5.64799C13.8272 5.90141 14.0001 6.27408 14 6.66666V12.6667C14 13.4025 13.4026 14 12.6667 14H3.33333C2.59745 14 2 13.4025 2 12.6667V6.66666" stroke-width="1.33333" stroke-linecap="round" stroke-linejoin="round" stroke="#6B7280"/>
</svg>''',
            onTap: () => goTo(context, '/home'),
          ),

          // 2. Toko (Active)
          _buildNavItem(
            label: 'Toko',
            isActive: true,
            iconSvg: '''<svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M12.5 17.5V13.3333C12.5 12.8731 12.1269 12.5 11.6667 12.5H8.33333C7.8731 12.5 7.5 12.8731 7.5 13.3333V17.5" stroke-width="1.66667" stroke-linecap="round" stroke-linejoin="round" stroke="#4B6515"/>
<path d="M14.8116 8.59163C14.4507 8.24612 13.8817 8.24612 13.5208 8.59163C12.7159 9.35935 11.4498 9.35935 10.6449 8.59163C10.2841 8.24665 9.71575 8.24665 9.35494 8.59163C8.54994 9.35988 7.28329 9.35988 6.47828 8.59163C6.11736 8.24612 5.54836 8.24612 5.18744 8.59163C4.41195 9.33165 3.20147 9.36243 2.38937 8.66277C1.57726 7.96311 1.42862 6.7614 2.04578 5.88496L4.45328 2.39829C4.76345 1.94061 5.28039 1.66652 5.83328 1.66663H14.1666C14.7178 1.66641 15.2335 1.93876 15.5441 2.39413L17.9566 5.88746C18.5739 6.76463 18.4243 7.96718 17.6109 8.66637C16.7975 9.36556 15.5861 9.33369 14.8116 8.59163Z" stroke-width="1.66667" stroke-linecap="round" stroke-linejoin="round" stroke="#4B6515"/>
<path d="M3.33337 9.125V15.8333C3.33337 16.7538 4.07957 17.5 5.00004 17.5H15C15.9205 17.5 16.6667 16.7538 16.6667 15.8333V9.125" stroke-width="1.66667" stroke-linecap="round" stroke-linejoin="round" stroke="#4B6515"/>
</svg>''',
            onTap: () {},
          ),

          // 3. Promo
          _buildNavItem(
            label: 'Promo',
            isActive: false,
            iconSvg: '''<svg width="22" height="22" viewBox="0 0 23 23" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M16.9212 17.8795C13.9272 20.8735 9.07291 20.8735 6.07889 17.8795C4.58188 16.3825 3.83338 14.4204 3.83337 12.4583C3.83337 10.4963 4.58188 8.53418 6.07889 7.03717C6.07889 7.03717 6.70842 8.62496 8.62508 9.58329C8.62508 7.66662 9.10425 4.79162 11.4865 2.875C13.4167 4.79167 15.4207 5.53672 16.9212 7.03717C18.4182 8.53418 19.1667 10.4963 19.1667 12.4583C19.1667 14.4204 18.4182 16.3825 16.9212 17.8795ZM13.533 15.4496C12.4102 16.5723 10.5899 16.5723 9.46711 15.4496C8.90574 14.8882 8.62505 14.1524 8.62504 13.4167L10.5417 13.4166L11.514 10.5417C12.2451 10.5452 12.9751 10.8259 13.533 11.3837C14.0944 11.9451 14.375 12.6809 14.375 13.4167C14.375 14.1524 14.0943 14.8882 13.533 15.4496Z" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" stroke="#6B7280"/>
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
                  ? const Color(0xFFC2DC80).withValues(alpha: 0.35)
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
