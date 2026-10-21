import 'package:flutter/material.dart';

import '../../widgets/market_ui.dart';

class MarketMapScreen extends StatelessWidget {
  const MarketMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MarketPage(
      child: Column(
        children: [
          Container(
            constraints: const BoxConstraints(minHeight: 64),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: MarketColors.background,
              border: Border(
                bottom: BorderSide(
                  color: MarketColors.green.withValues(alpha: .7),
                ),
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: 0,
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Material(
                      color: Colors.white,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => goBack(context),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          size: 20,
                          color: MarketColors.brown,
                        ),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 44),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Denah Pasar Oro-Oro Dowo',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: MarketColors.brown,
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Lihat tata letak pasar',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: MarketColors.greenDark,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Container(
                decoration: BoxDecoration(
                  color: MarketColors.green,
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(color: MarketColors.brown, width: 1),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33594045),
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
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
        ],
      ),
    );
  }
}
