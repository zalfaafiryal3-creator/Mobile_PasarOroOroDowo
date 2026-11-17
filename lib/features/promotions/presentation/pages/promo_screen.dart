import 'package:flutter/material.dart';
import 'package:frontend_flutter/core/presentation/widgets/market_ui.dart';
import 'package:frontend_flutter/features/promotions/domain/entities/promo.dart';
import 'package:frontend_flutter/features/promotions/domain/usecases/get_promotions.dart';

class PromoScreen extends StatefulWidget {
  const PromoScreen({required this.getPromotions, super.key});

  final GetPromotions getPromotions;

  @override
  State<PromoScreen> createState() => _PromoScreenState();
}

class _PromoScreenState extends State<PromoScreen> {
  final _searchController = TextEditingController();
  String _filter = 'Semua Jadwal';

  static const _filters = [
    'Semua Jadwal',
    'Sedang Berlangsung',
    'Akhir Pekan',
    'Akan Datang',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final search = _searchController.text.trim().toLowerCase();
    final promos = widget.getPromotions().where((promo) {
      final matchesQuery = '${promo.title} ${promo.status} ${promo.description}'
          .toLowerCase()
          .contains(search);
      final matchesFilter = switch (_filter) {
        'Sedang Berlangsung' => promo.ongoing,
        'Akhir Pekan' => promo.weekend,
        'Akan Datang' => promo.status == 'Akan Datang',
        _ => true,
      };
      return matchesQuery && matchesFilter;
    }).toList();

    return MarketPage(
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                color: MarketColors.background,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const BrandHeader(),
                    const SizedBox(height: 14),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Info Promo & Event',
                                  style: TextStyle(
                                    color: Color(0xFF263238),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    height: 22 / 18,
                                  ),
                                ),
                                Text(
                                  'Jadwal & Periode Diskon Pasar',
                                  style: TextStyle(
                                    color: Color(0xFF6B6B6B),
                                    fontSize: 10,
                                    height: 13 / 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFB91D),
                              borderRadius: BorderRadius.circular(99),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x33C29114),
                                  blurRadius: 5,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.calendar_month_outlined,
                                  size: 11,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Okt 2026',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    height: 12 / 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 34,
                      child: TextField(
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
                        style: const TextStyle(
                          color: Color(0xFF374151),
                          fontSize: 11,
                        ),
                        decoration: InputDecoration(
                          hintText:
                              'Cari promo sayur, kuliner, jadwal pasar...',
                          hintStyle: const TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 11,
                          ),
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(left: 14, right: 10),
                            child: Icon(
                              Icons.search,
                              size: 16,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                          prefixIconConstraints: const BoxConstraints(
                            minWidth: 40,
                            minHeight: 34,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(999),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(999),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(999),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 104),
                  children: [
                    Row(
                      children: List.generate(_filters.length, (index) {
                        final filter = _filters[index];
                        final selected = _filter == filter;
                        final flex = switch (index) {
                          1 => 136,
                          2 => 90,
                          3 => 94,
                          _ => 100,
                        };
                        return Expanded(
                          flex: flex,
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: index == _filters.length - 1 ? 0 : 8,
                            ),
                            child: SizedBox(
                              height: 26,
                              child: TextButton(
                                onPressed: () =>
                                    setState(() => _filter = filter),
                                style: TextButton.styleFrom(
                                  backgroundColor: selected
                                      ? const Color(0xFFFFB91D)
                                      : const Color(0xFFD5E7A5),
                                  foregroundColor: selected
                                      ? Colors.white
                                      : const Color(0xFF35422A),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  shape: const StadiumBorder(),
                                ),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    filter,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 12),
                    _featuredFestival(),
                    const SizedBox(height: 13),
                    Row(
                      children: [
                        const Icon(
                          Icons.campaign_outlined,
                          size: 15,
                          color: MarketColors.yellow,
                        ),
                        const SizedBox(width: 6),
                        const Expanded(
                          child: Text(
                            'Daftar Jadwal Promo',
                            style: TextStyle(
                              color: MarketColors.ink,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Text(
                          '4 Program Aktif',
                          style: const TextStyle(
                            color: MarketColors.muted,
                            fontSize: 8,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (promos.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(18),
                        child: Text(
                          'Tidak ada promo yang cocok.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: MarketColors.muted,
                            fontSize: 12,
                          ),
                        ),
                      )
                    else
                      ...promos.map(_promoCard),
                    const SizedBox(height: 1),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0x66C2DC80)),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0B4B6515),
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 1),
                            child: Icon(
                              Icons.info_outline,
                              color: Color(0xFF4B6515),
                              size: 18,
                            ),
                          ),
                          SizedBox(width: 9),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Informasi Penting',
                                  style: TextStyle(
                                    color: MarketColors.ink,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Seluruh promo pada halaman ini berlaku otomatis saat bertransaksi langsung di kasir kios pedagang selama periode aktif yang tercantum. Anda tidak perlu mengklaim voucher maupun menukarkan kupon apa pun.',
                                  style: TextStyle(
                                    fontSize: 10,
                                    height: 1.45,
                                    color: Color(0xFF4B5563),
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
            ],
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: _promoBottomNavigation(context),
          ),
        ],
      ),
    );
  }

  Widget _promoBottomNavigation(BuildContext context) {
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
          final active = item.$1 == 'Promo';
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

  Widget _featuredFestival() {
    return Container(
      constraints: const BoxConstraints(minHeight: 160),
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFC2DC80), Color(0xFFD4E89A), Color(0xFFF5CE5A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.50, 1.0],
        ),
        borderRadius: BorderRadius.circular(19),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Top-right decorative triangle pattern (matching reference image)
          Positioned(
            top: -4,
            right: -4,
            child: SizedBox(
              width: 72,
              height: 72,
              child: CustomPaint(painter: _TrianglePatternPainter()),
            ),
          ),
          // Main content column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge pill with calendar icon
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .65),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 9,
                      color: Color(0xFF607345),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'AGENDA UTAMA PASAR',
                      style: TextStyle(
                        color: Color(0xFF607345),
                        fontSize: 8,
                        height: 1.2,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Title
              const Text(
                'Festival Belanja Pasar',
                style: TextStyle(
                  color: Color(0xFF2D3B1A),
                  fontSize: 20,
                  height: 1.25,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 5),
              // Description
              const SizedBox(
                width: 240,
                child: Text(
                  'Penawaran serentak pedagang Pasar Oro-Oro Dowo untuk produk segar, bumbu tradisi, dan jajanan tempo doeloe.',
                  style: TextStyle(
                    color: Color(0xFF3A4D24),
                    fontSize: 10,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Bottom row: period pill + duration pill
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(9, 5, 11, 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .92),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 13,
                          color: Color(0xFFFBBF24),
                        ),
                        SizedBox(width: 6),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PERIODE BERLAKU',
                              style: TextStyle(
                                color: Color(0xFF9CA3AF),
                                fontSize: 6.5,
                                height: 1.2,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                            Text(
                              '15 Okt – 31 Okt 2026',
                              style: TextStyle(
                                color: Color(0xFF2D3B1A),
                                fontSize: 9,
                                height: 1.3,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7FAD3A),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: const Text(
                      '16 Hari',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        height: 1.2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _promoCard(Promo promo) {
    final isUpcoming = promo.status == 'Akan Datang';
    final isMarketDay = !promo.ongoing && !isUpcoming && !promo.weekend;
    final statusIcon = isUpcoming || isMarketDay
        ? Icons.access_time
        : promo.weekend
        ? Icons.calendar_month_outlined
        : Icons.check_circle_outline;
    final noteIcon = isUpcoming
        ? Icons.hourglass_bottom
        : promo.ongoing
        ? Icons.storefront_outlined
        : promo.weekend
        ? Icons.location_on_outlined
        : Icons.access_time;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 382),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0x66C2DC80)),
              borderRadius: BorderRadius.circular(19),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0B4B6515),
                  blurRadius: 14,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 2.55,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        const ColoredBox(color: Color(0xFFF6F7EF)),
                        MarketAsset(promo.image, fit: BoxFit.cover),
                        Positioned(
                          top: 7,
                          left: 7,
                          child: _promoImageBadge(
                            promo.status,
                            icon: statusIcon,
                            isStatus: true,
                          ),
                        ),
                        Positioned(
                          right: 7,
                          bottom: 7,
                          child: _promoImageBadge(promo.note, icon: noteIcon),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(1, 8, 1, 1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        promo.title,
                        style: const TextStyle(
                          color: MarketColors.ink,
                          fontSize: 14,
                          height: 19 / 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          promo.description,
                          style: const TextStyle(
                            color: Color(0xFF4B5563),
                            fontSize: 10,
                            height: 1.5,
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE4F0C5),
                          border: Border.all(color: const Color(0xFFDCECB5)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            _promoDetailRow(
                              icon: Icons.calendar_month_outlined,
                              label: promo.periodLabel,
                              value: promo.period,
                            ),
                            const SizedBox(height: 3),
                            _promoDetailRow(
                              icon: Icons.access_time,
                              label: promo.timeLabel,
                              value: promo.time,
                              isClock: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 7),
                      Row(
                        children: [
                          const Icon(
                            Icons.check_circle_outline,
                            color: Color(0xFF168268),
                            size: 12,
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              promo.finePrint,
                              style: const TextStyle(
                                color: Color(0xFF4B5563),
                                fontSize: 8,
                                height: 11 / 8,
                              ),
                            ),
                          ),
                          const SizedBox(width: 7),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFB91D),
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: Text(
                              promo.category,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 7,
                                height: 9 / 7,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _promoImageBadge(
    String text, {
    required IconData icon,
    bool isStatus = false,
  }) {
    return Container(
      constraints: const BoxConstraints(minHeight: 26),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: isStatus ? const Color(0xFFFBBF24) : Colors.white,
        border: Border.all(color: const Color(0xFFFBBF24)),
        borderRadius: BorderRadius.circular(99),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F4B6515),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: isStatus ? Colors.white : const Color(0xFFFBBF24),
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: isStatus ? Colors.white : const Color(0xFFFBBF24),
              fontSize: 10,
              height: 14 / 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _promoDetailRow({
    required IconData icon,
    required String label,
    required String value,
    bool isClock = false,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 12,
          color: isClock ? const Color(0xFF4B6515) : MarketColors.yellow,
        ),
        const SizedBox(width: 5),
        Text(
          '$label:',
          style: const TextStyle(
            color: Color(0xFF39412F),
            fontSize: 8,
            height: 12 / 8,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Color(0xFF39412F),
              fontSize: 8,
              height: 12 / 8,
            ),
          ),
        ),
      ],
    );
  }
}

class _TrianglePatternPainter extends CustomPainter {
  const _TrianglePatternPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x30FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final path1 = Path()
      ..moveTo(size.width * 0.55, 0)
      ..lineTo(size.width, size.height * 0.55)
      ..moveTo(size.width * 0.72, 0)
      ..lineTo(size.width, size.height * 0.72)
      ..moveTo(size.width * 0.88, 0)
      ..lineTo(size.width, size.height * 0.88)
      ..moveTo(size.width, 0)
      ..lineTo(size.width, 0);

    for (int i = 0; i < 5; i++) {
      final double offset = i * (size.width / 5.5);
      final path = Path()
        ..moveTo(size.width - offset, 0)
        ..lineTo(size.width, offset);
      canvas.drawPath(path, paint);
    }

    canvas.drawPath(path1, paint);
  }

  @override
  bool shouldRepaint(_TrianglePatternPainter oldDelegate) => false;
}
