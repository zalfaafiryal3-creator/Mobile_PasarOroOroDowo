import 'dart:async';

import 'package:flutter/material.dart';

import '../widgets/market_ui.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LandingPage(startFromLanding1: true);
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key, this.startFromLanding1 = false});

  final bool startFromLanding1;

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  Timer? _autoStartTimer;
  bool _hasStarted = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );

    if (widget.startFromLanding1) {
      _autoStartTimer = Timer(const Duration(milliseconds: 950), () {
        if (mounted) {
          _startAnimation();
        }
      });
    } else {
      _hasStarted = true;
      _controller.value = 1.0;
    }
  }

  void _startAnimation() {
    if (_hasStarted) return;
    _hasStarted = true;
    _autoStartTimer?.cancel();
    if (mounted) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _autoStartTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MarketPage(
      background: const Color(0xFFF0F6DF),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (!_hasStarted) {
            _startAnimation();
          }
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableHeight = constraints.maxHeight;
            // Native center of logo from top of SingleChildScrollView
            // (top padding 12 + logo height 110 / 2)
            const double logoCenterY = 67.0;
            final double deltaY = (availableHeight / 2) - logoCenterY;

            return AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                final t = _animation.value;
                final bool isCompleted = t >= 1.0;

                // Scale smoothly from 1.25 down to 1.0 for logo from Landing 1
                final double currentScale = 1.0 + (0.25 * (1.0 - t));

                // Translate logo from center of screen down to top of landing page
                final double currentLogoY = deltaY * (1.0 - t);

                // Translate content below so it flows naturally under the header
                final double currentContentY = deltaY * (1.0 - t);

                // Smooth fade-in for Landing Page 2 content
                final double contentProgress =
                    ((t - 0.15) / 0.85).clamp(0.0, 1.0);
                final double contentOpacity =
                    Curves.easeOut.transform(contentProgress);

                // Smooth fade-in & slide-up for bottom button
                final double buttonProgress =
                    ((t - 0.25) / 0.75).clamp(0.0, 1.0);
                final double buttonOpacity =
                    Curves.easeOut.transform(buttonProgress);
                final double buttonOffsetY = 24.0 * (1.0 - buttonOpacity);

                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        physics: isCompleted
                            ? const AlwaysScrollableScrollPhysics()
                            : const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1. Logo: scales and moves smoothly from Landing 1 to Landing 2
                            Center(
                              child: SizedBox(
                                width: 200,
                                height: 110,
                                child: Transform.translate(
                                  offset: Offset(0, currentLogoY),
                                  child: Transform.scale(
                                    scale: currentScale,
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      'assets/logo oro hijau.png',
                                      fit: BoxFit.cover,
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 2),

                            // 2. Tagline text: strictly conditional, ONLY rendered on Landing Page 2
                            if (isCompleted || !widget.startFromLanding1)
                              const Center(
                                child: Text(
                                  'Semua yang kamu butuhkan,\nada di sini!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: MarketColors.brown,
                                    fontSize: 13,
                                    height: 1.4,
                                  ),
                                ),
                              )
                            else
                              const SizedBox(height: 38),

                            // 3. Landing Page 2 Body Content: slides up smoothly behind header and fades in
                            Transform.translate(
                              offset: Offset(0, currentContentY),
                              child: Opacity(
                                opacity: contentOpacity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                                            description:
                                                'Jl. Guntur No. 20,\nKel. Oro-oro Dowo, Kec. Klojen,\nKota Malang, Jawa Timur',
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
                          ],
                        ),
                      ),
                    ),

                    // 3. Bottom Button ("Selanjutnya"): slides up smoothly into place and fades in
                    Transform.translate(
                      offset: Offset(0, buttonOffsetY),
                      child: Opacity(
                        opacity: buttonOpacity,
                        child: Padding(
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
                              onPressed: isCompleted
                                  ? () => goTo(context, '/home')
                                  : null,
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
                      ),
                    ),
                  ],
                );
              },
            );
          },
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
