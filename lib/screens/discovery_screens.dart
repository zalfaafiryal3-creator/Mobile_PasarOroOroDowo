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
      background: Colors.white,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0x40C2DC80), // rgba(194, 220, 128, 0.25)
              Color(0x20C2DC80),
              Colors.white,
            ],
            stops: [0.0, 0.25, 0.8],
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
                      const SizedBox(height: 16),

                      // 2. Card 2: Jam Operasional
                      _buildOperatingHoursCard(),
                      const SizedBox(height: 16),

                      // 3. Card 3: Hari Pasaran & Kepadatan
                      _buildCrowdCard(),
                      const SizedBox(height: 16),

                      // 4. Card 4: Akses & Pilihan Transportasi
                      _buildTransportationCard(context),
                      const SizedBox(height: 16),

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
      ),
    );
  }

  Widget _buildTopHeader(BuildContext context) {
    return Row(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => goBack(context),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF594045), width: 1),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x28594045),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.arrow_back,
                size: 20,
                color: Color(0xFF111C2D),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Info Kunjungan',
              style: TextStyle(
                fontFamily: 'Inter',
                color: Color(0xFF594045),
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
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
                    fontFamily: 'Inter',
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
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF594045),
          width: 1,
        ),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFBBF24),
            Color(0xFFC2DC80),
            Color(0xFFFBBF24),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x28594045),
            blurRadius: 20,
            spreadRadius: -2,
            offset: Offset(0, 4),
          ),
          BoxShadow(
            color: Color(0x18594045),
            blurRadius: 6,
            spreadRadius: -1,
            offset: Offset(0, 2),
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF594045),
                    width: 1,
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.stars_rounded, size: 14, color: Color(0xFF4B6515)),
                    SizedBox(width: 4),
                    Text(
                      'Cagar Budaya SNI',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Color(0xFF4B6515),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF594045),
                    width: 1,
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified, size: 13, color: Color(0xFF3B82F6)),
                    SizedBox(width: 4),
                    Text(
                      'Pasar Resmi',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Color(0xFF1E3A8A),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Title
          const Text(
            'Pasar Tradisional & Wisata Cagar Budaya',
            style: TextStyle(
              fontFamily: 'Inter',
              color: Color(0xFF1E293B),
              fontSize: 18,
              fontWeight: FontWeight.w800,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Jl. Cirebon No.1, Klojen, Kota Malang • Cagar Budaya Sejak 1932',
            style: TextStyle(
              fontFamily: 'Inter',
              color: Color(0xFF475569),
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 14),

          // Quick metrics row
          Row(
            children: [
              _buildHeroStatPill(Icons.access_time_filled, '06.00 - 17.00'),
              const SizedBox(width: 8),
              _buildHeroStatPill(Icons.storefront, '± 251 Kios'),
              const SizedBox(width: 8),
              _buildHeroStatPill(Icons.history_edu, 'Tahun 1932'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroStatPill(IconData icon, String text) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.92),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF594045),
            width: 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x10594045),
              blurRadius: 4,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 14, color: const Color(0xFF4B6515)),
            const SizedBox(height: 3),
            Text(
              text,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Inter',
                color: Color(0xFF1F2937),
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOperatingHoursCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF594045),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x28594045),
            blurRadius: 20,
            spreadRadius: -2,
            offset: Offset(0, 4),
          ),
          BoxShadow(
            color: Color(0x18594045),
            blurRadius: 6,
            spreadRadius: -1,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with status pill
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.schedule_rounded, size: 20, color: Color(0xFF4B6515)),
                  SizedBox(width: 8),
                  Text(
                    'Jam Operasional',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Color(0xFF1E293B),
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF594045),
                    width: 1,
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(radius: 3.5, backgroundColor: Color(0xFF2E7D32)),
                    SizedBox(width: 5),
                    Text(
                      'Buka Hari Ini',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Color(0xFF2E7D32),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Weekday item
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF594045),
                width: 1,
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Senin - Jumat (Hari Kerja)',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Color(0xFF1E293B),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Aktivitas pasar tradisional harian',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Color(0xFF64748B),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                Text(
                  '06.00 - 17.00 WIB',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: Color(0xFF1E293B),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Weekend item (highlighted)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0x59FBBF24), // rgba(251, 191, 36, 0.35)
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF594045),
                width: 1,
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sabtu - Minggu (Akhir Pekan)',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Color(0xFF594045),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Buka lebih lama untuk wisata kuliner',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Color(0xFF594045),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Text(
                  '05.00 - 17.00 WIB',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: Color(0xFF594045),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Evening note
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline, size: 15, color: Color(0xFF64748B)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Sebagian gerai kuliner dan jajanan pasar di area teras depan buka hingga malam hari.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: Colors.grey.shade700,
                    fontSize: 11,
                    height: 1.35,
                  ),
                ),
              ),
            ],
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
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF594045),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x28594045),
            blurRadius: 20,
            spreadRadius: -2,
            offset: Offset(0, 4),
          ),
          BoxShadow(
            color: Color(0x18594045),
            blurRadius: 6,
            spreadRadius: -1,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.people_alt_rounded, size: 20, color: Color(0xFF4B6515)),
              SizedBox(width: 8),
              Text(
                'Hari Pasaran & Kepadatan',
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: Color(0xFF1E293B),
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          _buildCrowdRow(
            title: 'Senin - Kamis',
            status: 'Rendah - Nyaman',
            statusColor: const Color(0xFF16A34A),
            statusBg: const Color(0xFFDCFCE7),
            description:
                'Sangat kondusif belanja sayuran segar harian, rempah-rempah, dan daging tanpa antrean.',
          ),
          const SizedBox(height: 10),

          _buildCrowdRow(
            title: 'Jumat',
            status: 'Sedang',
            statusColor: const Color(0xFFCA8A04),
            statusBg: const Color(0xFFFEF9C3),
            description:
                'Ramai di pagi hari (06.30 - 09.30 WIB) menjelang persiapan ibadah salat Jumat.',
          ),
          const SizedBox(height: 10),

          // Weekend row with soft background
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0x99FFF1F2), // rgba(255, 241, 242, 0.60)
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF594045),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Sabtu & Minggu',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Color(0xFF1E293B),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF594045),
                          width: 1,
                        ),
                      ),
                      child: const Text(
                        'Ramai Wisatawan',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: Color(0xFFDC2626),
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Penuh pemburu jajanan legendaris seperti Serabi Solo & Kue Lumpur 27. Disarankan datang lebih pagi!',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: Color(0xFF64748B),
                    fontSize: 11,
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

  Widget _buildCrowdRow({
    required String title,
    required String status,
    required Color statusColor,
    required Color statusBg,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF594045),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  color: Color(0xFF1E293B),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF594045),
                    width: 1,
                  ),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: statusColor,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              fontFamily: 'Inter',
              color: Color(0xFF64748B),
              fontSize: 11,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransportationCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF594045),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x28594045),
            blurRadius: 20,
            spreadRadius: -2,
            offset: Offset(0, 4),
          ),
          BoxShadow(
            color: Color(0x18594045),
            blurRadius: 6,
            spreadRadius: -1,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.directions_bus_rounded, size: 20, color: Color(0xFF4B6515)),
              SizedBox(width: 8),
              Text(
                'Akses & Pilihan Transportasi',
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: Color(0xFF1E293B),
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Map preview box
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF594045),
                width: 1,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    'assets/images/pasar_depan.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFFCBD5E1),
                        child: const Center(
                          child: Icon(Icons.map, size: 36, color: Color(0xFF64748B)),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF594045),
                      width: 1,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x33594045),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.location_on, size: 14, color: Color(0xFFDC2626)),
                      SizedBox(width: 4),
                      Text(
                        'Pasar Oro-Oro Dowo',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: Color(0xFF1E293B),
                          fontSize: 11.5,
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

          _buildTransportItem(
            icon: Icons.two_wheeler_rounded,
            title: 'Kendaraan Pribadi',
            desc:
                'Tersedia area parkir resmi motor di depan pasar dan mobil di sepanjang sisi jalan Cirebon.',
          ),
          const SizedBox(height: 10),

          _buildTransportItem(
            icon: Icons.directions_bus_filled_rounded,
            title: 'Angkutan Kota (Mikrolet)',
            desc:
                'Rute Mikrolet AG (Arjosari - Gadang) atau GL melintas dekat kawasan Klojen/Guntur.',
          ),
          const SizedBox(height: 10),

          _buildTransportItem(
            icon: Icons.local_taxi_rounded,
            title: 'Ojek Online / Taksi',
            desc:
                'Pilih titik penjemputan/penurunan tepat di "Pintu Utama Pasar Oro-Oro Dowo".',
          ),
          const SizedBox(height: 14),

          // Google Maps CTA Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _openMap(context),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBBF24),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF594045),
                    width: 1,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33594045),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.directions, size: 18, color: Color(0xFF1E293B)),
                    SizedBox(width: 8),
                    Text(
                      'Buka di Google Maps',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Color(0xFF1E293B),
                        fontSize: 13,
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xFF594045),
              width: 1,
            ),
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 18, color: const Color(0xFF4B6515)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  color: Color(0xFF1E293B),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  color: Color(0xFF64748B),
                  fontSize: 11,
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
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF594045),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x28594045),
            blurRadius: 20,
            spreadRadius: -2,
            offset: Offset(0, 4),
          ),
          BoxShadow(
            color: Color(0x18594045),
            blurRadius: 6,
            spreadRadius: -1,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.recommend_rounded, size: 20, color: Color(0xFF4B6515)),
              SizedBox(width: 8),
              Text(
                'Waktu Terbaik Berkunjung',
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: Color(0xFF1E293B),
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Slot 1: Belanja Dapur Segar Petani
          _buildTimeSlotItem(
            timeRange: '06.00 - 08.30 WIB',
            title: 'Belanja Dapur Segar Petani',
            description:
                'Waktu terbaik mendapatkan sayuran hijau renyah, daging segar baru potong, dan bumbu dapur langsung dari petani Batu/Malang.',
            accentColor: const Color(0xFF4B6515),
            gradientColors: const [Color(0xFFFAF5F8), Colors.white],
          ),
          const SizedBox(height: 10),

          // Slot 2: Jajanan Tradisional & Santai
          _buildTimeSlotItem(
            timeRange: '08.30 - 11.00 WIB',
            title: 'Jajanan Tradisional & Santai',
            description:
                'Nikmati jajanan legendaris seperti kue lumpur hangat, onde-onde, dan serabi kuah kental sambil menikmati kopi santai.',
            accentColor: const Color(0xFFFBBF24),
            gradientColors: const [Color(0x80FFFBEB), Colors.white],
          ),
          const SizedBox(height: 10),

          // Slot 3: Belanja Praktis & Tenang
          _buildTimeSlotItem(
            timeRange: '14.00 - 16.00 WIB',
            title: 'Belanja Praktis & Tenang',
            description:
                'Lorong pasar jauh lebih sepi. Cocok untuk Anda yang ingin belanja kilat tanpa antre di kasir atau lapak.',
            accentColor: const Color(0xFFC2DC80),
            gradientColors: const [Color(0x80C2DC80), Color(0x33C2DC80)],
          ),
          const SizedBox(height: 14),

          // Local Tip Card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0x59FBBF24), // rgba(251, 191, 36, 0.35)
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF594045),
                width: 1,
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.eco_rounded, size: 22, color: Color(0xFF4B6515)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Tips Ramah Lingkungan: Bawa kantong belanja kain (totebag) sendiri untuk mendukung program pasar bersih bebas sampah plastik!',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Color(0xFF594045),
                      fontSize: 11,
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

  Widget _buildTimeSlotItem({
    required String timeRange,
    required String title,
    required String description,
    required Color accentColor,
    required List<Color> gradientColors,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border(
          top: BorderSide(color: accentColor, width: 1),
          right: BorderSide(color: accentColor, width: 1),
          bottom: BorderSide(color: accentColor, width: 1),
          left: BorderSide(color: accentColor, width: 4),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.18),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF594045),
                width: 1,
              ),
            ),
            child: Text(
              timeRange,
              style: TextStyle(
                fontFamily: 'Inter',
                color: accentColor == const Color(0xFFFBBF24)
                    ? const Color(0xFF854D0E)
                    : const Color(0xFF1E293B),
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Inter',
              color: Color(0xFF1E293B),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            description,
            style: const TextStyle(
              fontFamily: 'Inter',
              color: Color(0xFF64748B),
              fontSize: 11,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _marketBottomNavigation(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: const Color(0xFF594045),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x28594045),
            blurRadius: 18,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _bottomNavItem(
            icon: Icons.home_filled,
            label: 'Home',
            isActive: false,
            onTap: () => goTo(context, '/home'),
          ),
          _bottomNavItem(
            icon: Icons.storefront_rounded,
            label: 'Toko',
            isActive: false,
            onTap: () => goTo(context, '/toko'),
          ),
          _bottomNavItem(
            icon: Icons.local_fire_department_rounded,
            label: 'Promo',
            isActive: false,
            onTap: () => goTo(context, '/promo'),
          ),
          _bottomNavItem(
            icon: Icons.rate_review_rounded,
            label: 'Review',
            isActive: false,
            onTap: () => goTo(context, '/ulasan'),
          ),
        ],
      ),
    );
  }

  Widget _bottomNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: isActive ? const Color(0xFF4B6515) : const Color(0xFF94A3B8),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive ? const Color(0xFF4B6515) : const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ),
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
