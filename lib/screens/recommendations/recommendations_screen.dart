import 'package:flutter/material.dart';

import '../../widgets/market_ui.dart';

class RecommendationsScreen extends StatefulWidget {
  const RecommendationsScreen({super.key});

  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  bool _sortByRating = false;
  final Set<String> _savedProducts = {};

  static const _stores = <_RecommendedStore>[
    _RecommendedStore(
      'Lumpur Kentang 27',
      'Kuliner Legend',
      'Blok B No. 12',
      '4.8',
      'lumpur kentang 27.jpeg',
    ),
    _RecommendedStore(
      'Pangsit Mie Arema',
      'Makanan',
      'Teras Timur No. 04',
      '4.9',
      'pangsit mie arema.png',
    ),
    _RecommendedStore(
      'Kios Bu Lilik',
      'Jajanan Pasar',
      'Blok Basah D-09',
      '4.9',
      'jajanan pasar.jpg',
    ),
  ];

  static const _highlights = <_RecommendationProduct>[
    _RecommendationProduct(
      'lumpur',
      'Kue Lumpur 27',
      'Resep otentik kentang lumer',
      'Rp 7.000',
      '/pcs',
      '4.9 (420+)',
      'kue lumpur 27.jpeg',
      'WAJIB COBA',
    ),
    _RecommendationProduct(
      'bakso',
      'Bangkit Bakso Goreng Ayam',
      'Rasanya enak',
      'Rp 7.000',
      '/pcs',
      '4.9 (1.2k)',
      'bangkit bakso goreng.jpeg',
      'PRODUK LOKAL FAVORIT',
    ),
    _RecommendationProduct(
      'klepon',
      'Klepon-ku',
      'Rasanya Enak',
      'Rp 15.000',
      '/11 biji',
      '4.8 (850+)',
      'klepon.png',
      'PILIHAN PENGUNJUNG',
    ),
  ];

  static const _products = <_RecommendationProduct>[
    _RecommendationProduct(
      'tempe',
      'Lapak Tempe Bu Siti',
      'Tempe Segar Daun...',
      'Rp 4.500',
      'per papan',
      '4.9',
      'tempe segar.jpg',
      'Terlaris',
    ),
    _RecommendationProduct(
      'lumpur',
      'Kue Lumpur 27',
      'Kue Lumpur',
      'Rp 7.000',
      '/1 pcs',
      '4.9',
      'kue lumpur 27.jpeg',
      'Terlaris',
    ),
    _RecommendationProduct(
      'keripik',
      'Oleh-Oleh Khas Dowo',
      'Keripik Tempe Renyah',
      'Rp 15.000',
      'isi 200gr',
      '4.8',
      'kripik tempe.jpg',
      'Terlaris',
    ),
    _RecommendationProduct(
      'beras',
      'Toko Beras Barokah',
      'Beras Premium 5kg',
      'Rp 68.000',
      'per karung',
      '4.9',
      'tempe segar.jpg',
      'Terlaris',
    ),
    _RecommendationProduct(
      'klepon',
      'Klepon-ku',
      'Klepon Original',
      'Rp 15.000',
      '/10 biji',
      '4.8',
      'klepon.png',
      'Terlaris',
    ),
    _RecommendationProduct(
      'jajanan',
      'Kios Bu Lilik',
      'Jajanan Pasar Tampah',
      'Rp 25.000',
      'porsi 1 tampah mini',
      '5.0',
      'jajanan pasar.jpg',
      'Terlaris',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final products = [..._products];
    if (_sortByRating) {
      products.sort(
        (first, second) =>
            double.parse(second.rating).compareTo(double.parse(first.rating)),
      );
    }

    return MarketPage(
      child: Column(
        children: [
          _header(context),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              children: [
                _sectionHeading(
                  'Toko Rekomendasi',
                  action: 'Lihat Semua',
                  onAction: () => goTo(context, '/toko'),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 244,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    scrollDirection: Axis.horizontal,
                    itemCount: _stores.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (context, index) =>
                        _storeCard(context, _stores[index]),
                  ),
                ),
                const SizedBox(height: 22),
                _sectionHeading(
                  'Rekomendasi Untuk Kamu',
                  trailing: const Text(
                    'Kurasi Pilihan',
                    style: TextStyle(
                      color: MarketColors.muted,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                for (final highlight in _highlights) ...[
                  _highlightCard(highlight),
                  const SizedBox(height: 12),
                ],
                const SizedBox(height: 10),
                _sectionHeading(
                  'Produk Pilihan',
                  trailing: TextButton.icon(
                    onPressed: () =>
                        setState(() => _sortByRating = !_sortByRating),
                    icon: const Icon(Icons.tune_rounded, size: 15),
                    label: Text(_sortByRating ? 'Rating' : 'Terlaris'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF64748B),
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 32),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    mainAxisExtent: 270,
                  ),
                  itemBuilder: (context, index) =>
                      _productCard(products[index]),
                ),
              ],
            ),
          ),
          const BottomNavigation(active: 'Home'),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      height: 66,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: MarketColors.green.withValues(alpha: .25),
        border: Border.all(color: MarketColors.green.withValues(alpha: .25)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 0,
            child: Material(
              color: Colors.white,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => goBack(context),
                child: const SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(
                    Icons.arrow_back_rounded,
                    size: 20,
                    color: MarketColors.brown,
                  ),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Rekomendasi',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: MarketColors.brown,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Pilihan toko dan produk yang menarik untuk kamu',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: MarketColors.greenDark,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeading(
    String title, {
    String? action,
    VoidCallback? onAction,
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 16,
            decoration: BoxDecoration(
              color: MarketColors.yellow,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: MarketColors.brown,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: -.4,
              ),
            ),
          ),
          if (action != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                foregroundColor: MarketColors.greenDark,
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 32),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(action),
            )
          else if (trailing != null)
            trailing,
        ],
      ),
    );
  }

  Widget _storeCard(BuildContext context, _RecommendedStore store) {
    return InkWell(
      onTap: () => goTo(context, '/toko'),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 210,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: MarketColors.green),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22D56989),
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: MarketAsset(
                    store.image,
                    width: double.infinity,
                    height: 112,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  left: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: MarketColors.green,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      '● Buka',
                      style: TextStyle(
                        color: MarketColors.ink,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: _ratingBadge(store.rating),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              store.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF0F172A),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              store.category,
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 12,
              ),
            ),
            const Spacer(),
            const Divider(height: 12, color: Color(0xFFF1F5F9)),
            Row(
              children: [
                Expanded(
                  child: Text(
                    store.address,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 10,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                TextButton(
                  onPressed: () => goTo(context, '/toko'),
                  style: TextButton.styleFrom(
                    foregroundColor: MarketColors.greenDark,
                    backgroundColor: MarketColors.yellow.withValues(alpha: .35),
                    side: const BorderSide(color: MarketColors.green),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: const Size(0, 28),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Lihat Toko ›',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _highlightCard(_RecommendationProduct product) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: MarketAsset(
              product.image,
              width: 96,
              height: 96,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: MarketColors.yellow.withValues(alpha: .25),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    product.badge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: MarketColors.greenDark,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  product.store,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  product.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${product.price} ${product.unit}',
                        style: const TextStyle(
                          color: MarketColors.greenDark,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      '★ ${product.rating}',
                      style: const TextStyle(
                        color: MarketColors.brown,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _productCard(_RecommendationProduct product) {
    final saved = _savedProducts.contains(product.id);
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              MarketAsset(
                product.image,
                width: double.infinity,
                height: 151,
                fit: BoxFit.cover,
              ),
              Positioned(
                left: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .94),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '★ ${product.rating}',
                    style: const TextStyle(
                      color: MarketColors.brown,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 7,
                top: 7,
                child: IconButton.filledTonal(
                  onPressed: () => setState(() {
                    if (saved) {
                      _savedProducts.remove(product.id);
                    } else {
                      _savedProducts.add(product.id);
                    }
                  }),
                  icon: Icon(
                    saved ? Icons.bookmark_rounded : Icons.bookmark_border,
                    size: 18,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: MarketColors.greenDark,
                    minimumSize: const Size(32, 32),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 9, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.store,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 12,
                    height: 1.25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${product.price} ${product.unit}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: MarketColors.greenDark,
                    fontSize: 11,
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

  Widget _ratingBadge(String rating) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xB30F172A),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '★ $rating',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _RecommendedStore {
  const _RecommendedStore(
    this.name,
    this.category,
    this.address,
    this.rating,
    this.image,
  );

  final String name;
  final String category;
  final String address;
  final String rating;
  final String image;
}

class _RecommendationProduct {
  const _RecommendationProduct(
    this.id,
    this.store,
    this.description,
    this.price,
    this.unit,
    this.rating,
    this.image,
    this.badge,
  );

  final String id;
  final String store;
  final String description;
  final String price;
  final String unit;
  final String rating;
  final String image;
  final String badge;
}
