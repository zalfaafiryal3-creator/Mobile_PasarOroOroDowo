// lib/screens/write_market_review/write_market_review_screen.dart
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:frontend_flutter/features/market_reviews/domain/usecases/submit_market_review.dart';
import 'package:frontend_flutter/core/presentation/widgets/market_ui.dart';

class WriteMarketReviewScreen extends StatefulWidget {
  const WriteMarketReviewScreen({required this.submitReview, super.key});

  final SubmitMarketReview submitReview;

  @override
  State<WriteMarketReviewScreen> createState() =>
      _WriteMarketReviewScreenState();
}

class _WriteMarketReviewScreenState extends State<WriteMarketReviewScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _photos = [];
  int _rating = 5;
  bool _sending = false;
  String? _uploadStatus;
  String? _error;

  // Selected aspect chips (all selected by default as in the design)
  final Set<String> _selectedAspects = {
    'kebersihan',
    'keramahan',
    'parkir',
    'kelengkapan',
  };

  static const _ratingLabels = {
    1: 'Sangat Kecewa',
    2: 'Kurang Puas',
    3: 'Cukup Baik',
    4: 'Puas! / Direkomendasikan',
    5: 'Sangat Puas! / Sangat Direkomendasikan',
  };

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
      _uploadStatus = null;
    });
    try {
      final name = _nameController.text.trim().isEmpty
          ? 'Anonim'
          : _nameController.text.trim();
      final text = _experienceController.text.trim().isEmpty
          ? 'Pengunjung belum menambahkan cerita.'
          : _experienceController.text.trim();

      final List<String> uploadedUrls = [];
      if (_photos.isNotEmpty) {
        for (int i = 0; i < _photos.length; i++) {
          if (mounted) {
            setState(() {
              _uploadStatus = 'Mengunggah foto (${i + 1}/${_photos.length})...';
            });
          }
          final url = await widget.submitReview.uploadPhoto(_photos[i]);
          uploadedUrls.add(url);
        }
      }

      if (mounted) {
        setState(() {
          _uploadStatus = 'Menyimpan ulasan...';
        });
      }

      await widget.submitReview(
        name: name,
        date: 'Baru saja',
        text: text,
        rating: _rating,
        photos: uploadedUrls,
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      await Future<void>.delayed(const Duration(milliseconds: 700));
      if (mounted) {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop(true);
        } else {
          goTo(context, '/review-pasar');
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
      if (mounted) {
        setState(() {
          _sending = false;
          _uploadStatus = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MarketPage(
      background: Colors.white,
      child: Container(
        color: const Color(0xFFF4F9EC),
        child: Stack(
          children: [
            // Scrollable form content
            Positioned.fill(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 110),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildMarketIdentityCard(),
                          const SizedBox(height: 14),
                          _buildStarRatingSection(),
                          const SizedBox(height: 14),
                          _buildAspectChipsSection(),
                          const SizedBox(height: 14),
                          _buildUserProfileSection(),
                          const SizedBox(height: 14),
                          _buildTextStorySection(),
                          const SizedBox(height: 14),
                          _buildUploadPhotoSection(),
                          const SizedBox(height: 14),
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
            // Floating bottom navigation bar (matches standard floating pill)
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: BottomNavigation(active: 'Review Pasar'),
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
            // Back button
            InkWell(
              onTap: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                } else {
                  goTo(context, '/review-pasar');
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
                      color: Color(0x14000000),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.arrow_back,
                  size: 20,
                  color: Color(0xFF1E293B),
                ),
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
            const SizedBox(
              width: 40,
              height: 40,
            ), // Spacer for center alignment
          ],
        ),
      ),
    );
  }

  // --- CARD 1: MARKET IDENTITY CARD ---
  Widget _buildMarketIdentityCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFC2DC80).withValues(alpha: 0.60),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12594045),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: const MarketAsset(
              '204f2.png',
              width: 58,
              height: 58,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Badge Pasar Wisata Cagar Budaya
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(9999),
                    border: Border.all(
                      color: const Color(0xFFFBBF24).withValues(alpha: 0.60),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.star, size: 11, color: Color(0xFFB45309)),
                      SizedBox(width: 4),
                      Text(
                        'Pasar Wisata Cagar Budaya',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF92400E),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Pasar Oro-Oro Dowo',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF594045),
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: const [
                    Icon(Icons.star, size: 13, color: Color(0xFFF59E0B)),
                    SizedBox(width: 3),
                    Text(
                      '4.8',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    SizedBox(width: 6),
                    Text(
                      '•',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 11,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '1.240+ ulasan terverifikasi',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF64748B),
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
    );
  }

  // --- CARD 2: STAR RATING SECTION ---
  Widget _buildStarRatingSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFC2DC80).withValues(alpha: 0.60),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12594045),
            blurRadius: 16,
            offset: Offset(0, 4),
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

          // 5 Large Interactive Stars
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
                  child: Icon(
                    Icons.star_rounded,
                    size: 40,
                    color: filled
                        ? const Color(0xFFFBBF24)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),

          // Rating Status Pill
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
                  _ratingLabels[_rating] ??
                      'Sangat Puas! / Sangat Direkomendasikan',
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

  // --- CARD 3: PENILAIAN ASPEK PASAR ---
  Widget _buildAspectChipsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFC2DC80).withValues(alpha: 0.60),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12594045),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PENILAIAN ASPEK PASAR',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E293B),
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 3),
          const Text(
            'Pilih aspek unggulan yang Anda rasakan',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildAspectItem(
                  label: 'Kebersihan',
                  icon: Icons.cleaning_services_outlined,
                  isYellow: true,
                  aspectKey: 'kebersihan',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildAspectItem(
                  label: 'Keramahan',
                  icon: Icons.sentiment_satisfied_alt_rounded,
                  isYellow: false,
                  aspectKey: 'keramahan',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildAspectItem(
                  label: 'Parkir Tertata',
                  icon: Icons.local_parking_rounded,
                  isYellow: false,
                  aspectKey: 'parkir',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildAspectItem(
                  label: 'Kelengkapan\nKomoditas',
                  icon: Icons.shopping_basket_outlined,
                  isYellow: true,
                  aspectKey: 'kelengkapan',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAspectItem({
    required String label,
    required IconData icon,
    required bool isYellow,
    required String aspectKey,
  }) {
    final isSelected = _selectedAspects.contains(aspectKey);
    final bgColor = isSelected
        ? (isYellow ? const Color(0xFFFEF3C7) : const Color(0xFFE2F0C2))
        : Colors.grey.shade50;
    final borderColor = isSelected
        ? (isYellow ? const Color(0xFFF59E0B) : const Color(0xFF84CC16))
        : const Color(0xFFE2E8F0);
    final iconColor = isSelected
        ? (isYellow ? const Color(0xFFD97706) : const Color(0xFF4B6515))
        : const Color(0xFF94A3B8);
    final textColor = isSelected
        ? (isYellow ? const Color(0xFF78350F) : const Color(0xFF1E3A1A))
        : const Color(0xFF64748B);

    return InkWell(
      onTap: () {
        setState(() {
          if (_selectedAspects.contains(aspectKey)) {
            _selectedAspects.remove(aspectKey);
          } else {
            _selectedAspects.add(aspectKey);
          }
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1.2),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: iconColor),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- CARD 4: USER NAME INPUT ---
  Widget _buildUserProfileSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFC2DC80).withValues(alpha: 0.60),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12594045),
            blurRadius: 16,
            offset: Offset(0, 4),
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
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE2F0C2).withValues(alpha: 0.50),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFC2DC80), width: 1.2),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Masukkan Nama',
                      hintStyle: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF64748B).withValues(alpha: 0.8),
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFBBF24),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.check, size: 13, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- CARD 5: STORY / EXPERIENCE INPUT ---
  Widget _buildTextStorySection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFC2DC80).withValues(alpha: 0.60),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12594045),
            blurRadius: 16,
            offset: Offset(0, 4),
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
                ),
              ),
              Text(
                'Maks. 500 karakter',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 105,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7).withValues(alpha: 0.70),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFBBF24), width: 1.2),
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
              }) => null,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 12,
                color: Color(0xFF1E293B),
                height: 1.4,
              ),
              decoration: const InputDecoration(
                hintText: 'Bagikan pengalaman kamu tentang pasar ini...',
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.check, size: 14, color: Color(0xFF10B981)),
                  SizedBox(width: 4),
                  Text(
                    'Ulasan memenuhi syarat kualitas',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF10B981),
                    ),
                  ),
                ],
              ),
              Text(
                '${_experienceController.text.length} / 500',
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- CARD 6: UPLOAD PHOTO SECTION ---
  Widget _buildUploadPhotoSection() {
    final int totalSelected = _photos.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFC2DC80).withValues(alpha: 0.60),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12594045),
            blurRadius: 16,
            offset: Offset(0, 4),
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
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '$totalSelected / 5 Terpilih',
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // + Foto Button
                if (_photos.length < 5) ...[
                  InkWell(
                    onTap: _sending ? null : _pickPhotos,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 90,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7FEE7),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFC2DC80),
                          width: 1.5,
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
                            child: const Icon(
                              Icons.add,
                              size: 18,
                              color: Color(0xFF4B6515),
                            ),
                          ),
                          const SizedBox(height: 5),
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
                ],

                // Picked user photos
                for (int i = 0; i < _photos.length; i++) ...[
                  const SizedBox(width: 10),
                  Stack(
                    children: [
                      Container(
                        width: 90,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFE2E8F0),
                            width: 1,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: _ReviewThumbnail(file: _photos[i]),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: InkWell(
                          onTap: _sending
                              ? null
                              : () => setState(() => _photos.removeAt(i)),
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: const BoxDecoration(
                              color: Color(0x99000000),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 14,
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

  // --- CARD 7: HELPFUL REVIEW BANNER ---
  Widget _buildHelpfulReviewBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE2F0C2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC2DC80), width: 1.2),
      ),
      child: Stack(
        children: [
          // Corner accents (top-right and bottom-right brackets)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFFC2DC80), width: 2),
                  right: BorderSide(color: Color(0xFFC2DC80), width: 2),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFFC2DC80), width: 2),
                  right: BorderSide(color: Color(0xFFC2DC80), width: 2),
                ),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.eco_rounded,
                  color: Color(0xFF4B6515),
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Ulasan Anda Menghidupkan UMKM',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E3A1A),
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Ulasan jujur Anda sangat membantu menjaga kualitas fasilitas pasar dan mendukung 280+ pedagang lokal di Pasar Oro-Oro Dowo.',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF334155),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }

  // --- SUBMIT BUTTON ---
  Widget _buildSubmitButton() {
    return InkWell(
      onTap: _sending ? null : _submit,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFFFBBF24),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF59E0B), width: 1),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFBBF24).withValues(alpha: 0.50),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: _sending
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _uploadStatus ?? 'Mengirim...',
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Kirim Ulasan Pasar',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                ],
              ),
      ),
    );
  }
}

class _ReviewThumbnail extends StatefulWidget {
  const _ReviewThumbnail({required this.file});

  final XFile file;

  @override
  State<_ReviewThumbnail> createState() => _ReviewThumbnailState();
}

class _ReviewThumbnailState extends State<_ReviewThumbnail> {
  Uint8List? _bytes;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant _ReviewThumbnail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.file.path != widget.file.path) {
      _load();
    }
  }

  Future<void> _load() async {
    try {
      final bytes = await widget.file.readAsBytes();
      if (mounted) setState(() => _bytes = bytes);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    if (_bytes == null) {
      return Container(
        color: const Color(0xFFF8FAFC),
        alignment: Alignment.center,
        child: const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Color(0xFF4B6515),
          ),
        ),
      );
    }
    return Image.memory(
      _bytes!,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, __, ___) => Container(
        color: const Color(0xFFF8FAFC),
        alignment: Alignment.center,
        child: const Icon(
          Icons.image_outlined,
          color: Color(0xFF94A3B8),
          size: 24,
        ),
      ),
    );
  }
}
