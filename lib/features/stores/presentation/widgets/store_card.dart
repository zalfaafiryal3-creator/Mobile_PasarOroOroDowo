import 'package:flutter/material.dart';
import 'package:frontend_flutter/core/presentation/widgets/market_ui.dart';
import 'package:frontend_flutter/features/stores/domain/entities/store.dart';

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
        border: Border.all(color: const Color(0xFFC2DC80)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.55,
            child: Stack(
              fit: StackFit.expand,
              children: [
                MarketAsset(
                  store.image,
                  fit: BoxFit.cover,
                  semanticLabel:
                      'Foto Kios ${store.name} - ${store.displayCategory} Pasar Oro-Oro Dowo',
                ),
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
