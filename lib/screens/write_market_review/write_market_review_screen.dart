// lib/screens/write_market_review/write_market_review_screen.dart
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/review_api.dart';
import '../../widgets/market_ui.dart';

class WriteMarketReviewScreen extends StatefulWidget {
  const WriteMarketReviewScreen({super.key});

  @override
  State<WriteMarketReviewScreen> createState() => _WriteMarketReviewScreenState();
}

class _WriteMarketReviewScreenState extends State<WriteMarketReviewScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _photos = [];
  int _rating = 5;
  bool _sending = false;
  String? _error;

  static const _ratingLabels = {
    1: 'Sangat Kecewa',
    2: 'Kurang Puas',
    3: 'Cukup Baik',
    4: 'Puas! / Direkomendasikan',
    5: 'Sangat Puas! / Sangat Direkomendasikan',
  };

  // Mock images when no photos selected
  final List<String> _sampleImages = [
    'https://api.builder.io/api/v1/image/assets/TEMP/281087ddf5a502278dbbffd2002884256a7752c8?width=197',
    'https://api.builder.io/api/v1/image/assets/TEMP/f4caf1c7c8b48d3370ebb5e48d3299eefdb4750a?width=197',
  ];
  final List<int> _removedSampleIndices = [];

  @override
  void initState() {
    super.initState();
    _experienceController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  Future<void> _pickPhotos() async {
    final remaining = 5 - _photos.length;
    if (remaining <= 0) return;
    try {
      final selected = await _picker.pickMultiImage(
        limit: remaining,
        imageQuality: 85,
      );
      if (selected.isNotEmpty && mounted) {
        setState(() => _photos.addAll(selected.take(remaining)));
      }
    } on Exception catch (e) {
      if (mounted) setState(() => _error = 'Foto tidak dapat dipilih: $e');
    }
  }

  Future<void> _submit() async {
    setState(() {
      _error = null;
      _sending = true;
    });
    try {
      final name = _nameController.text.trim().isEmpty ? 'Anonim' : _nameController.text.trim();
      final text = _experienceController.text.trim().isEmpty
          ? 'Pengunjung belum menambahkan cerita.'
          : _experienceController.text.trim();

      await StoreReviewApi.submitFormReview(
        name: name,
        text: text,
        rating: _rating,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Ulasan berhasil dikirim! Terima kasih atas kontribusi Anda.',
            style: TextStyle(fontFamily: 'Plus Jakarta Sans'),
          ),
          backgroundColor: const Color(0xFF4B6515),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );

      await Future<void>.delayed(const Duration(milliseconds: 700));
      if (mounted) {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop(true);
        } else {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = 'Gagal mengirim ulasan pasar: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _error ?? 'Terjadi kesalahan.',
              style: const TextStyle(fontFamily: 'Plus Jakarta Sans'),
            ),
            backgroundColor: const Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

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
              Color(0x40C2DC80), // 25% opacity
              Color(0x20C2DC80), // 12.5% opacity
              Colors.white,
            ],
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
            // Scrollable content
            Positioned.fill(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 110),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildStarRatingSection(),
                          const SizedBox(height: 16),
                          _buildUserProfileSection(),
                          const SizedBox(height: 16),
                          _buildTextStorySection(),
                          const SizedBox(height: 16),
                          _buildUploadPhotoSection(),
                          const SizedBox(height: 16),
                          _buildHelpfulReviewBanner(),
                          const SizedBox(height: 20),
                          _buildSubmitButton(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Floating bottom navigation
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: _buildFloatingBottomNav(),
            ),
          ],
        ),
      ),
    );
  }

  // Header
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border(bottom: BorderSide(color: const Color(0xFFC2DC80).withValues(alpha: 0.25), width: 1)),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Back button
            InkWell(
              onTap: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                } else {
                  goTo(context, '/home');
                }
              },
              borderRadius: BorderRadius.circular(9999),
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1))],
                ),
                alignment: Alignment.center,
                child: SvgPicture.string('''<svg width="14" height="14" viewBox="0 0 14 14" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M3.1875 7.5L7.85417 12.1667L6.66667 13.3333L0 6.66667L6.66667 0L7.85417 1.16667L3.1875 5.83333H13.3333V7.5H3.1875V7.5" fill="#111C2D"/></svg>'''),
              ),
            ),
            // Title
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Tulis Ulasan Pasar',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                      height: 1.25,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Pasar Oro-Oro Dowo, Malang',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 40, height: 40), // spacer
          ],
        ),
      ),
    );
  }

  // Star rating section
  Widget _buildStarRatingSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFCE7F3).withValues(alpha: 0.70), width: 1),
        boxShadow: const [
          BoxShadow(color: Color(0x14D56989), blurRadius: 20, offset: Offset(0, 4)),
          BoxShadow(color: Color(0x0A000000), blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Beri Penilaian Anda',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
              height: 1.43,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Bagikan pengalaman kunjungan Anda ke pasar ini',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFF64748B),
              height: 1.33,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final star = index + 1;
              final filled = star <= _rating;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: InkWell(
                  onTap: () => setState(() => _rating = star),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    child: SvgPicture.string('''<svg width="36" height="36" viewBox="0 0 36 36" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M18 25.905L27.27 31.5L24.81 20.955L33 13.86L22.215 12.945L18 3L13.785 12.945L3 13.86L11.19 20.955L8.73 31.5L18 25.905" fill="${filled ? '#FBBF24' : '#E2E8F0'}"/></svg>'''),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFC2DC80),
              borderRadius: BorderRadius.circular(9999),
              border: Border.all(color: const Color(0xFF4B6515), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF594045), shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Text(
                  _ratingLabels[_rating] ?? '',
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF594045),
                    height: 1.33,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // User profile section
  Widget _buildUserProfileSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC2DC80), width: 1),
        boxShadow: const [
          BoxShadow(color: Color(0x14D56989), blurRadius: 20, offset: Offset(0, 4)),
          BoxShadow(color: Color(0x0A000000), blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nama Pengunjung / Penulis',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF334155),
              height: 1.33,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFC2DC80).withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFC2DC80), width: 1),
            ),
            child: TextField(
              controller: _nameController,
              style: const TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1E293B)),
              decoration: InputDecoration(
                hintText: 'Nama Anda (mis. Budi Santoso)',
                hintStyle: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 12, fontWeight: FontWeight.w400, color: const Color(0xFF64748B).withValues(alpha: 0.7)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: InputBorder.none,
                isDense: true,
                suffixIcon: Container(
                  width: 36,
                  alignment: Alignment.center,
                  child: SvgPicture.string('''<svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M8.0001 14.4C11.5324 14.4 14.4001 11.5323 14.4001 8.00001C14.4001 4.46775 11.5324 1.60001 8.0001 1.60001C4.46784 1.60001 1.6001 4.46775 1.6001 8.00001C1.6001 11.5323 4.46784 14.4 8.0001 14.4V14.4M10.9657 6.96561C11.2689 6.6517 11.2645 6.15274 10.956 5.84415C10.6474 5.53556 10.1484 5.53123 9.8345 5.83441L7.2001 8.46881L6.1657 7.43441C5.85179 7.13123 5.35283 7.13556 5.04424 7.44415C4.73566 7.75274 4.73132 8.2517 5.0345 8.56561L6.6345 10.1656C6.9469 10.4779 7.4533 10.4779 7.7657 10.1656L10.9657 6.96561V6.96561" fill-rule="evenodd" clip-rule="evenodd" fill="#FBBF24"/></svg>'''),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Text story section
  Widget _buildTextStorySection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC2DC80), width: 1),
        boxShadow: const [
          BoxShadow(color: Color(0x14D56989), blurRadius: 20, offset: Offset(0, 4)),
          BoxShadow(color: Color(0x0A000000), blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Ceritakan Pengalaman Anda',
                style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF334155), height: 1.33),
              ),
              Text(
                'Maks. 500 karakter',
                style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF94A3B8), height: 1.5),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 105,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFBBF24).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFF59E0B), width: 1),
            ),
            child: TextField(
              controller: _experienceController,
              maxLines: 4,
              maxLength: 500,
              buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
              style: const TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 12, color: Color(0xFF1E293B), height: 1.4),
              decoration: const InputDecoration(
                hintText: 'Bagikan pengalaman kunjungan Anda, kualitas makanan, pelayanan, atau suasana pasar...',
                hintStyle: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 11, color: Color(0xFF94A3B8)),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${_experienceController.text.length} / 500',
              style: const TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF64748B), height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  // Upload photo section
  Widget _buildUploadPhotoSection() {
    final int totalSelected = _photos.length + (_sampleImages.length - _removedSampleIndices.length);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC2DC80), width: 1),
        boxShadow: const [
          BoxShadow(color: Color(0x14D56989), blurRadius: 20, offset: Offset(0, 4)),
          BoxShadow(color: Color(0x0A000000), blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: const TextSpan(children: [
                  TextSpan(text: 'Tambah Foto Kunjungan ', style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF334155))),
                  TextSpan(text: '(Opsional)', style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF94A3B8))),
                ]),
              ),
              Text(
                '$totalSelected Terpilih',
                style: const TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF594045)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                InkWell(
                  onTap: _pickPhotos,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 100,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDF2F8).withValues(alpha: 0.50),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFC2DC80), width: 1.5, strokeAlign: BorderSide.strokeAlignInside),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          alignment: Alignment.center,
                          child: SvgPicture.string('''<svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M7.99984 2.66669V13.3334M13.3332 8.00002H2.6665" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" stroke="#4B6515"/></svg>'''),
                        ),
                        const SizedBox(height: 6),
                        const Text('+ Foto', style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF4B6515))),
                      ],
                    ),
                  ),
                ),
                for (int i = 0; i < _photos.length; i++) ...[
                  const SizedBox(width: 10),
                  Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 80,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0), width: 1)),
                        clipBehavior: Clip.antiAlias,
                        child: kIsWeb
                            ? Image.network(_photos[i].path, fit: BoxFit.cover)
                            : Image.file(File(_photos[i].path), fit: BoxFit.cover),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: InkWell(
                          onTap: () => setState(() => _photos.removeAt(i)),
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: const BoxDecoration(color: Color(0x99000000), shape: BoxShape.circle),
                            alignment: Alignment.center,
                            child: const Text('✕', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helpful review banner
  Widget _buildHelpfulReviewBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF59E0B).withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF59E0B), width: 1),
      ),
      child: Row(
        children: const [
          Icon(Icons.lightbulb, color: Color(0xFFF59E0B), size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Ulasan yang membantu meningkatkan kualitas pasar dan memberi insight bagi pengunjung lainnya.',
              style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 12, color: Color(0xFF92400E)),
            ),
          ),
        ],
      ),
    );
  }

  // Submit button
  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _sending ? null : _submit,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4B6515),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
        elevation: 4,
        shadowColor: const Color(0x26000000),
      ),
      child: _sending
          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
          : const Text('Kirim Ulasan', style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
    );
  }

  // Floating bottom navigation (placeholder)
  Widget _buildFloatingBottomNav() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [BoxShadow(color: Color(0x26000000), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(icon: const Icon(Icons.home), onPressed: () => goTo(context, '/home')),
          IconButton(icon: const Icon(Icons.map), onPressed: () => goTo(context, '/market-map')),
          IconButton(icon: const Icon(Icons.list), onPressed: () => goTo(context, '/store-list')),
        ],
      ),
    );
  }
}
