import 'dart:async';

import 'package:flutter/material.dart';

import '../widgets/market_ui.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1800), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/landing-page');
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MarketPage(
      background: MarketColors.background,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: const MarketAsset(
            'logo oro hijau.png',
            width: 228,
            height: 228,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MarketPage(
      background: const Color(0xFFF0F6DF),
      child: LayoutBuilder(
        builder: (context, constraints) => Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          SizedBox(
                            width: 200,
                            height: 110,
                            child: Image.asset(
                              'assets/logo oro hijau.png',
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Semua yang kamu butuhkan,\nada di sini!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: MarketColors.brown,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SELAMAT DATANG!',
                            style: TextStyle(
                              color: MarketColors.greenDark,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              letterSpacing: .2,
                            ),
                          ),
                          SizedBox(height: 6),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: MarketColors.yellow,
                              borderRadius: BorderRadius.all(
                                Radius.circular(99),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x66FBBF24),
                                  blurRadius: 2,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: SizedBox(width: 52, height: 4),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'Sejarah Singkat',
                        style: TextStyle(
                          color: MarketColors.brown,
                          fontSize: 23,
                          height: 1.2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 9),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'Pasar Oro-Oro Dowo adalah pasar tradisional bersejarah di Kota Malang yang dibangun pada masa kolonial Belanda tahun 1932. Kini, pasar ini telah direvitalisasi dan menjadi pasar yang bersih, modern, namun tetap mempertahankan sekitar 20 kios lama bergaya arsitektur kolonial.',
                        style: TextStyle(
                          color: MarketColors.greenDark,
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(22, 18, 18, 17),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6DB80),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x99594045),
                            blurRadius: 4,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _MarketInformationRow(
                            icon: Icons.location_on,
                            title: 'Lokasi',
                            description: 'Jl. Guntur No. 20,\nKel. Oro-oro Dowo, Kec. Klojen,\nKota Malang, Jawa Timur',
                          ),
                          SizedBox(height: 7),
                          _MarketInformationRow(
                            icon: Icons.access_time_filled,
                            title: 'Jam Operasional',
                            description: '06.00 – 17.00 WIB',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: const MarketAsset(
                        '204f2.png',
                        width: double.infinity,
                        height: 132,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                24,
                8,
                24,
                constraints.maxHeight < 780 ? 12 : 28,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => goTo(context, '/home'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MarketColors.yellow,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Selanjutnya',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward, size: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MarketInformationRow extends StatelessWidget {
  const _MarketInformationRow({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 18,
          height: 18,
          child: Icon(icon, size: 16, color: MarketColors.greenDark),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  color: MarketColors.greenDark,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 10,
                  height: 1.8,
                  color: MarketColors.brown,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
