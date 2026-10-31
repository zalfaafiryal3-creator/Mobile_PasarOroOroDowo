import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../widgets/market_ui.dart';

class MarketHistoryScreen extends StatelessWidget {
  const MarketHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MarketPage(
      background: Colors.white,
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFBFDF6),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0x4DC2DC80), // rgba(194, 220, 128, 0.30)
              Color(0x33C2DC80), // rgba(194, 220, 128, 0.20)
              Color(0x1AC2DC80),
              Colors.white,
            ],
            stops: [0.0, 0.2, 0.5, 1.0],
          ),
          border: Border.symmetric(
            vertical: BorderSide(
              color: Color(0x33EA9CAF),
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Header with back button & title
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: _buildHeader(context),
              ),

              // Scrollable History Content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
                  children: [
                    // 1. Hero Card: Pasar Oro-Oro Dowo
                    _buildHeroSection(),
                    const SizedBox(height: 24),

                    // 2. Timeline Section: Jejak Sejarahnya
                    _buildTimelineSection(),
                    const SizedBox(height: 28),

                    // 3. Section: Keunikan Pasar Ini
                    _buildUniquenessSection(),
                    const SizedBox(height: 28),

                    // 4. CTA Section: Ajakan Mengunjungi Pasar
                    _buildCtaSection(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- HEADER ---
  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Back Button (Circle 54x54 with shadow)
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => goBack(context),
            borderRadius: BorderRadius.circular(27),
            child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x29594045), // rgba(89, 64, 69, 0.16)
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: SvgPicture.string(
                '''<svg width="25" height="25" viewBox="0 0 25 25" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M19.7917 12.5H5.20837M12.5 5.20833L5.20837 12.5L12.5 19.7917" stroke-width="2.60417" stroke-linecap="round" stroke-linejoin="round" stroke="#111827"/>
</svg>''',
                width: 24,
                height: 24,
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),

        // Title
        const Expanded(
          child: Text(
            'Sejarah Pasar Oro-Oro Dowo',
            style: TextStyle(
              fontFamily: 'Inter',
              color: Color(0xFF594045),
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }

  // --- HERO CARD ---
  Widget _buildHeroSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: const Color(0xFF594045),
          width: 1,
        ),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFC2DC80),
            Color(0x80FBBF24), // rgba(251, 191, 36, 0.50)
          ],
          stops: [0.29, 0.70],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33594045), // #594045 shadow per Figma
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Market Stall 3D Illustration
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: const Color(0xFFE9F1CE),
              borderRadius: BorderRadius.circular(22),
            ),
            alignment: Alignment.center,
            child: SvgPicture.string(
              '''<svg width="60" height="60" viewBox="0 0 64 64" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M9.59998 25.6H54.4L51.2 16H12.8L9.59998 25.6" fill="#FBBF24"/>
<path d="M16 16L14.08 25.6L16 16M25.6 16L24.32 25.6L25.6 16M35.2 16L34.56 25.6L35.2 16M44.8 16L45.44 25.6L44.8 16" fill="black" stroke-width="2.56" stroke="white"/>
<path d="M9.59998 26.8801C9.59998 28.6462 11.0338 30.0801 12.8 30.0801C14.5661 30.0801 16 28.6462 16 26.8801C16 25.1139 14.5661 23.6801 12.8 23.6801C11.0338 23.6801 9.59998 25.1139 9.59998 26.8801V26.8801" fill="#FBBF24"/>
<path d="M19.2 26.8801C19.2 28.6462 20.6338 30.0801 22.4 30.0801C24.1661 30.0801 25.6 28.6462 25.6 26.8801C25.6 25.1139 24.1661 23.6801 22.4 23.6801C20.6338 23.6801 19.2 25.1139 19.2 26.8801V26.8801" fill="white"/>
<path d="M28.8 26.8801C28.8 28.6462 30.2339 30.0801 32 30.0801C33.7662 30.0801 35.2 28.6462 35.2 26.8801C35.2 25.1139 33.7662 23.6801 32 23.6801C30.2339 23.6801 28.8 25.1139 28.8 26.8801V26.8801" fill="#FBBF24"/>
<path d="M38.4 26.8801C38.4 28.6462 39.8339 30.0801 41.6 30.0801C43.3662 30.0801 44.8 28.6462 44.8 26.8801C44.8 25.1139 43.3662 23.6801 41.6 23.6801C39.8339 23.6801 38.4 25.1139 38.4 26.8801V26.8801" fill="white"/>
<path d="M48 26.8801C48 28.6462 49.4339 30.0801 51.2 30.0801C52.9661 30.0801 54.4 28.6462 54.4 26.8801C54.4 25.1139 52.9661 23.6801 51.2 23.6801C49.4339 23.6801 48 25.1139 48 26.8801V26.8801" fill="#FBBF24"/>
<path d="M16.64 28.16H47.36C48.7729 28.16 49.92 29.3071 49.92 30.72V47.36C49.92 48.7729 48.7729 49.92 47.36 49.92H16.64C15.2271 49.92 14.08 48.7729 14.08 47.36V30.72C14.08 29.3071 15.2271 28.16 16.64 28.16V28.16" fill="#FBBF24" fill-opacity="0.3"/>
<path d="M21.12 33.28H42.88C43.9403 33.28 44.7999 34.1396 44.7999 35.2V44.16C44.7999 45.2204 43.9403 46.08 42.88 46.08H21.12C20.0596 46.08 19.2 45.2204 19.2 44.16V35.2C19.2 34.1396 20.0596 33.28 21.12 33.28V33.28" fill="white"/>
<path d="M32 6.40002C28.16 6.40002 24.96 9.60002 24.96 13.44C24.96 18.56 32 24.32 32 24.32C32 24.32 39.04 18.56 39.04 13.44C39.04 9.60002 35.84 6.40002 32 6.40002V6.40002" fill="#C2DC80"/>
<path d="M29.4399 12.8C29.4399 14.2129 30.587 15.36 31.9999 15.36C33.4128 15.36 34.5599 14.2129 34.5599 12.8C34.5599 11.3871 33.4128 10.24 31.9999 10.24C30.587 10.24 29.4399 11.3871 29.4399 12.8V12.8" fill="white"/>
</svg>''',
              width: 56,
              height: 56,
            ),
          ),
          const SizedBox(width: 14),

          // Divider bar + Text Info
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Vertical green divider (border-left: 3px solid #4B6515)
                Container(
                  width: 3,
                  height: 96,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4B6515),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 10),

                // Text Description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo Typography: "Pasar Oro-Oro Dowo" from brand logo asset
                      Image.asset(
                        'assets/pasar_title_transparent.png',
                        height: 26,
                        fit: BoxFit.contain,
                        alignment: Alignment.centerLeft,
                        errorBuilder: (context, error, stackTrace) {
                          return Text(
                            'Pasar Oro-Oro Dowo',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF4B6515),
                              shadows: [
                                Shadow(
                                  color: const Color(0xCCFBBF24),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Pasar tradisional di Kota Malang yang memiliki nilai sejarah dan menjadi bagian penting dari aktivitas ekonomi masyarakat sejak masa kolonial.',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF51494A),
                          height: 1.45,
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

  // --- TIMELINE SECTION: JEJAK SEJARAHNYA ---
  Widget _buildTimelineSection() {
    final timelineItems = [
      {
        'year': '1920-an',
        'title': 'Awal Keberadaan Pasar',
        'desc':
            'Pemerintah Kota Malang menyebut Pasar Oro-Oro Dowo telah ada sejak sekitar tahun 1920. Pasar ini tumbuh sebagai tempat masyarakat memenuhi kebutuhan sehari-hari.',
        'bgColor': const Color(0xEBFFFEF8), // rgba(255, 254, 248, 0.88)
      },
      {
        'year': '1932–\n1934',
        'title': 'Pembangunan Pasar',
        'desc':
            'Sejumlah sumber mencatat pembangunan pasar pada dekade 1930-an. DetikNews menyebut tahun 1932, sedangkan catatan sejarah Kelurahan Oro-Oro Dowo menyebut tahun 1934.',
        'bgColor': const Color(0x4DFBBF24), // rgba(251, 191, 36, 0.30)
      },
      {
        'year': '1970',
        'title': 'Renovasi dan Penambahan Bangunan',
        'desc':
            'Pasar mengalami renovasi dan penambahan bangunan untuk menunjang kegiatan perdagangan. Bangunan utama yang memiliki karakter lama tetap dipertahankan.',
        'bgColor': const Color(0xEBFFFEF8), // rgba(255, 254, 248, 0.88)
      },
      {
        'year': '2015',
        'title': 'Revitalisasi Pasar',
        'desc':
            'Pasar direvitalisasi untuk meningkatkan kebersihan, penataan, dan kenyamanan. Upaya pembaruan dilakukan dengan tetap mempertahankan bagian bangunan lama yang menjadi ciri khas pasar.',
        'bgColor': const Color(0x4DFBBF24), // rgba(251, 191, 36, 0.30)
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Pill Heading: Jejak Sejarahnya
        _buildPillHeading('Jejak Sejarahnya'),
        const SizedBox(height: 16),

        // Timeline layout
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Stack(
            children: [
              // Continuous Vertical Divider Line
              Positioned(
                left: 11,
                top: 24,
                bottom: 24,
                child: Container(
                  width: 2,
                  color: const Color(0xFF9BB65B),
                ),
              ),

              // Timeline Item List
              Column(
                children: List.generate(timelineItems.length, (index) {
                  final item = timelineItems[index];
                  final isLast = index == timelineItems.length - 1;
                  final bgColor = item['bgColor'] as Color;

                  return Padding(
                    padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Timeline Dot
                        Container(
                          width: 24,
                          height: 24,
                          margin: const EdgeInsets.only(top: 18),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4B6515),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFEDF3D9),
                              width: 3.5,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0xFFD8E6A8),
                                spreadRadius: 1.5,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Article Card (border: 1px solid #594045 per Figma)
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: const Color(0xFF594045),
                                width: 1,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x2E594045), // #594045 shadow per Figma
                                  blurRadius: 9,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Year Badge + Title Row
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Year Badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF4B6515),
                                        borderRadius: BorderRadius.circular(17),
                                      ),
                                      child: Text(
                                        item['year'] as String,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                          height: 1.15,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),

                                    // Title
                                    Expanded(
                                      child: Text(
                                        item['title'] as String,
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF594045),
                                          height: 1.25,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),

                                // Description
                                Text(
                                  item['desc'] as String,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF51494A),
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- SECTION: KEUNIKAN PASAR INI ---
  Widget _buildUniquenessSection() {
    final highlights = [
      {
        'title': 'Jejak bangunan lama',
        'desc': 'Bagian depan pasar masih memperlihatkan karakter arsitektur peninggalan masa kolonial.',
      },
      {
        'title': 'Aktivitas perdagangan',
        'desc': 'Menjadi tempat bertemunya pedagang dan masyarakat untuk memenuhi kebutuhan sehari-hari.',
      },
      {
        'title': 'Identitas kawasan',
        'desc': 'Keberadaannya ikut menjadi bagian dari kehidupan dan sejarah lingkungan Oro-Oro Dowo.',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Pill Heading (border: 1px solid #4B6515 per Figma)
        _buildPillHeading('Keunikan Pasar Ini', isExtraBold: true),
        const SizedBox(height: 14),

        // Uniqueness Card (border: 1px solid #594045 per Figma)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFEF8),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: const Color(0xFF594045),
              width: 1,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33594045), // #594045 shadow per Figma
                blurRadius: 14,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Intro paragraph
              const Text(
                'Pasar Oro-Oro Dowo bukan hanya tempat jual beli, tetapi juga bagian dari perjalanan kawasan Kota Malang.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.5,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF51494A),
                  height: 1.55,
                ),
              ),
              const SizedBox(height: 16),

              // Checklist items
              ...highlights.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Check icon circle
                      Container(
                        width: 25,
                        height: 25,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE9F1CE),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          '✓',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: Color(0xFF4B6515),
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Text Title & Description
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${item['title']}\n',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF51494A),
                                  height: 1.35,
                                ),
                              ),
                              TextSpan(
                                text: item['desc'],
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF51494A),
                                  height: 1.45,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  // --- CTA BANNER ---
  Widget _buildCtaSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(27),
        border: const Border(
          bottom: BorderSide(
            color: Color(0xFFFBBF24),
            width: 7,
          ),
        ),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFD9E9A4),
            Color(0xFFF3EDB7),
          ],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33594045), // #594045 shadow per Figma
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Yuk, kunjungi Pasar\nOro-Oro Dowo!',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF594045),
              height: 1.25,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Rasakan suasana pasar tradisional dan kenali salah satu bagian dari sejarah Kota Malang.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.5,
              fontWeight: FontWeight.w400,
              color: Color(0xFF594B43),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // --- PILL HEADING WIDGET ---
  Widget _buildPillHeading(String title, {bool isExtraBold = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFC2DC80),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: const Color(0xFF4B6515), // border: 1px solid #4B6515 per Figma
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A49532B),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: isExtraBold ? FontWeight.w800 : FontWeight.w700,
          color: const Color(0xFF594045),
        ),
      ),
    );
  }
}
