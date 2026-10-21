import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/review_api.dart';
import '../../widgets/market_ui.dart';

class WriteStoreReviewScreen extends StatefulWidget {
  const WriteStoreReviewScreen({super.key});

  @override
  State<WriteStoreReviewScreen> createState() => _WriteStoreReviewScreenState();
}

class _WriteStoreReviewScreenState extends State<WriteStoreReviewScreen> {
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

  // Sample mock images when user hasn't selected photos yet
  final List<String> _sampleImages = [
    'https://api.builder.io/api/v1/image/assets/TEMP/281087ddf5a502278dbbffd2002884256a7752c8?width=197',
    'https://api.builder.io/api/v1/image/assets/TEMP/f4caf1c7c8b48d3370ebb5e48d3299eefdb4750a?width=197',
  ];
  final List<int> _removedSampleIndices = [];

  @override
  void initState() {
    super.initState();
    _experienceController.addListener(() {
      setState(() {});
    });
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
    } on Exception catch (error) {
      if (mounted) setState(() => _error = 'Foto tidak dapat dipilih: $error');
    }
  }

  Future<void> _submit() async {
    setState(() {
      _error = null;
      _sending = true;
    });
    try {
      final name = _nameController.text.trim().isEmpty
          ? 'Anonim'
          : _nameController.text.trim();
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
          Navigator.of(context)
              .pushReplacementNamed('/detail-toko/lumpur-kentang-27');
        }
      }
    } catch (error) {
      if (mounted) {
        setState(() => _error = 'Gagal mengirim ulasan toko: $error');
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
              Color(0x40C2DC80), // rgba(194, 220, 128, 0.25)
              Color(0x20C2DC80),
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
            // Scrollable Content
            Positioned.fill(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 110),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header Bar
                    _buildHeader(),

                    // Main Review Form Sections
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Section A: Main Star Rating
                          _buildStarRatingSection(),
                          const SizedBox(height: 16),

                          // Section C: User Profile Input
                          _buildUserProfileSection(),
                          const SizedBox(height: 16),

                          // Section D: Text Story / Experience
                          _buildTextStorySection(),
                          const SizedBox(height: 16),

                          // Section E: Upload Photo Support
                          _buildUploadPhotoSection(),
                          const SizedBox(height: 16),

                          // Section F: Helpful Review Banner
                          _buildHelpfulReviewBanner(),
                          const SizedBox(height: 20),

                          // Section G: Main Submit Action
                          _buildSubmitButton(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Navigation Bar
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

  // --- HEADER ---
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFC2DC80).withValues(alpha: 0.25),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Button - Kembali
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
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x0D000000),
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: SvgPicture.string(
                  '''<svg width="14" height="14" viewBox="0 0 14 14" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M3.1875 7.5L7.85417 12.1667L6.66667 13.3333L0 6.66667L6.66667 0L7.85417 1.16667L3.1875 5.83333H13.3333V7.5H3.1875V7.5" fill="#111C2D"/>
</svg>''',
                ),
              ),
            ),

            // Title Container
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Tulis Ulasan Toko',
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

            // Empty balancer
            const SizedBox(width: 40, height: 40),
          ],
        ),
      ),
    );
  }

  // --- SECTION A: MAIN STAR RATING ---
  Widget _buildStarRatingSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFCE7F3).withValues(alpha: 0.70),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14D56989),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
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

          // Large Interactive Star Group
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starIndex = index + 1;
              final isFilled = starIndex <= _rating;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: InkWell(
                  onTap: () => setState(() => _rating = starIndex),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    child: SvgPicture.string(
                      '''<svg width="36" height="36" viewBox="0 0 36 36" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M18 25.905L27.27 31.5L24.81 20.955L33 13.86L22.215 12.945L18 3L13.785 12.945L3 13.86L11.19 20.955L8.73 31.5L18 25.905" fill="${isFilled ? '#FBBF24' : '#E2E8F0'}"/>
</svg>''',
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),

          // Dynamic Rating Label Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFC2DC80),
              borderRadius: BorderRadius.circular(9999),
              border: Border.all(
                color: const Color(0xFF4B6515),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF594045),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _ratingLabels[_rating] ?? 'Sangat Puas! / Sangat Direkomendasikan',
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

  // --- SECTION C: USER PROFILE INPUT ---
  Widget _buildUserProfileSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFC2DC80),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14D56989),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
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
              border: Border.all(
                color: const Color(0xFFC2DC80),
                width: 1,
              ),
            ),
            child: TextField(
              controller: _nameController,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1E293B),
              ),
              decoration: InputDecoration(
                hintText: 'Nama Anda (mis. Budi Santoso)',
                hintStyle: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF64748B).withValues(alpha: 0.7),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                border: InputBorder.none,
                isDense: true,
                suffixIcon: Container(
                  width: 36,
                  alignment: Alignment.center,
                  child: SvgPicture.string(
                    '''<svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M8.0001 14.4C11.5324 14.4 14.4001 11.5323 14.4001 8.00001C14.4001 4.46775 11.5324 1.60001 8.0001 1.60001C4.46784 1.60001 1.6001 4.46775 1.6001 8.00001C1.6001 11.5323 4.46784 14.4 8.0001 14.4V14.4M10.9657 6.96561C11.2689 6.6517 11.2645 6.15274 10.956 5.84415C10.6474 5.53556 10.1484 5.53123 9.8345 5.83441L7.2001 8.46881L6.1657 7.43441C5.85179 7.13123 5.35283 7.13556 5.04424 7.44415C4.73566 7.75274 4.73132 8.2517 5.0345 8.56561L6.6345 10.1656C6.9469 10.4779 7.4533 10.4779 7.7657 10.1656L10.9657 6.96561V6.96561" fill-rule="evenodd" clip-rule="evenodd" fill="#FBBF24"/>
</svg>''',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- SECTION D: TEXT STORY / EXPERIENCE ---
  Widget _buildTextStorySection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFC2DC80),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14D56989),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
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
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF334155),
                  height: 1.33,
                ),
              ),
              Text(
                'Maks. 500 karakter',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF94A3B8),
                  height: 1.5,
                ),
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
              border: Border.all(
                color: const Color(0xFFF59E0B),
                width: 1,
              ),
            ),
            child: TextField(
              controller: _experienceController,
              maxLines: 4,
              maxLength: 500,
              buildCounter: (
                context, {
                required currentLength,
                required isFocused,
                maxLength,
              }) =>
                  null,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 12,
                color: Color(0xFF1E293B),
                height: 1.4,
              ),
              decoration: const InputDecoration(
                hintText:
                    'Bagikan pengalaman kunjungan Anda, kualitas makanan, pelayanan, atau suasana pasar...',
                hintStyle: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 11,
                  color: Color(0xFF94A3B8),
                ),
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
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Color(0xFF64748B),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- SECTION E: UPLOAD PHOTO SUPPORT ---
  Widget _buildUploadPhotoSection() {
    final int totalSelected = _photos.length +
        (_sampleImages.length - _removedSampleIndices.length);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFC2DC80),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14D56989),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Tambah Foto Kunjungan ',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF334155),
                      ),
                    ),
                    TextSpan(
                      text: '(Opsional)',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '$totalSelected Terpilih',
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF594045),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Photos Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Dashed Upload Box
                InkWell(
                  onTap: _pickPhotos,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 100,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDF2F8).withValues(alpha: 0.50),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFC2DC80),
                        width: 1.5,
                        strokeAlign: BorderSide.strokeAlignInside,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: SvgPicture.string(
                            '''<svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M7.99984 2.66669V13.3334M13.3332 8.00002H2.6665" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" stroke="#4B6515"/>
</svg>''',
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          '+ Foto',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF4B6515),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Display selected photos from picker
                for (int i = 0; i < _photos.length; i++) ...[
                  const SizedBox(width: 10),
                  Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFE2E8F0),
                            width: 1,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: kIsWeb
                            ? Image.network(
                                _photos[i].path,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(_photos[i].path),
                                fit: BoxFit.cover,
                              ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: InkWell(
                          onTap: () => setState(() => _photos.removeAt(i)),
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: const BoxDecoration(
                              color: Color(0x99000000),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              '✕',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                // Display sample images if present
                for (int idx = 0; idx < _sampleImages.length; idx++)
                  if (!_removedSampleIndices.contains(idx)) ...[
                    const SizedBox(width: 10),
                    Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFE2E8F0),
                              width: 1,
                            ),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Image.network(
                            _sampleImages[idx],
                            fit: BoxFit.cover,
                          ),
                        ),
                        if (idx == 1)
                          Positioned(
                            left: 5,
                            bottom: 5,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xB3000000),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Lorong',
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 9,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: InkWell(
                            onTap: () => setState(() {
                              _removedSampleIndices.add(idx);
                            }),
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(
                                color: Color(0x99000000),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                '✕',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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

  // --- SECTION F: HELPFUL REVIEW BANNER ---
  Widget _buildHelpfulReviewBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFC2DC80).withValues(alpha: 0.50),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF4B6515),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: SvgPicture.string(
              '''<svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M8.8001 2.39998C8.8001 1.95844 8.44163 1.59998 8.0001 1.59998C7.55857 1.59998 7.2001 1.95844 7.2001 2.39998V3.19998C7.2001 3.64151 7.55857 3.99998 8.0001 3.99998C8.44163 3.99998 8.8001 3.64151 8.8001 3.19998V2.39998V2.39998M12.5257 4.60558C12.8289 4.29167 12.8245 3.79271 12.516 3.48412C12.2074 3.17553 11.7084 3.1712 11.3945 3.47438L10.8289 4.03998C10.5257 4.35388 10.5301 4.85284 10.8386 5.16143C11.1472 5.47002 11.6462 5.47435 11.9601 5.17118L12.5257 4.60558V4.60558M14.4001 7.99998C14.4001 8.44151 14.0416 8.79998 13.6001 8.79998H12.8001C12.3586 8.79998 12.0001 8.44151 12.0001 7.99998C12.0001 7.55844 12.3586 7.19998 12.8001 7.19998H13.6001C14.0416 7.19998 14.4001 7.55844 14.4001 7.99998V7.99998M4.0401 5.17118C4.24096 5.37914 4.5384 5.46255 4.8181 5.38933C5.09781 5.31612 5.31624 5.09769 5.38946 4.81798C5.46267 4.53828 5.37926 4.24084 5.1713 4.03998L4.6057 3.47438C4.29179 3.1712 3.79283 3.17553 3.48424 3.48412C3.17566 3.79271 3.17132 4.29167 3.4745 4.60558L4.0401 5.17118V5.17118M4.0001 7.99998C4.0001 8.44151 3.64163 8.79998 3.2001 8.79998H2.4001C1.95857 8.79998 1.6001 8.44151 1.6001 7.99998C1.6001 7.55844 1.95857 7.19998 2.4001 7.19998H3.2001C3.64163 7.19998 4.0001 7.55844 4.0001 7.99998V7.99998M6.4001 12.8V12H9.6001V12.8C9.6001 13.683 8.88316 14.4 8.0001 14.4C7.11703 14.4 6.4001 13.683 6.4001 12.8V12.8M9.6001 11.2H6.4001C4.78657 11.2007 3.42491 10 3.22368 8.39907C3.02244 6.79814 4.04458 5.29782 5.6081 4.89918C5.73749 3.23208 7.12799 1.94532 8.8001 1.94532C10.4722 1.94532 11.8627 3.23208 11.9921 4.89918C13.7309 5.55927 14.6066 7.50682 13.9465 9.24558C13.2864 10.9843 11.3389 11.8601 9.6001 11.2V11.2" fill="#4B6515"/>
</svg>''',
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Ulasan Anda Menghidupkan UMKM',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                    height: 1.33,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Ulasan jujur Anda sangat membantu menjaga kualitas fasilitas pasar dan mendukung 280+ pedagang lokal di Pasar Oro-Oro Dowo.',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF475569),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- SECTION G: MAIN SUBMIT ACTION ---
  Widget _buildSubmitButton() {
    return InkWell(
      onTap: _sending ? null : _submit,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFFFBBF24),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFF59E0B),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFC2DC80).withValues(alpha: 0.60),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: _sending
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Kirim Ulasan Toko',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.43,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SvgPicture.string(
                    '''<svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M9.33333 3.33331L14 7.99998M14 7.99998L9.33333 12.6666M14 7.99998H2" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" stroke="white"/>
</svg>''',
                  ),
                ],
              ),
      ),
    );
  }

  // --- FLOATING BOTTOM NAV BAR ---
  Widget _buildFloatingBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(
          color: const Color(0xFFC2DC80),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14D56989),
            blurRadius: 25,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // 1. Home
          _buildNavItem(
            label: 'Home',
            isActive: false,
            iconSvg: '''<svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M10 14V8.66667C10 8.29872 9.70128 8 9.33333 8H6.66667C6.29872 8 6 8.29872 6 8.66667V14" stroke-width="1.33333" stroke-linecap="round" stroke-linejoin="round" stroke="#6B7280"/>
<path d="M2 6.66666C1.99991 6.27408 2.17283 5.90141 2.47267 5.64799L7.13933 1.64799C7.63626 1.22801 8.36374 1.22801 8.86067 1.64799L13.5273 5.64799C13.8272 5.90141 14.0001 6.27408 14 6.66666V12.6667C14 13.4025 13.4026 14 12.6667 14H3.33333C2.59745 14 2 13.4025 2 12.6667V6.66666" stroke-width="1.33333" stroke-linecap="round" stroke-linejoin="round" stroke="#6B7280"/>
</svg>''',
            onTap: () => goTo(context, '/home'),
          ),

          // 2. Toko (Active in this view)
          _buildNavItem(
            label: 'Toko',
            isActive: true,
            iconSvg: '''<svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M12.5 17.5V13.3333C12.5 12.8731 12.1269 12.5 11.6667 12.5H8.33333C7.8731 12.5 7.5 12.8731 7.5 13.3333V17.5" stroke-width="1.66667" stroke-linecap="round" stroke-linejoin="round" stroke="#4B6515"/>
<path d="M14.8116 8.59163C14.4507 8.24612 13.8817 8.24612 13.5208 8.59163C12.7159 9.35935 11.4498 9.35935 10.6449 8.59163C10.2841 8.24665 9.71575 8.24665 9.35494 8.59163C8.54994 9.35988 7.28329 9.35988 6.47828 8.59163C6.11736 8.24612 5.54836 8.24612 5.18744 8.59163C4.41195 9.33165 3.20147 9.36243 2.38937 8.66277C1.57726 7.96311 1.42862 6.7614 2.04578 5.88496L4.45328 2.39829C4.76345 1.94061 5.28039 1.66652 5.83328 1.66663H14.1666C14.7178 1.66641 15.2335 1.93876 15.5441 2.39413L17.9566 5.88746C18.5739 6.76463 18.4243 7.96718 17.6109 8.66637C16.7975 9.36556 15.5861 9.33369 14.8116 8.59163Z" stroke-width="1.66667" stroke-linecap="round" stroke-linejoin="round" stroke="#4B6515"/>
<path d="M3.33337 9.125V15.8333C3.33337 16.7538 4.07957 17.5 5.00004 17.5H15C15.9205 17.5 16.6667 16.7538 16.6667 15.8333V9.125" stroke-width="1.66667" stroke-linecap="round" stroke-linejoin="round" stroke="#4B6515"/>
</svg>''',
            onTap: () => goTo(context, '/toko'),
          ),

          // 3. Promo
          _buildNavItem(
            label: 'Promo',
            isActive: false,
            iconSvg: '''<svg width="22" height="22" viewBox="0 0 23 23" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M16.9212 17.8795C13.9272 20.8735 9.07291 20.8735 6.07889 17.8795C4.58188 16.3825 3.83338 14.4204 3.83337 12.4583C3.83337 10.4963 4.58188 8.53418 6.07889 7.03717C6.07889 7.03717 6.70842 8.62496 8.62508 9.58329C8.62508 7.66662 9.10425 4.79162 11.4865 2.875C13.4167 4.79167 15.4207 5.53672 16.9212 7.03717C18.4182 8.53418 19.1667 10.4963 19.1667 12.4583C19.1667 14.4204 18.4182 16.3825 16.9212 17.8795ZM13.533 15.4496C12.4102 16.5723 10.5899 16.5723 9.46711 15.4496C8.90574 14.8882 8.62505 14.1524 8.62504 13.4167L10.5417 13.4166L11.514 10.5417C12.2451 10.5452 12.9751 10.8259 13.533 11.3837C14.0944 11.9451 14.375 12.6809 14.375 13.4167C14.375 14.1524 14.0943 14.8882 13.533 15.4496Z" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" stroke="#6B7280"/>
</svg>''',
            onTap: () => goTo(context, '/promo'),
          ),

          // 4. Review Pasar
          _buildNavItem(
            label: 'Review Pasar',
            isActive: false,
            iconSvg: '''<svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M5.96672 12H8.76255L13.3459 7.41667C13.4834 7.27917 13.5865 7.12257 13.6553 6.94688C13.724 6.77118 13.7584 6.59931 13.7584 6.43125C13.7584 6.26319 13.7202 6.09896 13.6438 5.93854C13.5674 5.77813 13.4681 5.62917 13.3459 5.49167L12.5209 4.62083C12.3834 4.48333 12.2306 4.38021 12.0625 4.31146C11.8945 4.24271 11.7188 4.20833 11.5355 4.20833C11.3674 4.20833 11.1955 4.24271 11.0198 4.31146C10.8441 4.38021 10.6875 4.48333 10.55 4.62083L5.96672 9.20417V12V12M12.3834 6.43125V6.43125L11.5355 5.58333V5.58333L12.3834 6.43125V6.43125M7.34172 10.625V9.75417L9.6563 7.43958L10.1146 7.85208L10.5271 8.31042L8.21255 10.625H7.34172V10.625M10.1146 7.85208L10.5271 8.31042V8.31042L9.6563 7.43958V7.43958L10.1146 7.85208V7.85208M10.7105 12H16.9667V10.1667H12.5438L10.7105 12V12M2.30005 19.3333V2.83333C2.30005 2.32917 2.47956 1.89757 2.83859 1.53854C3.19762 1.17951 3.62922 1 4.13338 1H18.8C19.3042 1 19.7358 1.17951 20.0948 1.53854C20.4539 1.89757 20.6334 2.32917 20.6334 2.83333V13.8333C20.6334 14.3375 20.4539 14.7691 20.0948 15.1281C19.7358 15.4872 19.3042 15.6667 18.8 15.6667H5.96672L2.30005 19.3333V19.3333M5.18755 13.8333H18.8V13.8333V13.8333V2.83333V2.83333V2.83333H4.13338V2.83333V2.83333V14.8646L5.18755 13.8333V13.8333M4.13338 13.8333V13.8333V2.83333V2.83333V2.83333V2.83333V2.83333V13.8333V13.8333V13.8333V13.8333V13.8333" fill="#6B7280"/>
</svg>''',
            onTap: () => goTo(context, '/review-pasar'),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required String label,
    required bool isActive,
    required String iconSvg,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
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
              color: isActive
                  ? const Color(0xFFC2DC80).withValues(alpha: 0.50)
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.string(iconSvg),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              color: isActive
                  ? const Color(0xFF4B6515)
                  : const Color(0xFF9CA3AF),
              fontSize: label == 'Review Pasar' ? 9 : 10,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
