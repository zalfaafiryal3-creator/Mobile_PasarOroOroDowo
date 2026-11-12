import 'package:flutter/material.dart';

import '../../data/visit_planner_api.dart';
import '../../widgets/market_ui.dart';

class VisitPlannerScreen extends StatefulWidget {
  const VisitPlannerScreen({super.key});

  @override
  State<VisitPlannerScreen> createState() => _VisitPlannerScreenState();
}

class _VisitPlannerScreenState extends State<VisitPlannerScreen> {
  // A. State Input Sementara (Draft Input)
  String _draftDuration = '1 Jam';
  String _draftTaste = 'Pedas';
  double _draftBudget = 100000;

  // B. State Hasil Rekomendasi (Submitted Result)
  String? _submittedDuration;
  String? _submittedTaste;
  int? _submittedBudget;
  VisitPlanResult? _submittedPlanResult;
  String? _submittedTitle;

  // State Kontrol Request & Status
  bool _isLoading = false;
  String? _errorMessage;
  String? _emptyMessage;

  double get _boundedDraftBudget {
    final clamped = _draftBudget.clamp(10000.0, 120000.0);
    final stepped = (((clamped - 10000.0) / 5000.0).round() * 5000.0 + 10000.0);
    return stepped.clamp(10000.0, 120000.0);
  }

  String _rupiah(double amount) =>
      'Rp${amount.round().toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')}';

  Future<void> _fetchRecommendations() async {
    if (_isLoading) return; // Cegah request berulang saat masih loading

    final String selectedDuration = _draftDuration;
    final String selectedTaste = _draftTaste;
    final int selectedBudget = _boundedDraftBudget.round();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _emptyMessage = null;
    });

    final int minutes = switch (selectedDuration) {
      '30 Menit' => 30,
      '1 Jam' => 60,
      '2 Jam +' => 120,
      _ => 60,
    };

    final String taste = selectedTaste.toLowerCase();

    try {
      final response = await VisitPlannerApi.getRecommendations(
        availableTime: minutes,
        tastePreference: taste,
        budget: selectedBudget,
      );

      if (!mounted) return;

      if (response.success) {
        if (response.data == null || response.data!.stops.isEmpty) {
          setState(() {
            _submittedPlanResult = response.data;
            _submittedDuration = selectedDuration;
            _submittedTaste = selectedTaste;
            _submittedBudget = response.data?.budget ?? selectedBudget;
            _submittedTitle = response.data?.title;
            _emptyMessage = response.message.isNotEmpty
                ? response.message
                : 'Rekomendasi belum dapat dibuat karena data katalog rute belum tersedia.';
          });
        } else {
          setState(() {
            _submittedPlanResult = response.data;
            _submittedDuration = selectedDuration;
            _submittedTaste = selectedTaste;
            _submittedBudget = response.data?.budget ?? selectedBudget;
            _submittedTitle = response.data?.title;
            _emptyMessage = null;
          });
        }
      } else {
        setState(() {
          _errorMessage = response.message.isNotEmpty
              ? response.message
              : 'Gagal membuat rekomendasi kunjungan.';
        });
      }
    } on VisitPlannerApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Terjadi kesalahan: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

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
                        _draftDuration,
                        (value) => setState(() => _draftDuration = value),
                      ),
                      const SizedBox(height: 28),
                      _preferenceTitle('Preferensi Rasa'),
                      const SizedBox(height: 12),
                      _choiceRow(
                        ['Manis', 'Pedas', 'Asin'],
                        _draftTaste,
                        (value) => setState(() => _draftTaste = value),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: _selectPill(
                              'Gurih',
                              selected: _draftTaste == 'Gurih',
                              onTap: () => setState(() => _draftTaste = 'Gurih'),
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
                  'Budget: ${_rupiah(_boundedDraftBudget)}',
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
                      value: _boundedDraftBudget,
                      min: 10000,
                      max: 120000,
                      divisions: 22,
                      activeColor: MarketColors.greenDark,
                      inactiveColor: MarketColors.green,
                      onChanged: (value) {
                        final stepped = (((value - 10000.0) / 5000.0).round() * 5000.0 + 10000.0).clamp(10000.0, 120000.0);
                        setState(() => _draftBudget = stepped);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  height: 68,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _fetchRecommendations,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MarketColors.yellow,
                      foregroundColor: MarketColors.greenDark,
                      elevation: 5,
                      shadowColor: MarketColors.brown.withValues(alpha: .6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: MarketColors.greenDark,
                            ),
                          )
                        : const Text(
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
                        _submittedTitle?.isNotEmpty == true
                            ? _submittedTitle!
                            : (_submittedPlanResult?.title.isNotEmpty == true
                                ? _submittedPlanResult!.title
                                : 'Rute singkat 1 jam, pedas & hemat'),
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          color: MarketColors.greenDark,
                        ),
                      ),
                      if (_isLoading) ...[
                        const SizedBox(height: 36),
                        const Center(
                          child: Column(
                            children: [
                              CircularProgressIndicator(
                                color: MarketColors.greenDark,
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Menyusun rute rekomendasi terbaik...',
                                style: TextStyle(
                                  color: MarketColors.greenDark,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else if (_errorMessage != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEE2E2),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFEF4444)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.error_outline_rounded,
                                color: Color(0xFFB91C1C),
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: const TextStyle(
                                    color: Color(0xFF991B1B),
                                    fontSize: 10.5,
                                    height: 1.4,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else if (_emptyMessage != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF8E4),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: MarketColors.yellow),
                          ),
                          child: Text(
                            _emptyMessage!,
                            style: const TextStyle(
                              color: MarketColors.brown,
                              fontSize: 10,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ] else if (_submittedPlanResult != null &&
                          _submittedPlanResult!.stops.isNotEmpty) ...[
                        // Ringkasan Parameter Pengguna yang Disubmit (Waktu, Rasa, Budget)
                        Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 18),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 9,
                          ),
                          decoration: BoxDecoration(
                            color: MarketColors.background,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: MarketColors.green.withValues(alpha: 0.6),
                            ),
                          ),
                          child: Wrap(
                            spacing: 12,
                            runSpacing: 6,
                            alignment: WrapAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.access_time_rounded,
                                    size: 13,
                                    color: MarketColors.greenDark,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Waktu: ${_submittedDuration ?? _draftDuration}',
                                    style: const TextStyle(
                                      color: MarketColors.greenDark,
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.restaurant_menu_rounded,
                                    size: 13,
                                    color: MarketColors.greenDark,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Rasa: ${_submittedTaste ?? _draftTaste}',
                                    style: const TextStyle(
                                      color: MarketColors.greenDark,
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.account_balance_wallet_outlined,
                                    size: 13,
                                    color: MarketColors.greenDark,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Budget: ${_rupiah((_submittedBudget ?? _submittedPlanResult!.budget).toDouble())}',
                                    style: const TextStyle(
                                      color: MarketColors.greenDark,
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Daftar Perhentian Rute
                        for (int i = 0; i < _submittedPlanResult!.stops.length; i++)
                          _buildStopItem(
                            _submittedPlanResult!.stops[i],
                            i == _submittedPlanResult!.stops.length - 1,
                          ),
                        const Divider(color: MarketColors.yellow, thickness: 1),
                      ] else ...[
                        // Initial state sebelum tombol ditekan
                        const SizedBox(height: 18),
                        const _PlannerStepMarker(number: '1'),
                        const SizedBox(height: 58),
                        const _PlannerStepMarker(number: '2'),
                        const SizedBox(height: 58),
                        const Divider(color: MarketColors.yellow, thickness: 1),
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

  Widget _buildStopItem(VisitPlannerStop stop, bool isLast) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kolom Kiri: Step Marker & Garis Penghubung
          Column(
            children: [
              _PlannerStepMarker(number: stop.order.toString()),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: MarketColors.yellow,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          // Kolom Kanan: Detail Toko & Produk Rekomendasi
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 12 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama Toko
                  Text(
                    stop.storeName,
                    style: const TextStyle(
                      color: MarketColors.greenDark,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Kategori & Lokasi / Zona
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      _pill(
                        stop.category,
                        color: MarketColors.greenDark,
                        background: const Color(0xFFF0F6DF),
                      ),
                      if (stop.zone.isNotEmpty)
                        _pill(
                          stop.zone,
                          color: MarketColors.brown,
                          background: const Color(0xFFF7F3E9),
                        ),
                      _pill(
                        '~${stop.estimatedTime} mnt',
                        color: MarketColors.greenDark,
                        background: const Color(0xFFFFF8E4),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Kartu Produk Rekomendasi
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAF9F6),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: MarketColors.green.withValues(alpha: 0.6),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Produk Rekomendasi:',
                          style: TextStyle(
                            color: MarketColors.brown,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        for (final product in stop.products) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: const TextStyle(
                                        color: MarketColors.ink,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    if (product.description.isNotEmpty) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        product.description,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: MarketColors.muted,
                                          fontSize: 9.5,
                                          height: 1.3,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _rupiah(product.price.toDouble()),
                                style: const TextStyle(
                                  color: MarketColors.greenDark,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          if (product != stop.products.last)
                            const Divider(height: 12, thickness: 0.5),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Alasan Rekomendasi
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: MarketColors.yellow.withValues(alpha: 0.6),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 1),
                          child: Icon(
                            Icons.tips_and_updates_outlined,
                            size: 13,
                            color: MarketColors.yellow,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            stop.reason,
                            style: const TextStyle(
                              color: MarketColors.brown,
                              fontSize: 10,
                              fontStyle: FontStyle.italic,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
