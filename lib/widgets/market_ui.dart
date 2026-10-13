import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../data/market_data.dart';

class MarketColors {
  static const canvas = Color(0xFFF3EEF1);
  static const background = Color(0xFFF0F6DF);
  static const paper = Colors.white;
  static const pink = Color(0xFFD56989);
  static const pinkLight = Color(0xFFEA9CAF);
  static const green = Color(0xFFC2DC80);
  static const greenDark = Color(0xFF4B6515);
  static const brown = Color(0xFF594045);
  static const ink = Color(0xFF1F2937);
  static const muted = Color(0xFF6B7280);
  static const yellow = Color(0xFFFBBF24);
}

void goTo(BuildContext context, String route) {
  Navigator.of(context).pushNamed(route);
}

void goBack(BuildContext context, {String fallback = '/home'}) {
  if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop();
  } else {
    Navigator.of(context).pushReplacementNamed(fallback);
  }
}

String assetPath(String file) => 'assets/$file';

class MarketPage extends StatelessWidget {
  const MarketPage({
    required this.child,
    this.background = MarketColors.background,
    super.key,
  });

  final Widget child;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MarketColors.canvas,
      body: SafeArea(
        child: Center(
          child: Container(
            width: 402,
            constraints: const BoxConstraints(maxWidth: 402),
            color: background,
            child: child,
          ),
        ),
      ),
    );
  }
}

class MarketAsset extends StatelessWidget {
  const MarketAsset(
    this.file, {
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
    super.key,
  });

  final String file;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final path = assetPath(file);
    if (file.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(
        path,
        width: width,
        height: height,
        fit: fit,
        colorFilter: color == null
            ? null
            : ColorFilter.mode(color!, BlendMode.srcIn),
      );
    }
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, _, _) => const Icon(
        Icons.image_not_supported_outlined,
        color: MarketColors.muted,
      ),
    );
  }
}

class BrandHeader extends StatelessWidget {
  const BrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [MarketColors.pink, MarketColors.pinkLight],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(color: MarketColors.green, offset: Offset(0, 4)),
            ],
          ),
          child: const MarketAsset('c03df.svg', width: 20, height: 20),
        ),
        const SizedBox(width: 8),
        const Expanded(
          child: Text(
            'Pasar Oro-Oro Dowo',
            style: TextStyle(
              color: MarketColors.pink,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -.6,
            ),
          ),
        ),
      ],
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    required this.controller,
    required this.hint,
    this.onChanged,
    super.key,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(fontSize: 12, color: MarketColors.ink),
        decoration: InputDecoration(
          prefixIcon: const Padding(
            padding: EdgeInsets.all(11),
            child: MarketAsset('14528.svg', width: 16, height: 16),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
            minHeight: 36,
          ),
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: const BorderSide(color: Color(0x66EA9CAF)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: const BorderSide(color: Color(0x66EA9CAF)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: const BorderSide(color: MarketColors.pink),
          ),
        ),
      ),
    );
  }
}

class PageTitleBar extends StatelessWidget {
  const PageTitleBar({
    required this.title,
    this.subtitle,
    this.onBack,
    this.asset,
    super.key,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final String? asset;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 64),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: Color(0xFFF0F6DF),
        border: Border(bottom: BorderSide(color: Color(0x22D56989))),
      ),
      child: Row(
        children: [
          if (onBack != null)
            SizedBox(
              width: 36,
              height: 36,
              child: Material(
                color: Colors.white,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onBack,
                  child: const Icon(
                    Icons.arrow_back,
                    size: 18,
                    color: MarketColors.brown,
                  ),
                ),
              ),
            )
          else
            const SizedBox(width: 36),
          const SizedBox(width: 8),
          if (asset != null) ...[
            MarketAsset(asset!, width: 28, height: 28),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: MarketColors.brown,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: MarketColors.pink,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 44),
        ],
      ),
    );
  }
}

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({required this.active, super.key});

  final String active;

  static const items = <(String, String, String)>[
    ('Home', '/home', 'dfd0c.svg'),
    ('Toko', '/toko', '2781e.svg'),
    ('Promo', '/promo', '75326.svg'),
    ('Review Pasar', '/review-pasar', '3de6e.svg'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      padding: const EdgeInsets.fromLTRB(8, 7, 8, 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .97),
        border: const Border(top: BorderSide(color: Color(0x22D56989))),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: items.map((item) {
          final selected = item.$1 == active;
          return Expanded(
            child: InkWell(
              onTap: () => goTo(context, item.$2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 22,
                    height: 22,
                    child: MarketAsset(
                      item.$3,
                      color: selected ? MarketColors.pink : MarketColors.muted,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.$1,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: item.$1 == 'Review Pasar' ? 9 : 10,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: selected ? MarketColors.pink : MarketColors.muted,
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

class SectionHeading extends StatelessWidget {
  const SectionHeading(this.title, {this.action, this.onTap, super.key});

  final String title;
  final String? action;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xFF111827),
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
        if (action != null)
          TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              foregroundColor: MarketColors.pink,
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 32),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              action!,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
            ),
          ),
      ],
    );
  }
}

class StoreCard extends StatelessWidget {
  const StoreCard({required this.store, super.key});

  final StoreData store;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0x33EA9CAF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.55,
            child: Stack(
              fit: StackFit.expand,
              children: [
                MarketAsset(store.image, fit: BoxFit.cover),
                Positioned(top: 8, left: 8, child: _badge(store.badge)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  store.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.25,
                    fontWeight: FontWeight.w700,
                    color: MarketColors.ink,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  store.displayCategory,
                  style: const TextStyle(
                    fontSize: 10,
                    color: MarketColors.muted,
                  ),
                ),
                const SizedBox(height: 7),
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
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.circle, size: 3, color: Color(0xFF9CA3AF)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        store.products,
                        style: const TextStyle(
                          fontSize: 9,
                          color: MarketColors.muted,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 7, 8, 8),
            child: SizedBox(
              width: double.infinity,
              height: 27,
              child: ElevatedButton(
                onPressed: () => goTo(context, '/detail-toko/${store.id}'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: MarketColors.yellow,
                  foregroundColor: MarketColors.brown,
                  minimumSize: const Size(0, 24),
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 1,
                ),
                child: const Text(
                  'Lihat Toko',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .94),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: MarketColors.pink,
        ),
      ),
    );
  }
}

class RoundedCard extends StatelessWidget {
  const RoundedCard({
    required this.child,
    this.padding = const EdgeInsets.all(14),
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0x33EA9CAF)),
      ),
      child: child,
    );
  }
}

class PrimaryMarketButton extends StatelessWidget {
  const PrimaryMarketButton({
    required this.label,
    required this.onPressed,
    this.icon = Icons.chevron_right,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: MarketColors.yellow,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
        ),
      ),
    );
  }
}

class ErrorNotice extends StatelessWidget {
  const ErrorNotice(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x55D56989)),
      ),
      child: Text(
        message,
        style: const TextStyle(
          color: MarketColors.brown,
          fontSize: 11,
          height: 1.4,
        ),
      ),
    );
  }
}
