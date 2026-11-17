import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:frontend_flutter/core/presentation/widgets/market_ui.dart';
import 'package:frontend_flutter/features/visit_planner/domain/usecases/get_visit_recommendations.dart';
import 'package:frontend_flutter/features/visit_planner/presentation/pages/visit_planner_screen.dart'
    as visit_planner;

class FacilitiesScreen extends StatelessWidget {
  const FacilitiesScreen({super.key});

  static const _facilities = <(String, String, IconData, bool)>[
    ('Toilet Bersih', 'Terpisah pria/wanita & ramah difabel', Icons.wc, true),
    (
      'Mushola',
      'Terletak di Lt. 2, mukena & karpet bersih',
      Icons.mosque,
      false,
    ),
    (
      'Parkir',
      'Area motor & mobil dengan penjagaan resmi',
      Icons.local_parking,
      false,
    ),
    (
      'Foodcourt Legenda',
      'Kue lumpur, serabi, bakpao kentang',
      Icons.restaurant,
      true,
    ),
    (
      'Laktasi & Pos Medis',
      'Ruang ibu menyusui & P3K terpadu',
      Icons.medical_services,
      true,
    ),
    (
      'Aksesibilitas Difabel',
      'Jalur ramah kursi roda & pegangan tangan',
      Icons.accessible,
      false,
    ),
    (
      'Pojok Daur Ulang & Kompos',
      'Pengelolaan sampah organik pasar',
      Icons.recycling,
      false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MarketPage(
      child: Column(
        children: [
          PageTitleBar(
            title: 'Fasilitas Pasar',
            subtitle: '⌖ Pasar Oro-Oro Dowo, Malang',
            onBack: () => goBack(context),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: const LinearGradient(
                      colors: [
                        MarketColors.green,
                        Color(0xFFE7C2BD),
                        MarketColors.pinkLight,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _pill('Cagar Budaya SNI', color: MarketColors.pink),
                      const SizedBox(height: 11),
                      const Text(
                        'Kenyamanan Berbelanja Modern',
                        style: TextStyle(
                          fontSize: 18,
                          height: 1.3,
                          fontWeight: FontWeight.w800,
                          color: MarketColors.brown,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Standar kebersihan prima berpadu nuansa arsitektur kolonial cagar budaya sejak 1932. Terbuka, ramah, dan inklusif untuk seluruh warga.',
                        style: TextStyle(
                          fontSize: 11,
                          height: 1.5,
                          color: Color(0xCC2E2A2C),
                        ),
                      ),
                      const SizedBox(height: 13),
                      const Row(
                        children: [
                          Expanded(
                            child: _FacilityStat(
                              '12+ Sarana',
                              'LENGKAP & TERAWAT',
                            ),
                          ),
                          SizedBox(width: 7),
                          Expanded(
                            child: _FacilityStat(
                              '100% Inklusif',
                              'RAMAH DISABILITAS',
                            ),
                          ),
                          SizedBox(width: 7),
                          Expanded(
                            child: _FacilityStat(
                              'Higienis',
                              'SANITASI TIAP HARI',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                RoundedCard(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF0F4),
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: const Icon(
                              Icons.business,
                              color: MarketColors.pink,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Fasilitas & Parkir',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  'Kenyamanan & sarana pendukung pasar',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: MarketColors.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Text(
                            '7 Fasilitas',
                            style: TextStyle(
                              color: MarketColors.muted,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _facilities.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              mainAxisExtent: 76,
                            ),
                        itemBuilder: (context, index) {
                          final item = _facilities[index];
                          return Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F5F3),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 26,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    color: item.$4
                                        ? const Color(0xFFFFE3EB)
                                        : const Color(0xFFDEEBB7),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    item.$3,
                                    color: item.$4
                                        ? MarketColors.pink
                                        : const Color(0xFF5B6F2A),
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 7),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.$1,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          height: 1.3,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        item.$2,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: MarketColors.muted,
                                          fontSize: 8,
                                          height: 1.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 11),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0x47C2DC80),
                          border: Border.all(color: MarketColors.green),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.local_parking,
                              color: MarketColors.greenDark,
                              size: 20,
                            ),
                            SizedBox(width: 9),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tarif Parkir Resmi Pemkot',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  'Motor Rp 2.000  •  Mobil Rp 3.000',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: MarketColors.muted,
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
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3E9C4),
                    border: Border.all(color: MarketColors.green),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.verified, size: 18, color: MarketColors.brown),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Pasar terakreditasi SNI Pasar Rakyat dengan kebersihan lorong & sirkulasi udara optimal.',
                          style: TextStyle(
                            fontSize: 10,
                            height: 1.45,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const BottomNavigation(active: 'Home'),
        ],
      ),
    );
  }
}

class _FacilityStat extends StatelessWidget {
  const _FacilityStat(this.value, this.label);

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .84),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            maxLines: 1,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: const TextStyle(
              color: MarketColors.muted,
              fontSize: 7,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class VisitInfoScreen extends StatelessWidget {
  const VisitInfoScreen({super.key});

  Future<void> _openMap(BuildContext context) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=Pasar+Oro-Oro+Dowo+Malang',
    );
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aplikasi peta tidak dapat dibuka.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MarketPage(
      background: MarketColors.background,
      child: Container(
        color: MarketColors.background,
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                  child: _buildTopHeader(context),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 95),
                    children: [
                      // 1. Card 1: Header Gradient Card (Pasar Tradisional & Wisata Cagar Budaya)
                      _buildHeroCard(),
                      const SizedBox(height: 14),

                      // 2. Card 2: Jam Operasional
                      _buildOperatingHoursCard(),
                      const SizedBox(height: 14),

                      // 3. Card 3: Hari Pasaran & Kepadatan
                      _buildCrowdCard(),
                      const SizedBox(height: 14),

                      // 4. Card 4: Akses & Pilihan Transportasi
                      _buildTransportationCard(context),
                      const SizedBox(height: 14),

                      // 5. Card 5: Waktu Terbaik Berkunjung
                      _buildBestTimesCard(),
                    ],
                  ),
                ),
              ],
            ),

            // Bottom Floating Navigation
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: BottomNavigation(active: 'Home'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHeader(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => goBack(context),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.arrow_back,
                    size: 19,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
            ),
          ),
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Info Kunjungan',
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: Color(0xFF2E2426),
                  fontSize: 16.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
              SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_on, size: 12, color: Color(0xFF4B6515)),
                  SizedBox(width: 3),
                  Flexible(
                    child: Text(
                      'Pasar Oro-Oro Dowo, Malang',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Color(0xFF4B6515),
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
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

  Widget _buildHeroCard() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;
        // Scale relative to standard 350px mobile card width inside 380-402px screen
        final scale = (cardWidth / 350.0).clamp(0.85, 1.25);

        final badgeFontSize = (12.0 * scale).clamp(10.5, 14.0);
        final titleFontSize = (19.0 * scale).clamp(16.5, 23.0);
        final addressFontSize = (11.5 * scale).clamp(10.0, 13.5);
        final pillLabelSize = (10.0 * scale).clamp(8.5, 11.5);
        final pillValueSize = (13.5 * scale).clamp(11.5, 15.5);

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: 18.0 * scale,
            vertical: 18.0 * scale,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(38.0),
            border: Border.all(color: const Color(0xFF594045), width: 2.0),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFF7BF2E), // amber-gold top-left glow
                Color(0xFFC7DE7E), // soft pastel lime green
                Color(0xFFC3DD81), // pastel green center
                Color(0xFFDFD052), // warm yellow
                Color(0xFFF9BD36), // warm orange bottom-right
              ],
              stops: [0.0, 0.28, 0.55, 0.80, 1.0],
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x18000000),
                blurRadius: 16,
                spreadRadius: 0,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Top Badges Row
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                runSpacing: 6,
                children: [
                  // Left Badge: "Buka Sekarang"
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 11.0 * scale,
                      vertical: 6.0 * scale,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0x353E6510),
                      borderRadius: BorderRadius.circular(50.0),
                      border: Border.all(
                        color: const Color(0xFFD6E252),
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8.0 * scale,
                          height: 8.0 * scale,
                          decoration: const BoxDecoration(
                            color: Color(0xFF386616),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 6.0 * scale),
                        Text(
                          'Buka Sekarang',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: badgeFontSize,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2C5610),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Right Badge: "Cagar Budaya SNI"
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.0 * scale,
                      vertical: 6.0 * scale,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50.0),
                      border: Border.all(
                        color: const Color(0xFF594045),
                        width: 1.6,
                      ),
                    ),
                    child: Text(
                      'Cagar Budaya SNI',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: badgeFontSize,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF264612),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 14.0 * scale),

              // 2. Title (Exact two-line break matching reference)
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  'Pasar Tradisional & Wisata Cagar\nBudaya',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF111827),
                    height: 1.15,
                    letterSpacing: -0.2,
                  ),
                ),
              ),

              SizedBox(height: 7.0 * scale),

              // 3. Address Row (Location pin aligned with first line of address)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 2.0 * scale),
                    child: Icon(
                      Icons.location_on,
                      size: 14.0 * scale,
                      color: const Color(0xFF3F5A13),
                    ),
                  ),
                  SizedBox(width: 4.0 * scale),
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Jl. Guntur No. 20, Oro-oro Dowo, Kec. Klojen, Kota\nMalang, Jawa Timur 65119',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: addressFontSize,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF486315),
                          height: 1.35,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 13.0 * scale),

              // 4. Thin white horizontal divider line
              Container(
                height: 1.0,
                color: Colors.white.withValues(alpha: 0.55),
              ),

              SizedBox(height: 12.0 * scale),

              // 5. Three stat cards (Equal width, equal height, rounded cream pills)
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeroStatPill(
                      label: 'JAM BUKA',
                      value: '06.00 – 17.00',
                      labelSize: pillLabelSize,
                      valueSize: pillValueSize,
                      scale: scale,
                    ),
                    SizedBox(width: 8.0 * scale),
                    _buildHeroStatPill(
                      label: 'PEDAGANG',
                      value: '± 251 Kios',
                      labelSize: pillLabelSize,
                      valueSize: pillValueSize,
                      scale: scale,
                    ),
                    SizedBox(width: 8.0 * scale),
                    _buildHeroStatPill(
                      label: 'EST. BERDIRI',
                      value: 'Tahun 1932',
                      labelSize: pillLabelSize,
                      valueSize: pillValueSize,
                      scale: scale,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeroStatPill({
    required String label,
    required String value,
    required double labelSize,
    required double valueSize,
    required double scale,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 11.0 * scale,
          horizontal: 5.0 * scale,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F6E8),
          borderRadius: BorderRadius.circular(18.0 * scale),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: labelSize,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF70847D),
                letterSpacing: 0.3,
                height: 1.2,
              ),
            ),
            SizedBox(height: 4.0 * scale),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: valueSize,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF142E1F),
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    Color iconColor = const Color(0xFF4B6515),
    Color iconBackgroundColor = const Color(0xFFE0EDBF),
  }) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: iconBackgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 16, color: iconColor),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF111827),
                  fontSize: 13.0,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                subtitle,
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF64748B),
                  fontSize: 10.0,
                  fontWeight: FontWeight.w400,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
        ?trailing,
      ],
    );
  }

  Widget _buildOperatingHoursCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF594045), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF594045).withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 1.5,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          _buildSectionHeader(
            icon: Icons.schedule_rounded,
            title: 'Jam Operasional',
            subtitle: 'Jadwal transaksi harian pasar',
            trailing: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4.5,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFE0EDBF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Tutup 17.00 WIB',
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF3F5A13),
                  fontSize: 10.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 13),

          // Row 1: Senin – Jumat
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF6F3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              runSpacing: 4,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF59E0B),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Senin – Jumat',
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF1E293B),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Text(
                  '06.00 – 17.00 WIB',
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF1E293B),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Row 2: Sabtu – Minggu (Weekend)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: const Color(0xFFFEE9B3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF8A7B78).withValues(alpha: 0.5),
                width: 1.0,
              ),
            ),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              runSpacing: 4,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4B6515),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Sabtu – Minggu (Weekend)',
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF1E293B),
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Buka lebih lama untuk wisata kuliner',
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF7A6B62),
                              fontSize: 9.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Text(
                  '05.00 – 17.00 WIB',
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF1E293B),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Row 3: Jajanan Sore & Kuliner Luar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF6F3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              runSpacing: 4,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEA580C),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Jajanan Sore & Kuliner Luar',
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF1E293B),
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Kios terluar & foodcourt tertentu',
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF64748B),
                              fontSize: 9.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Text(
                  '06.00 – 17.00 WIB',
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF1E293B),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Bottom Info Box: SNI Pasar Rakyat
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFDF2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFDE68A), width: 1.0),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.verified, size: 15, color: Color(0xFFEA580C)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Pasar terakreditasi SNI Pasar Rakyat dengan kebersihan lorong & sirkulasi udara optimal.',
                    style: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFF9A3412),
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
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

  Widget _buildCrowdCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF594045), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF594045).withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 1.5,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          _buildSectionHeader(
            icon: Icons.bar_chart_rounded,
            title: 'Hari Pasaran & Kepadatan',
            subtitle: 'Estimasi kepadatan pengunjung pasar',
            iconColor: const Color(0xFFD97706),
            iconBackgroundColor: const Color(0xFFFEF3C7),
            trailing: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4.5,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFE0EDBF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Live Tren',
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF3F5A13),
                  fontSize: 10.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 13),

          // Baris 1: Senin – Kamis
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF6F3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  runSpacing: 4,
                  children: [
                    Text(
                      'Senin – Kamis',
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF111827),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0EDBF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Rendah – Nyaman',
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF3B5812),
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                _buildProgressBar(0.35, const Color(0xFFB5D960)),
                const SizedBox(height: 5),
                Text(
                  'Sangat kondusif belanja sayuran segar harian, rempah-rempah, dan daging tanpa antrean.',
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF64748B),
                    fontSize: 9.5,
                    fontWeight: FontWeight.w400,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Baris 2: Jumat
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF6F3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  runSpacing: 4,
                  children: [
                    Text(
                      'Jumat',
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF111827),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Sedang',
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFFD97706),
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                _buildProgressBar(0.58, const Color(0xFFF59E0B)),
                const SizedBox(height: 5),
                Text(
                  'Ramai di pagi hari (06.30 – 09.30 WIB) menjelang persiapan ibadah salat Jumat.',
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF64748B),
                    fontSize: 9.5,
                    fontWeight: FontWeight.w400,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Baris 3: Sabtu & Minggu
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFDF5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFD8E2AC), width: 1.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  runSpacing: 4,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 6,
                      children: [
                        Text(
                          'Sabtu & Minggu',
                          style: GoogleFonts.plusJakartaSans(
                            color: const Color(0xFF111827),
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4B6515),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'PUNCAK',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF4B6515),
                          width: 1.2,
                        ),
                      ),
                      child: Text(
                        'Ramai Wisatawan',
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF4B6515),
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                _buildProgressBar(0.92, const Color(0xFF4B6515)),
                const SizedBox(height: 5),
                Text(
                  'Penuh pemburu jajanan legendaris seperti Serabi Solo & Kue Lumpur 27.',
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF64748B),
                    fontSize: 9.5,
                    fontWeight: FontWeight.w400,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(double factor, Color color) {
    return Container(
      height: 6,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: factor.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Widget _buildTransportationCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF594045), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF594045).withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 1.5,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSectionHeader(
            icon: Icons.near_me_rounded,
            title: 'Akses & Pilihan Transportasi',
            subtitle: 'Rute mudah menuju Pasar Oro-Oro Dowo',
          ),
          const SizedBox(height: 13),

          // Stylized Map preview box
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _openMap(context),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                height: 105,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFEBF3F2),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFD4E2D0)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        left: -24,
                        right: -24,
                        top: 47,
                        child: Transform.rotate(
                          angle: -0.09,
                          child: Container(
                            height: 13,
                            color: const Color(0xFFFFF4CF),
                          ),
                        ),
                      ),
                      Positioned(
                        left: -28,
                        right: -28,
                        top: 19,
                        child: Transform.rotate(
                          angle: 0.36,
                          child: Container(
                            height: 11,
                            color: Colors.white.withValues(alpha: 0.78),
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(0, -7),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4.5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(0xFFD8E4D5),
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x12000000),
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.storefront_rounded,
                                    size: 12,
                                    color: Color(0xFF4B6515),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    'Pasar Oro-Oro Dowo',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: const Color(0xFF4B6515),
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 3),
                            Container(
                              width: 16,
                              height: 16,
                              decoration: const BoxDecoration(
                                color: Color(0xFF4B6515),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.location_on,
                                size: 11,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // 1. Kendaraan Pribadi
          _buildTransportItem(
            icon: Icons.directions_car_rounded,
            title: 'Kendaraan Pribadi',
            desc: 'Akses nyaman dari arah Jl. Ijen melalui Jl. Guntur atau Jl. Buring. Lahan parkir mobil tersedia di sisi utara & selatan.',
          ),
          const SizedBox(height: 8),

          // 2. Angkutan Kota (Mikrolet)
          _buildTransportItem(
            icon: Icons.directions_bus_rounded,
            title: 'Angkutan Kota (Mikrolet)',
            desc: 'Jalur angkot kode AL (Arjosari – Landungsari), ABG, dan MM melintasi dekat persimpangan Jl. Guntur.',
          ),
          const SizedBox(height: 8),

          // 3. Ojek & Taksi Online (Grab / Gojek)
          _buildTransportItem(
            icon: Icons.local_taxi_rounded,
            title: 'Ojek & Taksi Online (Grab / Gojek)',
            desc: 'Pilihan penjemputan yang nyaman melalui titik lokasi Pasar Oro-Oro Dowo agar mudah dijangkau pengemudi.',
          ),
          const SizedBox(height: 12),

          // 4. CTA Button: Buka di Google Maps
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _openMap(context),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 11),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBBF24),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33F59E0B),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 7,
                  children: [
                    const Icon(
                      Icons.navigation_rounded,
                      size: 15,
                      color: Colors.white,
                    ),
                    Text(
                      'Buka di Google Maps',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransportItem({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF6F3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1.5),
            child: Icon(icon, size: 15, color: const Color(0xFF475569)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF1E293B),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF64748B),
                    fontSize: 9.5,
                    fontWeight: FontWeight.w400,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBestTimesCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF594045), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF594045).withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 1.5,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSectionHeader(
            icon: Icons.alarm_on_rounded,
            title: 'Waktu Terbaik Berkunjung',
            subtitle: 'Sesuaikan waktu dengan kebutuhan Anda',
          ),
          const SizedBox(height: 13),

          // Slot 1: Belanja Dapur Segar Petani
          _buildTimeSlotItem(
            timeRange: '06.00 – 08.30 WIB',
            timeColor: const Color(0xFF4B6515),
            badgeText: 'Bahan Pokok Segar',
            badgeBgColor: const Color(0xFFC2DC80),
            badgeTextColor: const Color(0xFF2E4010),
            accentColor: const Color(0xFF4B6515),
            cardBgColor: const Color(0xFFFAF6F3),
            title: 'Belanja Dapur Segar Petani',
            description: 'Waktu terbaik mendapatkan sayuran hijau, daging segar baru potong, dan bumbu dapur langsung dari petani Batu/Malang.',
          ),
          const SizedBox(height: 8),

          // Slot 2: Jajanan Tradisional & Santai
          _buildTimeSlotItem(
            timeRange: '08.30 – 11.00 WIB',
            timeColor: const Color(0xFFD97706),
            badgeText: 'Wisata Kuliner',
            badgeBgColor: const Color(0xFFFEF3C7),
            badgeTextColor: const Color(0xFF92400E),
            accentColor: const Color(0xFFFBBF24),
            cardBgColor: const Color(0xFFFAF6F3),
            title: 'Jajanan Tradisional & Santai',
            description: 'Nikmati jajanan legendaris seperti kue lumpur hangat, onde-onde, dan serabi ubi ketan sambil menikmati kopi santai.',
          ),
          const SizedBox(height: 8),

          // Slot 3: Belanja Praktis & Tenang
          _buildTimeSlotItem(
            timeRange: '14.00 – 16.00 WIB',
            timeColor: const Color(0xFF3B5812),
            badgeText: 'Lengang & Cepat',
            badgeBgColor: const Color(0xFFCFE39D),
            badgeTextColor: const Color(0xFF166534),
            accentColor: const Color(0xFF84CC16),
            cardBgColor: const Color(0xFFF0F6DF),
            title: 'Belanja Praktis & Tenang',
            description: 'Lorong pasar sudah lebih sepi. Cocok untuk Anda yang ingin belanja kilat tanpa antre di kasir atau lapak.',
          ),
          const SizedBox(height: 10),

          // Tips Ramah Lingkungan
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: const Color(0xFFFEE9B3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFC8AD8C)),
            ),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC2DC80),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.eco_rounded,
                    color: Color(0xFF4B6515),
                    size: 17,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Tips Ramah Lingkungan',
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF1E293B),
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Bawa kantong belanja kain (totebag) sendiri untuk mendukung program pasar bersih bebas sampah plastik!',
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF594045),
                          fontSize: 9.5,
                          fontWeight: FontWeight.w500,
                          height: 1.35,
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
    );
  }

  Widget _buildTimeSlotItem({
    required String timeRange,
    required Color timeColor,
    required String badgeText,
    required Color badgeBgColor,
    required Color badgeTextColor,
    required Color accentColor,
    required Color cardBgColor,
    required String title,
    required String description,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 3.5, color: accentColor),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 9),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        runSpacing: 4,
                        children: [
                          Text(
                            timeRange,
                            style: GoogleFonts.plusJakartaSans(
                              color: timeColor,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2.5,
                            ),
                            decoration: BoxDecoration(
                              color: badgeBgColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              badgeText,
                              style: GoogleFonts.plusJakartaSans(
                                color: badgeTextColor,
                                fontSize: 9.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        title,
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF1E293B),
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        description,
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF64748B),
                          fontSize: 9.5,
                          fontWeight: FontWeight.w400,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LegacyRecommendationsScreen extends StatefulWidget {
  const LegacyRecommendationsScreen({super.key});

  @override
  State<LegacyRecommendationsScreen> createState() =>
      _LegacyRecommendationsScreenState();
}

class _LegacyRecommendationsScreenState
    extends State<LegacyRecommendationsScreen> {
  final Set<String> _savedProducts = {};
  bool _sortByRating = false;

  static const _products = <_RecommendationProduct>[
    _RecommendationProduct(
      'tempe',
      'Lapak Tempe Bu Siti',
      'Tempe Segar Daun...',
      'Rp 4.500',
      'per papan',
      '4.9',
      'tempe segar.jpg',
    ),
    _RecommendationProduct(
      'lumpur',
      'Kue Lumpur 27',
      'Kue Lumpur',
      'Rp 7.000',
      '/pcs',
      '4.9',
      'kue lumpur 27.jpeg',
    ),
    _RecommendationProduct(
      'keripik',
      'Oleh-Oleh Khas Dowo',
      'Keripik Tempe Renyah',
      'Rp 15.000',
      'isi 200gr',
      '4.8',
      'kripik tempe.jpg',
    ),
    _RecommendationProduct(
      'bakso',
      'Toko Beras Barokah',
      'Bangkit Bakso Goreng Ay...',
      'Rp 7.000',
      '/pcs',
      '4.9',
      'bangkit bakso goreng.jpeg',
    ),
    _RecommendationProduct(
      'klepon',
      'Klepon-ku',
      'Klepon Original',
      'Rp 15.000',
      '/10 biji',
      '4.8',
      'klepon.png',
    ),
    _RecommendationProduct(
      'jajanan',
      'Kios Bu Lilik',
      'Jajanan Pasar Tampah',
      'Rp 25.000',
      'porsi tampah mini',
      '5.0',
      'jajanan pasar.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final items = [..._products];
    if (_sortByRating) {
      items.sort(
        (first, second) =>
            double.parse(second.rating).compareTo(double.parse(first.rating)),
      );
    }
    return MarketPage(
      child: Column(
        children: [
          PageTitleBar(
            title: 'Rekomendasi',
            subtitle: 'Pilihan toko dan produk yang menarik untuk kamu',
            onBack: () => goBack(context),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 13, 16, 16),
              children: [
                Row(
                  children: [
                    const Expanded(child: SectionHeading('Toko Rekomendasi')),
                    TextButton(
                      onPressed: () => goTo(context, '/toko'),
                      child: const Text(
                        'Lihat Semua',
                        style: TextStyle(
                          fontSize: 10,
                          color: MarketColors.pink,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 189,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _recommendedStoreCard(
                        context,
                        'Lumpur Kentang 27',
                        'Kuliner Legend',
                        'Blok B No. 12',
                        '4.8',
                        'lumpur kentang 27.jpeg',
                      ),
                      const SizedBox(width: 10),
                      _recommendedStoreCard(
                        context,
                        'Pangsit Mie Arema',
                        'Makanan',
                        'Teras Timur No. 04',
                        '4.8',
                        'pangsit mie arema.png',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Row(
                  children: [
                    Expanded(child: SectionHeading('Rekomendasi Untuk Kamu')),
                    Text(
                      'Kurasi Pilihan',
                      style: TextStyle(
                        color: MarketColors.greenDark,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _curatedCard(
                  'WAJIB COBA',
                  'Kue Lumpur 27',
                  'Resep otentik kentang lumper',
                  'Rp 7.000',
                  '/pcs',
                  '4.9 (420+)',
                  'kue lumpur 27.jpeg',
                  const Color(0xFFFFF1F4),
                ),
                _curatedCard(
                  'PRODUK LOKAL FAVORIT',
                  'Bangkit Bakso Goreng Ayam',
                  'Rasanya enak',
                  'Rp 7.000',
                  '/pcs',
                  '4.9 (1.2k)',
                  'bangkit bakso goreng.jpeg',
                  const Color(0xFFF2F7E5),
                ),
                _curatedCard(
                  'PILIHAN PENGUNJUNG',
                  'Klepon-ku',
                  'Rasanya enak',
                  'Rp 15.000',
                  '/10 biji',
                  '4.8 (850+)',
                  'klepon.png',
                  const Color(0xFFFFF7DF),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Expanded(child: SectionHeading('Produk Pilihan')),
                    TextButton.icon(
                      onPressed: () =>
                          setState(() => _sortByRating = !_sortByRating),
                      icon: const Icon(Icons.tune, size: 15),
                      label: Text(_sortByRating ? 'Rating' : 'Terlaris'),
                      style: TextButton.styleFrom(
                        foregroundColor: MarketColors.pink,
                      ),
                    ),
                  ],
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 9,
                    mainAxisSpacing: 9,
                    mainAxisExtent: 236,
                  ),
                  itemBuilder: (context, index) {
                    final product = items[index];
                    final saved = _savedProducts.contains(product.id);
                    return Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(17),
                        border: Border.all(color: const Color(0x22D56989)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              MarketAsset(
                                product.image,
                                width: double.infinity,
                                height: 122,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                top: 7,
                                right: 7,
                                child: IconButton.filledTonal(
                                  onPressed: () => setState(() {
                                    if (saved) {
                                      _savedProducts.remove(product.id);
                                    } else {
                                      _savedProducts.add(product.id);
                                    }
                                  }),
                                  icon: Icon(
                                    saved
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                    size: 17,
                                  ),
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: MarketColors.pink,
                                    minimumSize: const Size(30, 30),
                                    padding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 7,
                                bottom: 7,
                                child: _pill(
                                  '★ ${product.rating}',
                                  color: MarketColors.brown,
                                  background: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(9),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.store,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 8,
                                    color: MarketColors.muted,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  product.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    height: 1.2,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '${product.price} ${product.unit}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: MarketColors.pink,
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
                  },
                ),
              ],
            ),
          ),
          const BottomNavigation(active: 'Home'),
        ],
      ),
    );
  }

  Widget _recommendedStoreCard(
    BuildContext context,
    String name,
    String category,
    String address,
    String rating,
    String image,
  ) {
    return InkWell(
      onTap: () => goTo(context, '/toko'),
      child: Container(
        width: 176,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: const Color(0xFFC2DC80)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                MarketAsset(image, width: 176, height: 102, fit: BoxFit.cover),
                Positioned(
                  left: 8,
                  top: 8,
                  child: _pill(
                    '● Buka',
                    color: MarketColors.greenDark,
                    background: Colors.white,
                  ),
                ),
                Positioned(
                  right: 8,
                  bottom: 7,
                  child: _pill(
                    '★ $rating',
                    color: MarketColors.brown,
                    background: Colors.white,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    category,
                    style: const TextStyle(
                      fontSize: 9,
                      color: MarketColors.muted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address,
                    style: const TextStyle(
                      fontSize: 9,
                      color: MarketColors.brown,
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

  Widget _curatedCard(
    String badge,
    String name,
    String desc,
    String price,
    String unit,
    String rating,
    String image,
    Color tone,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0x22D56989)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: MarketAsset(image, width: 76, height: 82, fit: BoxFit.cover),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _pill(badge, color: MarketColors.brown, background: tone),
                const SizedBox(height: 4),
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  desc,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: MarketColors.muted,
                    fontSize: 9,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '$price $unit  •  ★ $rating',
                  style: const TextStyle(
                    color: MarketColors.pink,
                    fontSize: 9,
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
}

class _RecommendationProduct {
  const _RecommendationProduct(
    this.id,
    this.store,
    this.name,
    this.price,
    this.unit,
    this.rating,
    this.image,
  );

  final String id;
  final String store;
  final String name;
  final String price;
  final String unit;
  final String rating;
  final String image;
}

class VisitPlannerScreen extends StatelessWidget {
  const VisitPlannerScreen({required this.getVisitRecommendations, super.key});

  final GetVisitRecommendations getVisitRecommendations;

  @override
  Widget build(BuildContext context) {
    return visit_planner.VisitPlannerScreen(
      getVisitRecommendations: getVisitRecommendations,
    );
  }
}

Widget _pill(
  String text, {
  required Color color,
  Color background = Colors.white,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: color, fontSize: 8, fontWeight: FontWeight.w700),
    ),
  );
}
