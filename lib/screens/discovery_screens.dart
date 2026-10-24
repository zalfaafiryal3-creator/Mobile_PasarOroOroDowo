import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/market_data.dart';
import '../widgets/market_ui.dart';

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
      background: const Color(0xFFF0F6DF),
      child: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
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
            left: 16,
            right: 16,
            bottom: 16,
            child: _marketBottomNavigation(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTopHeader(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: InkWell(
            onTap: () => goBack(context),
            borderRadius: BorderRadius.circular(999),
            child: Container(
              width: 36,
              height: 36,
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
              child: const Icon(
                Icons.arrow_back_rounded,
                size: 18,
                color: Color(0xFF594045),
              ),
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'Info Kunjungan',
              style: TextStyle(
                color: Color(0xFF594045),
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.location_on, size: 12, color: Color(0xFF526B31)),
                SizedBox(width: 3),
                Text(
                  'Pasar Oro-Oro Dowo, Malang',
                  style: TextStyle(
                    color: Color(0xFF526B31),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeroCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE2EA66), Color(0xFFFABE2C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18FABE2C),
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top badges row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle, size: 7, color: Color(0xFF42491C)),
                        SizedBox(width: 4),
                        Text(
                          'Buka Sekarang',
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF42491C),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'Cagar Budaya SNI',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF42491C),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Main Title
          const Text(
            'Pasar Tradisional & Wisata Cagar\nBudaya',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: Color(0xFF3B2822),
              height: 1.25,
            ),
          ),
          const SizedBox(height: 6),

          // Address with pin
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 1.5),
                child: Icon(
                  Icons.location_on,
                  size: 13,
                  color: Color(0xFF3B2822),
                ),
              ),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Jl. Guntur No. 20, Oro-oro Dowo, Kec. Klojen, Kota Malang, Jawa Timur 65119',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3B2822),
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Three stats pills
          Row(
            children: [
              Expanded(child: _buildHeroStatPill('JAM BUKA', '06.00 – 17.00')),
              const SizedBox(width: 8),
              Expanded(child: _buildHeroStatPill('PEDAGANG', '± 251 Kios')),
              const SizedBox(width: 8),
              Expanded(child: _buildHeroStatPill('EST. BERDIRI', 'Tahun 1932')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroStatPill(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 8.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF78716C),
                letterSpacing: 0.3,
              ),
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Color(0xFF594045),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOperatingHoursCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10594045),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFFE2F0C2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.access_time_filled,
                  color: Color(0xFF526B31),
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jam Operasional',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF594045),
                      ),
                    ),
                    Text(
                      'Jadwal transaksi harian pasar',
                      style: TextStyle(fontSize: 9.5, color: Color(0xFF9CA3AF)),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2F0C2),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'Tutup 17.00 WIB',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF526B31),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Row 1: Senin - Jumat
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Row(
              children: [
                Icon(Icons.stop_rounded, size: 10, color: Color(0xFFF59E0B)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Senin – Jumat',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF594045),
                    ),
                  ),
                ),
                Text(
                  '06.00 – 17.00 WIB',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF594045),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),

          // Row 2: Sabtu - Minggu (Weekend)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FBE7),
              border: Border.all(color: const Color(0xFFE2F0C2)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.stop_rounded, size: 10, color: Color(0xFF526B31)),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sabtu – Minggu (Weekend)',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF594045),
                        ),
                      ),
                      SizedBox(height: 1),
                      Text(
                        'Buka lebih lama untuk wisata kuliner',
                        style: TextStyle(
                          fontSize: 9,
                          color: Color(0xFF526B31),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 6),
                Text(
                  '05.30 – 17.00 WIB',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF594045),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),

          // Row 3: Jajanan Sore & Kuliner Luar
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Row(
              children: [
                Icon(Icons.stop_rounded, size: 10, color: Color(0xFFF59E0B)),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jajanan Sore & Kuliner Luar',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF594045),
                        ),
                      ),
                      SizedBox(height: 1),
                      Text(
                        'Area kuliner luar & food court semi-terbuka',
                        style: TextStyle(fontSize: 9, color: Color(0xFF9CA3AF)),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 6),
                Text(
                  '06.00 – 17.00 WIB',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF594045),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Bottom alert/notice
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              border: Border.all(color: const Color(0xFFFEF3C7)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 1),
                  child: Icon(
                    Icons.info_outline_rounded,
                    size: 15,
                    color: Color(0xFFD97706),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Pasar termodernisasi SNI Pasar Rakyat dengan kebersihan lorong & sirkulasi udara optimal.',
                    style: TextStyle(
                      fontSize: 9.5,
                      color: Color(0xFF92400E),
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
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10594045),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2F0C2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.bar_chart_rounded,
                  color: Color(0xFF526B31),
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hari Pasaran & Kepadatan',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF594045),
                      ),
                    ),
                    Text(
                      'Estimasi kepadatan pengunjung pasar',
                      style: TextStyle(fontSize: 9.5, color: Color(0xFF9CA3AF)),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2F0C2),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'Live Tren',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF526B31),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 1. Senin - Kamis
          _buildCrowdItem(
            day: 'Senin – Kamis',
            badgeText: 'Rendah - Nyaman',
            badgeBg: const Color(0xFFE2F0C2),
            badgeTextColor: const Color(0xFF526B31),
            progress: 0.35,
            progressColor: const Color(0xFFB8D66D),
            description: 'Sangat direkomendasikan untuk belanja sayuran harian, rempah-rempah, dan daging tanpa antrean.',
          ),
          const SizedBox(height: 12),

          // 2. Jumat
          _buildCrowdItem(
            day: 'Jumat',
            badgeText: 'Sedang',
            badgeBg: const Color(0xFFFEF3C7),
            badgeTextColor: const Color(0xFFD97706),
            progress: 0.60,
            progressColor: const Color(0xFFF59E0B),
            description: 'Ramai di pagi hari (06.30 – 09.30 WIB) karena kebutuhan stok masak akhir pekan.',
          ),
          const SizedBox(height: 12),

          // 3. Sabtu & Minggu
          _buildCrowdItem(
            day: 'Sabtu & Minggu',
            extraBadge: 'PUNCAK',
            badgeText: 'Ramai Wisatawan',
            badgeBg: const Color(0xFFE2F0C2),
            badgeTextColor: const Color(0xFF526B31),
            progress: 0.92,
            progressColor: const Color(0xFF4B6515),
            description: 'Penuh pemburu jajanan legendaris seperti kue lumpur & roti bun lumpur 27.',
          ),
        ],
      ),
    );
  }

  Widget _buildCrowdItem({
    required String day,
    String? extraBadge,
    required String badgeText,
    required Color badgeBg,
    required Color badgeTextColor,
    required double progress,
    required Color progressColor,
    required String description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              day,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Color(0xFF594045),
              ),
            ),
            if (extraBadge != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E3A18),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  extraBadge,
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: badgeBg,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                badgeText,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: badgeTextColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: const Color(0xFFE5E7EB),
            color: progressColor,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          description,
          style: const TextStyle(
            fontSize: 9.5,
            color: Color(0xFF6B7280),
            height: 1.35,
          ),
        ),
      ],
    );
  }

  Widget _buildTransportationCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10594045),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFFE2F0C2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.near_me_rounded,
                  color: Color(0xFF526B31),
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Akses & Pilihan Transportasi',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF594045),
                      ),
                    ),
                    Text(
                      'Rute mudah menuju Pasar Oro-Oro Dowo',
                      style: TextStyle(fontSize: 9.5, color: Color(0xFF9CA3AF)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Map Preview
          Container(
            height: 115,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F2E6),
              border: Border.all(color: const Color(0xFFCBE3BE)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Stylized map roads
                Positioned(
                  left: -20,
                  right: -20,
                  top: 50,
                  child: Container(
                    height: 18,
                    color: const Color(0xFFFEF08A).withValues(alpha: 0.65),
                  ),
                ),
                Positioned(
                  left: 110,
                  top: -10,
                  bottom: -10,
                  child: Container(
                    width: 14,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                Positioned(
                  left: 230,
                  top: -10,
                  bottom: -10,
                  child: Container(
                    width: 10,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                // Center Map Marker
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
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
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.storefront_rounded,
                            size: 13,
                            color: Color(0xFF526B31),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Pasar Oro-Oro Dowo',
                            style: TextStyle(
                              color: Color(0xFF594045),
                              fontWeight: FontWeight.w800,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 3),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Color(0xFF526B31),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x22000000),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.location_on,
                        size: 13,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Transport Option 1
          _buildTransportOption(
            icon: Icons.directions_car_rounded,
            title: 'Kendaraan Pribadi',
            body: 'Akses nyaman dari arah Jl. Ijen melalui Jl. Guntur atau Jl. Muria. Lahan parkir mobil tersedia di sisi utara & selatan.',
          ),
          const SizedBox(height: 10),

          // Transport Option 2
          _buildTransportOption(
            icon: Icons.directions_bus_rounded,
            title: 'Angkutan Kota (Mikrolet)',
            body: 'Jalur angkot kode GL (Gadang – Landungsari), ASD, dan MM melintas di dekat perempatan Jl. Guntur.',
          ),
          const SizedBox(height: 10),

          // Transport Option 3
          _buildTransportOption(
            icon: Icons.local_taxi_rounded,
            title: 'Ojek & Taksi Online (Grab / Gojek)',
            body: 'Pilih titik penurunan/jemput di "Lobby Utama Timur Pasar Oro-Oro Dowo" agar mudah dijangkau pengemudi.',
          ),
          const SizedBox(height: 14),

          // Yellow Button: Buka di Google Maps
          Container(
            width: double.infinity,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFFFC928),
              borderRadius: BorderRadius.circular(999),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x35FFC928),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: () => _openMap(context),
              icon: const Icon(
                Icons.explore_outlined,
                size: 16,
                color: Colors.white,
              ),
              label: const Text(
                'Buka di Google Maps',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransportOption({
    required IconData icon,
    required String title,
    required String body,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(icon, size: 17, color: const Color(0xFF594045)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF594045),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                body,
                style: const TextStyle(
                  fontSize: 9.5,
                  color: Color(0xFF6B7280),
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBestTimesCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10594045),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFFE2F0C2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified_outlined,
                  color: Color(0xFF526B31),
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Waktu Terbaik Berkunjung',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF594045),
                      ),
                    ),
                    Text(
                      'Sesuaikan waktu dengan kebutuhan Anda',
                      style: TextStyle(fontSize: 9.5, color: Color(0xFF9CA3AF)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Item 1: Belanja Dapur Segar Petani
          _buildTimeRecommendationItem(
            time: '06.00 – 08.30 WIB',
            badgeText: 'Bahan Pokok Segar',
            badgeBg: const Color(0xFFE2F0C2),
            badgeTextColor: const Color(0xFF526B31),
            title: 'Belanja Dapur Segar Petani',
            body: 'Waktu terbaik mendapatkan sayuran hijau, rempah, daging segar baru potong, dan bumbu racik langsung dari petani/distributor Malang.',
            cardBg: const Color(0xFFF7FBF4),
            borderColor: const Color(0xFFE2F0C2),
          ),
          const SizedBox(height: 10),

          // Item 2: Jajanan Tradisional & Santai
          _buildTimeRecommendationItem(
            time: '08.30 – 11.00 WIB',
            badgeText: 'Wisata Kuliner',
            badgeBg: const Color(0xFFFEF3C7),
            badgeTextColor: const Color(0xFFD97706),
            title: 'Jajanan Tradisional & Santai',
            body: 'Nikmati jajanan legendaris seperti kue lumpur hangat, onde-onde, dan aneka kue basah sambil menikmati suasana santai.',
            cardBg: const Color(0xFFFFFDF5),
            borderColor: const Color(0xFFFEF3C7),
          ),
          const SizedBox(height: 10),

          // Item 3: Belanja Praktis & Tenang
          _buildTimeRecommendationItem(
            time: '14.00 – 16.00 WIB',
            badgeText: 'Lengang & Cepat',
            badgeBg: const Color(0xFFE2F0C2),
            badgeTextColor: const Color(0xFF526B31),
            title: 'Belanja Praktis & Tenang',
            body: 'Lorong pasar jauh lebih sepi. Cocok untuk Anda yang ingin belanja kilat tanpa antre di kasir atau lapak.',
            cardBg: const Color(0xFFF4F9ED),
            borderColor: const Color(0xFFE2F0C2),
          ),
          const SizedBox(height: 12),

          // Tips Ramah Lingkungan Card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9E6),
              border: Border.all(color: const Color(0xFFFDE68A)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFB8D66D),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tips Ramah Lingkungan',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF594045),
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Bawa kantong belanja kain (totebag) sendiri untuk mendukung program pasar bersih bebas sampah plastik!',
                        style: TextStyle(
                          fontSize: 9.5,
                          color: Color(0xFF594045),
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

  Widget _buildTimeRecommendationItem({
    required String time,
    required String badgeText,
    required Color badgeBg,
    required Color badgeTextColor,
    required String title,
    required String body,
    required Color cardBg,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  time,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF594045),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    fontSize: 8.5,
                    fontWeight: FontWeight.w700,
                    color: badgeTextColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
              color: Color(0xFF594045),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            body,
            style: const TextStyle(
              fontSize: 9.5,
              color: Color(0xFF6B7280),
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _marketBottomNavigation(BuildContext context) {
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

class PromoScreen extends StatefulWidget {
  const PromoScreen({super.key});

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
    final promos = marketPromos.where((promo) {
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
              child: CustomPaint(
                painter: _TrianglePatternPainter(),
              ),
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

  Widget _promoCard(PromoData promo) {
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

class VisitPlannerScreen extends StatefulWidget {
  const VisitPlannerScreen({super.key});

  @override
  State<VisitPlannerScreen> createState() => _VisitPlannerScreenState();
}

class _VisitPlannerScreenState extends State<VisitPlannerScreen> {
  String _duration = '1 Jam';
  String _taste = 'Pedas';
  double _budget = 100000;
  bool _generated = false;

  double get _boundedBudget => _budget.clamp(10000.0, 120000.0).toDouble();

  String _rupiah(double amount) =>
      'Rp${amount.round().toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')}';

  Widget _plannerHeader(BuildContext context) {
    return Container(
      height: 65,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: MarketColors.background,
        border: Border(
          bottom: BorderSide(color: MarketColors.green.withValues(alpha: .7)),
        ),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const MarketAsset('robot.png', width: 24, height: 24),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'AI Perencana Kunjungan',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: MarketColors.brown,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 1),
                const Text(
                  'Susun rute kuliner otomatis sesuai preferensimu',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: MarketColors.greenDark,
                    fontSize: 10.5,
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

  @override
  Widget build(BuildContext context) {
    return MarketPage(
      child: Column(
        children: [
          _plannerHeader(context),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(12, 28, 12, 18),
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(17),
                    border: Border.all(color: MarketColors.brown, width: 1),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x66594045),
                        blurRadius: 5,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _preferenceTitle('Waktu Tersedia'),
                      const SizedBox(height: 12),
                      _choiceRow(
                        ['30 Menit', '1 Jam', '2 Jam +'],
                        _duration,
                        (value) => setState(() => _duration = value),
                      ),
                      const SizedBox(height: 28),
                      _preferenceTitle('Preferensi Rasa'),
                      const SizedBox(height: 12),
                      _choiceRow(
                        ['Manis', 'Pedas', 'Asin'],
                        _taste,
                        (value) => setState(() => _taste = value),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: _selectPill(
                              'Gurih',
                              selected: _taste == 'Gurih',
                              onTap: () => setState(() => _taste = 'Gurih'),
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                          const Expanded(child: SizedBox()),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Budget: ${_rupiah(_boundedBudget)}',
                  style: const TextStyle(
                    color: MarketColors.greenDark,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 6,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 6,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 12,
                    ),
                  ),
                  child: SizedBox(
                    height: 34,
                    child: Slider(
                      value: _boundedBudget,
                      min: 10000,
                      max: 120000,
                      divisions: 22,
                      activeColor: MarketColors.greenDark,
                      inactiveColor: MarketColors.green,
                      onChanged: (value) => setState(() => _budget = value),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  height: 68,
                  child: ElevatedButton(
                    onPressed: () => setState(() => _generated = true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MarketColors.yellow,
                      foregroundColor: MarketColors.greenDark,
                      elevation: 5,
                      shadowColor: MarketColors.brown.withValues(alpha: .6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17),
                      ),
                    ),
                    child: const Text(
                      'Buat Rekomendasi',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  constraints: const BoxConstraints(minHeight: 360),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(17),
                    border: Border.all(color: MarketColors.brown, width: 1),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x66594045),
                        blurRadius: 5,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: MarketColors.yellow,
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x66594045),
                              blurRadius: 4,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.smart_toy_outlined,
                              size: 17,
                              color: MarketColors.greenDark,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'HASIL AI',
                              style: TextStyle(
                                color: MarketColors.greenDark,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                      Text(
                        _generated
                            ? 'Rute $_duration, $_taste & hemat'
                            : 'Rute singkat 1 jam, pedas & hemat',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          color: MarketColors.greenDark,
                        ),
                      ),
                      if (_generated) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF8E4),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: MarketColors.yellow),
                          ),
                          child: Text(
                            'Rekomendasi belum dapat dibuat karena data katalog rute belum tersedia.',
                            style: const TextStyle(
                              color: MarketColors.brown,
                              fontSize: 10,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 18),
                      const _PlannerStepMarker(number: '1'),
                      const SizedBox(height: 58),
                      const _PlannerStepMarker(number: '2'),
                      const SizedBox(height: 58),
                      const Divider(color: MarketColors.yellow, thickness: 1),
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

  Widget _preferenceTitle(String value) => Text(
    value,
    style: const TextStyle(
      color: MarketColors.greenDark,
      fontSize: 12,
      fontWeight: FontWeight.w800,
    ),
  );

  Widget _choiceRow(
    List<String> values,
    String selected,
    ValueChanged<String> onSelected,
  ) {
    return Row(
      children: [
        for (var index = 0; index < values.length; index++) ...[
          Expanded(
            child: _selectPill(
              values[index],
              selected: selected == values[index],
              onTap: () => onSelected(values[index]),
            ),
          ),
          if (index < values.length - 1) const SizedBox(width: 12),
        ],
      ],
    );
  }

  Widget _selectPill(
    String value, {
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? MarketColors.greenDark : Colors.white,
          border: Border.all(color: MarketColors.yellow, width: 1),
          borderRadius: BorderRadius.circular(999),
          boxShadow: selected
              ? const [
                  BoxShadow(
                    color: Color(0x66594045),
                    blurRadius: 3,
                    offset: Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Text(
          value,
          style: TextStyle(
            color: selected ? MarketColors.yellow : MarketColors.greenDark,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _PlannerStepMarker extends StatelessWidget {
  const _PlannerStepMarker({required this.number});

  final String number;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: MarketColors.yellow,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color(0x66594045),
            blurRadius: 4,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        number,
        style: const TextStyle(
          color: MarketColors.greenDark,
          fontSize: 14,
          fontWeight: FontWeight.w800,
        ),
      ),
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

/// Custom painter for the decorative triangle/chevron pattern in the top-right
/// corner of the AGENDA UTAMA PASAR featured card, matching the reference image.
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

    // Draw two nested chevron / triangle outlines pointing to bottom-right
    // First (outer) chevron
    final path1 = Path()
      ..moveTo(size.width * 0.55, 0)
      ..lineTo(size.width, size.height * 0.55)
      ..moveTo(size.width * 0.72, 0)
      ..lineTo(size.width, size.height * 0.72)
      ..moveTo(size.width * 0.88, 0)
      ..lineTo(size.width, size.height * 0.88)
      ..moveTo(size.width, 0)
      ..lineTo(size.width, 0);

    // Draw layered diagonal lines from top-right corner resembling the reference
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
