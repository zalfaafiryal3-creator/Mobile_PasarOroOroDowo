import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/market_data.dart';
import '../widgets/market_ui.dart';

class MarketMapScreen extends StatelessWidget {
  const MarketMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MarketPage(
      child: Column(
        children: [
          PageTitleBar(
            title: 'Denah Pasar Oro-Oro Dowo',
            subtitle: 'Lihat tata letak pasar',
            onBack: () => goBack(context),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(8),
                  child: InteractiveViewer(
                    minScale: .7,
                    maxScale: 4,
                    child: const MarketAsset(
                      'denah.jpg',
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
      child: Column(
        children: [
          PageTitleBar(
            title: 'Info Kunjungan',
            subtitle: 'Pasar Oro-Oro Dowo, Malang',
            asset: '23853.svg',
            onBack: () => goBack(context),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              children: [
                _visitHeaderCard(),
                const SizedBox(height: 14),
                _visitSection(
                  icon: Icons.access_time,
                  title: 'Jam Operasional',
                  subtitle: 'Jadwal transaksi harian pasar',
                  status: 'Tutup 17.00 WIB',
                  child: const Column(
                    children: [
                      _ScheduleRow('Senin - Jumat', '06.00 - 17.00 WIB'),
                      SizedBox(height: 8),
                      _ScheduleRow('Sabtu - Minggu', '06.00 - 17.00 WIB'),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                _visitSection(
                  icon: Icons.people_alt_outlined,
                  title: 'Hari Pasaran & Kepadatan',
                  subtitle: 'Estimasi kepadatan pengunjung pasar',
                  status: 'Live Tren',
                  child: const Column(
                    children: [
                      _CrowdRow('Senin - Kamis', 'Rendah - Nyaman', .38),
                      SizedBox(height: 9),
                      _CrowdRow('Jumat', 'Sedang', .58),
                      SizedBox(height: 9),
                      _CrowdRow('Sabtu - Minggu', 'Ramai', .83),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                _visitSection(
                  icon: Icons.directions_bus_outlined,
                  title: 'Akses & Pilihan Transportasi',
                  subtitle: 'Rute mudah menuju Pasar Oro-Oro Dowo',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 128,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF3F2),
                          border: Border.all(color: MarketColors.green),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              left: -12,
                              right: -12,
                              child: Transform.rotate(
                                angle: -.08,
                                child: Container(
                                  height: 12,
                                  color: const Color(0x55FBBF24),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 93,
                              top: 0,
                              bottom: 0,
                              child: Transform.rotate(
                                angle: .18,
                                child: Container(
                                  width: 8,
                                  color: const Color(0x55D1D5DB),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: MarketColors.green),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: MarketColors.pink,
                                    size: 16,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Pasar Oro-Oro Dowo',
                                    style: TextStyle(
                                      color: MarketColors.brown,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      const _TransportText(
                        'Angkutan Umum',
                        'Akses angkutan kota tersedia di sekitar area pasar.',
                      ),
                      const SizedBox(height: 9),
                      const _TransportText(
                        'Ojek & Taksi Online (Grab / Gojek)',
                        'Pilih titik penurunan/jemput di "Lobby Utama Timur Pasar Oro-Oro Dowo" agar mudah dijangkau pengemudi.',
                      ),
                      const SizedBox(height: 12),
                      PrimaryMarketButton(
                        label: 'Buka Petunjuk Arah',
                        icon: Icons.near_me,
                        onPressed: () => _openMap(context),
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

  Widget _visitHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFDDE9B8), Color(0xFFF9DDE6)],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: const Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pasar Oro-Oro Dowo',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: MarketColors.brown,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Pasar bersejarah yang direvitalisasi sejak Tahun 1932. Rencanakan kunjungan nyaman ke pasar.',
                  style: TextStyle(fontSize: 10, height: 1.5),
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          Icon(Icons.storefront, size: 42, color: MarketColors.pink),
        ],
      ),
    );
  }

  Widget _visitSection({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget child,
    String? status,
  }) {
    return RoundedCard(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0x77C2DC80),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, color: MarketColors.greenDark, size: 17),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: MarketColors.ink,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ),
              if (status != null)
                _pill(
                  status,
                  color: MarketColors.greenDark,
                  background: const Color(0x66C2DC80),
                ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _ScheduleRow extends StatelessWidget {
  const _ScheduleRow(this.day, this.hours);

  final String day;
  final String hours;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF6F3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 8, color: MarketColors.yellow),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              day,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            hours,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: MarketColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

class _CrowdRow extends StatelessWidget {
  const _CrowdRow(this.day, this.label, this.progress);

  final String day;
  final String label;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF6F3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  day,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _pill(
                label,
                color: MarketColors.greenDark,
                background: const Color(0x77C2DC80),
              ),
            ],
          ),
          const SizedBox(height: 7),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: const Color(0xFFE5E7EB),
              color: MarketColors.brown,
            ),
          ),
        ],
      ),
    );
  }
}

class _TransportText extends StatelessWidget {
  const _TransportText(this.title, this.body);

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            color: MarketColors.ink,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          body,
          style: const TextStyle(
            fontSize: 10,
            height: 1.45,
            color: MarketColors.muted,
          ),
        ),
      ],
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
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                color: MarketColors.background,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(9, 4, 8, 12),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFBBF24), Color(0xFFC2DC80)],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                              ),
                              borderRadius: BorderRadius.circular(17),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x334B6515),
                                  offset: Offset(0, 4),
                                  blurRadius: 7,
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
                    ),
                    const SizedBox(height: 6),
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
            left: 15,
            right: 15,
            bottom: 12,
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
      height: 71,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .95),
        border: Border.all(color: const Color(0xA6C2DC80)),
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A4B6515),
            blurRadius: 25,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items.map((item) {
          final active = item.$1 == 'Promo';
          return InkWell(
            onTap: () => goTo(context, item.$2),
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 48,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: active
                          ? const Color(0xFFE2F0C2)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: MarketAsset(
                      item.$3,
                      width: 20,
                      height: 23,
                      color: active
                          ? const Color(0xFF4F6818)
                          : const Color(0xFF9CA3AF),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.$1,
                    maxLines: 1,
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                      color: active
                          ? const Color(0xFF4F6818)
                          : const Color(0xFF9CA3AF),
                      fontSize: item.$1 == 'Review Pasar' ? 9 : 9.5,
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

  Widget _featuredFestival() {
    return Container(
      constraints: const BoxConstraints(minHeight: 160),
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.fromLTRB(14, 15, 14, 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFC2DC80), Color(0xFFD1DF9A), Color(0xFFFBBF24)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0, .55, 1],
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
        children: [
          Positioned(
            top: 8,
            right: 18,
            child: Transform.rotate(
              angle: .21,
              child: Icon(
                Icons.auto_awesome,
                size: 44,
                color: Colors.white.withValues(alpha: .35),
              ),
            ),
          ),
          Positioned(
            right: -25,
            bottom: -50,
            child: Container(
              width: 138,
              height: 138,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: .24)),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .7),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: const Text(
                  'AGENDA UTAMA PASAR',
                  style: TextStyle(
                    color: Color(0xFF607345),
                    fontSize: 7,
                    height: 10 / 7,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 7),
              const Text(
                'Festival Belanja Pasar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  height: 23 / 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              const SizedBox(
                width: 255,
                child: Text(
                  'Penawaran serentak pedagang Pasar Oro-Oro Dowo untuk produk segar, bumbu tradisi, dan jajanan tempo doeloe.',
                  style: TextStyle(
                    color: Color(0xF5FFFFFF),
                    fontSize: 9,
                    height: 13 / 9,
                  ),
                ),
              ),
              const SizedBox(height: 7),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .9),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.calendar_month_outlined,
                          size: 12,
                          color: MarketColors.yellow,
                        ),
                        SizedBox(width: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PERIODE BERLAKU',
                              style: TextStyle(
                                color: MarketColors.muted,
                                fontSize: 6,
                                height: 7 / 6,
                              ),
                            ),
                            Text(
                              '15 Okt – 31 Okt 2026',
                              style: TextStyle(
                                color: Color(0xFF39412F),
                                fontSize: 8,
                                height: 10 / 8,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 7),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .9),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: const Text(
                      '16 Hari',
                      style: TextStyle(
                        color: Color(0xFF51683B),
                        fontSize: 8,
                        height: 10 / 8,
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

class RecommendationsScreen extends StatefulWidget {
  const RecommendationsScreen({super.key});

  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
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
          border: Border.all(color: const Color(0x22D56989)),
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

  String _rupiah(double amount) =>
      'Rp${amount.round().toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')}';

  @override
  Widget build(BuildContext context) {
    return MarketPage(
      child: Column(
        children: [
          PageTitleBar(
            title: 'AI Perencana Kunjungan',
            subtitle: 'Susun rute kuliner otomatis sesuai preferensimu',
            asset: 'robot.png',
            onBack: () => goBack(context),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
              children: [
                RoundedCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _preferenceTitle('Waktu Tersedia'),
                      const SizedBox(height: 7),
                      Wrap(
                        spacing: 7,
                        children: ['30 Menit', '1 Jam', '2 Jam +']
                            .map(
                              (value) => _selectPill(
                                value,
                                selected: _duration == value,
                                onTap: () => setState(() => _duration = value),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 14),
                      _preferenceTitle('Preferensi Rasa'),
                      const SizedBox(height: 7),
                      Wrap(
                        spacing: 7,
                        children: ['Manis', 'Pedas', 'Asin', 'Gurih']
                            .map(
                              (value) => _selectPill(
                                value,
                                selected: _taste == value,
                                onTap: () => setState(() => _taste = value),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Budget',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Text(
                            _rupiah(_budget),
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: MarketColors.pink,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: _budget,
                        min: 10000,
                        max: 200000,
                        divisions: 38,
                        activeColor: MarketColors.pink,
                        inactiveColor: const Color(0x55C2DC80),
                        onChanged: (value) => setState(() => _budget = value),
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Rp10.000',
                            style: TextStyle(
                              fontSize: 9,
                              color: MarketColors.muted,
                            ),
                          ),
                          Text(
                            'Rp200.000',
                            style: TextStyle(
                              fontSize: 9,
                              color: MarketColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                PrimaryMarketButton(
                  label: 'Buat Rekomendasi',
                  icon: Icons.auto_awesome,
                  onPressed: () => setState(() => _generated = true),
                ),
                const SizedBox(height: 12),
                RoundedCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const MarketAsset('robot.png', width: 28, height: 28),
                          const SizedBox(width: 7),
                          _pill(
                            'HASIL AI',
                            color: MarketColors.greenDark,
                            background: const Color(0x55C2DC80),
                          ),
                        ],
                      ),
                      const SizedBox(height: 11),
                      Text(
                        _generated
                            ? 'Rute $_duration, $_taste & hemat'
                            : 'Rute singkat 1 jam, pedas & hemat',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: MarketColors.brown,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _generated
                            ? 'Belum ada produk ${_taste.toLowerCase()} yang sesuai budget ${_rupiah(_budget)}.'
                            : 'Memuat rekomendasi kuliner pasar…',
                        style: const TextStyle(
                          fontSize: 10,
                          color: MarketColors.muted,
                          height: 1.45,
                        ),
                      ),
                      if (_generated) ...[
                        const SizedBox(height: 10),
                        const ErrorNotice(
                          'Data katalog untuk rute AI tidak tersedia. Sumber React mengambilnya dari backend yang tidak ada dalam folder project yang diberikan.',
                        ),
                      ],
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
    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
  );

  Widget _selectPill(
    String value, {
    required bool selected,
    required VoidCallback onTap,
  }) {
    return ChoiceChip(
      label: Text(value),
      selected: selected,
      onSelected: (_) => onTap(),
      labelStyle: TextStyle(
        fontSize: 10,
        color: selected ? Colors.white : MarketColors.brown,
      ),
      selectedColor: MarketColors.pink,
      backgroundColor: const Color(0xFFF8F5F3),
      visualDensity: VisualDensity.compact,
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
