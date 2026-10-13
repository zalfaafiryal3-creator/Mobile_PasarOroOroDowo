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
  bool _favorite = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    final homeStores = <StoreData>[
      marketStores.firstWhere((store) => store.id == 'lumpur-kentang-27'),
      marketStores.firstWhere((store) => store.id == 'bakso-goreng-bangkit'),
      marketStores.firstWhere((store) => store.id == 'klepon-ku'),
      marketStores.firstWhere((store) => store.id == 'wiwit-sayur'),
    ];
    final matchingStores = homeStores
        .where(
          (store) =>
              query.isEmpty ||
              '${store.name} ${store.category} ${store.displayCategory}'
                  .toLowerCase()
                  .contains(query),
        )
        .take(4)
        .toList();

    return MarketPage(
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(24, 20, 20, 8),
                color: MarketColors.background,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [MarketColors.yellow, MarketColors.green],
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                            ),
                            borderRadius: BorderRadius.circular(17),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x334B6515),
                                blurRadius: 7,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const MarketAsset(
                            'c03df.svg',
                            width: 20,
                            height: 20,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Pasar Oro-Oro Dowo',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: MarketColors.brown,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 38,
                      child: TextField(
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
                        style: const TextStyle(
                          fontSize: 12,
                          color: MarketColors.ink,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: const Padding(
                            padding: EdgeInsets.all(11),
                            child: MarketAsset(
                              '14528.svg',
                              width: 16,
                              height: 16,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                          prefixIconConstraints: const BoxConstraints(
                            minWidth: 40,
                            minHeight: 36,
                          ),
                          hintText: 'Cari toko, produk, atau pedagang...',
                          hintStyle: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF9CA3AF),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(999),
                            borderSide: const BorderSide(
                              color: Color(0x474B6515),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(999),
                            borderSide: const BorderSide(
                              color: Color(0x474B6515),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(999),
                            borderSide: const BorderSide(
                              color: MarketColors.greenDark,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 100),
                  children: [
                    _homeHero(context),
                    const SizedBox(height: 10),
                    _carouselDots(),
                    const SizedBox(height: 16),
                    _marketInformationCard(),
                    const SizedBox(height: 16),
                    _featureMenu(context),
                    const SizedBox(height: 22),
                    _homeSectionHeading(
                      context,
                      'Kategori Belanja',
                      onTap: () => goTo(context, '/toko'),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _CategoryTile(
                            'Pakaian',
                            '3baa8.svg',
                            pink: true,
                            onTap: () => goTo(
                              context,
                              '/toko?category=Mainan%20%26%20Baju',
                            ),
                          ),
                          _CategoryTile(
                            'Sembako',
                            '86e23.svg',
                            onTap: () => goTo(
                              context,
                              '/toko?category=Sembako%20%26%20Perabotan',
                            ),
                          ),
                          _CategoryTile(
                            'Makanan',
                            '43d40.svg',
                            pink: true,
                            onTap: () =>
                                goTo(context, '/toko?category=Makanan'),
                          ),
                          _CategoryTile(
                            'Perabotan',
                            '86cbb.svg',
                            onTap: () => goTo(
                              context,
                              '/toko?category=Sembako%20%26%20Perabotan',
                            ),
                          ),
                          _CategoryTile(
                            'Lainnya',
                            '265dd.svg',
                            plain: true,
                            onTap: () => goTo(context, '/toko'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _homeSectionHeading(
                      context,
                      'Daftar Toko',
                      onTap: () => goTo(context, '/toko'),
                      trailingColor: MarketColors.pink,
                    ),
                    const SizedBox(height: 10),
                    if (matchingStores.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Tidak ada toko yang cocok.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: MarketColors.muted),
                        ),
                      )
                    else
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: matchingStores.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 9,
                              mainAxisSpacing: 9,
                              mainAxisExtent: 254,
                            ),
                        itemBuilder: (context, index) => InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () => goTo(
                            context,
                            '/detail-toko/${matchingStores[index].id}',
                          ),
                          child: _HomeStoreCard(store: matchingStores[index]),
                        ),
                      ),
                    const SizedBox(height: 10),
                    _visitBanner(context),
                  ],
                ),
              ),
            ],
          ),
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

  Widget _carouselDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 16,
          height: 6,
          decoration: BoxDecoration(
            color: MarketColors.brown,
            borderRadius: BorderRadius.circular(99),
          ),
        ),
        const SizedBox(width: 6),
        ...List.generate(
          3,
          (_) => Padding(
            padding: const EdgeInsets.only(right: 6),
            child: Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: MarketColors.brown,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _homeSectionHeading(
    BuildContext context,
    String title, {
    required VoidCallback onTap,
    Color trailingColor = MarketColors.brown,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: MarketColors.brown,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            foregroundColor: trailingColor,
          ),
          child: Row(
            children: [
              const Text(
                'Lihat Semua',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              ),
              const SizedBox(width: 2),
              MarketAsset(
                'd28fc.svg',
                width: 14,
                height: 14,
                color: trailingColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _homeHero(BuildContext context) {
    return Container(
      height: 176,
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 12),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFC2DC80), Color(0xD1C2DC80), MarketColors.yellow],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0, .55, 1],
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x4D594045),
            blurRadius: 8,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Pilih\nToko Favoritmu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    height: 1.2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Temukan berbagai toko menarik\ndi PasarKu',
                  style: TextStyle(
                    color: Color(0xF2FFFFFF),
                    height: 1.35,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 160,
                  height: 28,
                  child: ElevatedButton(
                    onPressed: () => goTo(context, '/toko'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: MarketColors.yellow,
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 28),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      elevation: 2,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      'Jelajahi Sekarang   →',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          const MarketAsset('cb537.svg', width: 84, height: 96),
        ],
      ),
    );
  }

  Widget _marketInformationCard() {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xB3594045)),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x6B594045),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 120,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: const MarketAsset(
                    '204f2.png',
                    width: 134,
                    height: 105,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 11),
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
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () =>
                                setState(() => _favorite = !_favorite),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints.tightFor(
                              width: 25,
                              height: 25,
                            ),
                            icon: Icon(
                              _favorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 18,
                              color: MarketColors.brown,
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        'Pusat Belanja dan Kuliner\nTradisional di Tengah Kota',
                        style: TextStyle(
                          color: MarketColors.yellow,
                          fontSize: 11,
                          height: 1.45,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Expanded(
                        child: Text(
                          'Pasar yang sudah berdiri sejak lama dan menjadi ikon belanja masyarakat dengan beragam produk, harga…',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0xA6594045),
                            fontSize: 10,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Row(
            children: [
              Expanded(
                child: _MarketStat(
                  icon: '9107e.svg',
                  label: 'Jam Buka',
                  value: '06.00 -\n17.00',
                  note: 'Setiap Hari',
                ),
              ),
              Expanded(
                child: _MarketStat(
                  icon: 'c5164.svg',
                  label: 'Jumlah\nPedagang',
                  value: '± 251',
                  note: 'Pedagang',
                ),
              ),
              Expanded(
                child: _MarketStat(
                  icon: '51c04.svg',
                  label: 'Lokasi',
                  value: 'Klojen, Kota Malang',
                  note: 'Jawa Timur',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _featureMenu(BuildContext context) {
    const items = [
      ('Denah\nPasar', 'a9678.svg', '/denah'),
      ('AI perencana', 'e365f.svg', '/chatbot-rekomendasi'),
      ('Fasilitas', 'f0bb1.svg', '/fasilitas-pasar'),
      ('Rekomendasi', '0c309.svg', '/rekomendasi'),
      ('Info\nKunjungan', '23853.svg', '/info-kunjungan'),
    ];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xB3594045)),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x4D594045),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items.map((item) {
          final green = item.$1 == 'AI perencana' || item.$1 == 'Rekomendasi';
          return SizedBox(
            width: 48,
            child: InkWell(
              onTap: () => goTo(context, item.$3),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: green
                          ? const Color(0x47C2DC80)
                          : const Color(0x7AFBBF24),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: MarketAsset(
                      item.$2,
                      width: 20,
                      height: 22,
                      color: green
                          ? MarketColors.greenDark
                          : const Color(0xFFF59E0B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.$1,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF374151),
                      fontSize: 9,
                      height: 1.2,
                      fontWeight: FontWeight.w700,
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

  Widget _visitBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 12, 13),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xE6C2DC80)),
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xF2FFFFFF), Color(0x3DC2DC80)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
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
                      width: 36,
                      height: 36,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0x47C2DC80),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: const MarketAsset(
                        'a7199.svg',
                        width: 18,
                        height: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Rencanakan Kunjunganmu',
                        style: TextStyle(
                          color: MarketColors.ink,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                const Text(
                  'Cek info terbaru, event, dan promo menarik di\nPasar Oro-Oro Dowo.',
                  style: TextStyle(
                    color: Color(0xCC594045),
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 9),
                SizedBox(
                  height: 29,
                  child: ElevatedButton(
                    onPressed: () => goTo(context, '/info-kunjungan'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: MarketColors.brown,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      elevation: 2,
                      shape: const StadiumBorder(),
                      side: const BorderSide(color: MarketColors.green),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Lihat Info Kunjungan',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 5),
                        MarketAsset(
                          '0d8ef.svg',
                          width: 14,
                          height: 14,
                          color: MarketColors.brown,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const MarketAsset('f6baa.svg', width: 68, height: 68),
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
      height: 71,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .97),
        border: Border.all(color: const Color(0xC7C2DC80)),
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(
            color: Color(0x244B6515),
            blurRadius: 22,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items.map((item) {
          final active = item.$1 == 'Home';
          return InkWell(
            onTap: () => goTo(context, item.$2),
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              width: 56,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: active
                          ? const Color(0x5CC2DC80)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: MarketAsset(
                      item.$3,
                      width: 20,
                      height: 20,
                      color: active
                          ? MarketColors.greenDark
                          : const Color(0xFF7B8190),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.$1,
                    maxLines: 1,
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                      color: active
                          ? MarketColors.greenDark
                          : const Color(0xFF9CA3AF),
                      fontSize: item.$1 == 'Review Pasar' ? 9 : 10,
                      fontWeight: active ? FontWeight.w700 : FontWeight.w400,
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
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xB3594045)),
        borderRadius: BorderRadius.circular(17),
        boxShadow: const [
          BoxShadow(
            color: Color(0x38594045),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 116,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  MarketAsset(store.image, fit: BoxFit.cover),
                  Positioned(
                    left: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: MarketColors.greenDark,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        store.badge,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          height: 13 / 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  Text(
                    store.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: MarketColors.ink,
                      fontSize: 12,
                      height: 1.3,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    store.displayCategory,
                    maxLines: 1,
                    style: const TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 9.5,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.star,
                        size: 13,
                        color: MarketColors.yellow,
                      ),
                      Text(
                        store.rating,
                        style: const TextStyle(
                          color: MarketColors.yellow,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 10,
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        color: const Color(0xFFD1D5DB),
                      ),
                      Text(
                        store.products,
                        style: const TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 9.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 29,
            child: ElevatedButton(
              onPressed: () => goTo(context, '/detail-toko/${store.id}'),
              style: ElevatedButton.styleFrom(
                backgroundColor: MarketColors.yellow,
                foregroundColor: Colors.white,
                elevation: 2,
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                shadowColor: const Color(0x4D594045),
              ),
              child: const Text(
                'Lihat Toko',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MarketStat extends StatelessWidget {
  const _MarketStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.note,
  });

  final String icon;
  final String label;
  final String value;
  final String note;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 23,
            height: 23,
            margin: const EdgeInsets.only(top: 1),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0x4DC2DC80),
              shape: BoxShape.circle,
            ),
            child: MarketAsset(icon, width: 13, height: 13),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 8),
                ),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 9,
                    height: 1.2,
                    color: MarketColors.ink,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  note,
                  style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 8),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile(
    this.label,
    this.icon, {
    required this.onTap,
    this.pink = false,
    this.plain = false,
  });

  final String label;
  final String icon;
  final VoidCallback onTap;
  final bool pink;
  final bool plain;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 65,
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xB3594045)),
        ),
        child: Column(
          children: [
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: plain
                    ? const Color(0x7AFBBF24)
                    : pink
                    ? const Color(0x7AFBBF24)
                    : const Color(0x5CC2DC80),
                borderRadius: BorderRadius.circular(12),
              ),
              child: MarketAsset(
                icon,
                width: 20,
                height: 20,
                color: plain || pink
                    ? const Color(0xFFF59E0B)
                    : MarketColors.greenDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              style: const TextStyle(
                color: Color(0xFF374151),
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
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
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            color: const Color(0xFFF3EEF1),
            child: Column(
              children: [
                const BrandHeader(),
                const SizedBox(height: 12),
                SearchField(
                  controller: _searchController,
                  hint: 'Cari toko, produk, atau pedagang...',
                  onChanged: (_) => setState(() {}),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 15, 16, 18),
              children: [
                const SectionHeading('Kategori Belanja'),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(21),
                    border: Border.all(color: const Color(0x33EA9CAF)),
                  ),
                  child: GridView.builder(
                    itemCount: storeCategories.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisExtent: 72,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                    itemBuilder: (context, index) {
                      final category = storeCategories[index];
                      final selected = category == _activeCategory;
                      const icons = [
                        Icons.restaurant,
                        Icons.eco,
                        Icons.local_cafe,
                        Icons.set_meal,
                        Icons.shopping_basket,
                        Icons.toys,
                      ];
                      return Material(
                        color: selected
                            ? const Color(0xFFFFE3EB)
                            : const Color(0xFFF8F5F3),
                        borderRadius: BorderRadius.circular(16),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => setState(() {
                            _activeCategory = selected ? null : category;
                          }),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                icons[index],
                                size: 21,
                                color: index.isEven
                                    ? MarketColors.pink
                                    : MarketColors.greenDark,
                              ),
                              const SizedBox(height: 5),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 3,
                                ),
                                child: Text(
                                  category,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: MarketColors.ink,
                                    fontSize: 9,
                                    height: 1.15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 18),
                SectionHeading('Daftar Toko'),
                const SizedBox(height: 9),
                if (stores.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(22),
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
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          mainAxisExtent: 235,
                        ),
                    itemBuilder: (context, index) {
                      final store = stores[index];
                      return InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () => goTo(context, '/detail-toko/${store.id}'),
                        child: StoreCard(store: store),
                      );
                    },
                  ),
              ],
            ),
          ),
          const BottomNavigation(active: 'Toko'),
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
