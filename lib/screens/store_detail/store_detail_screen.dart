import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/market_data.dart';
import '../../widgets/market_ui.dart';

class StoreDetailScreen extends StatefulWidget {
  const StoreDetailScreen({
    this.storeId = 'lumpur-kentang-27',
    super.key,
  });

  final String storeId;

  @override
  State<StoreDetailScreen> createState() => _StoreDetailScreenState();
}

class _StoreDetailScreenState extends State<StoreDetailScreen> {
  StoreData get _store => marketStores.firstWhere(
        (store) => store.id == widget.storeId,
        orElse: () => marketStores.first,
      );

  // Gallery items for store showcase
  final List<String> _galleryImages = [
    '57ebc6396a9c9a99fe9c1886f78f832596a309a6',
    'edee362cc941df058b8f2d89986b262499c4eae1',
    '42901b3e368b616d59728cb167cbca51301cc557',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3EEF1),
      body: SafeArea(
        child: Center(
          child: Container(
            width: 402,
            constraints: const BoxConstraints(maxWidth: 402),
            decoration: const BoxDecoration(
              color: Colors.white,
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(194, 220, 128, 0.25),
                  Color.fromRGBO(194, 220, 128, 0.25),
                ],
              ),
            ),
            child: Stack(
              children: [
                // Scrollable main content
                Positioned.fill(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(top: 66, bottom: 96),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 6),
                          // Hero Store Showcase Banner & Profile Overlay
                          _buildStoreHeroCard(),
                          const SizedBox(height: 16),
                          // Store Heritage & Guarantee Story Card
                          _buildStoryCard(),
                          const SizedBox(height: 16),
                          // Store Atmosphere & Display Gallery
                          _buildAtmosphereGallery(),
                          const SizedBox(height: 16),
                          // Product Catalog Header & Grid
                          _buildProductCatalog(),
                          const SizedBox(height: 16),
                          // Trust & Buyer Guarantee Banner (Reviews)
                          _buildReviewsSection(),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),

                // Top Header Nav Bar
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: _buildHeader(context),
                ),

                // Floating Bottom Navigation Bar (Tab Toko Active)
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 12,
                  child: _buildFloatingBottomNav(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Top Navigation Header ---
  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Color(0xFFEBF5D7), // Soft pastel green background as shown in image
        border: Border(
          bottom: BorderSide(
            color: Color(0x33C2DC80),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Back button
          InkWell(
            onTap: () => goBack(context, fallback: '/toko'),
            borderRadius: BorderRadius.circular(9999),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x12000000),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_back_rounded,
                  size: 20,
                  color: Color(0xFF111C2D),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Title & Status
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _store.name,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111C2D),
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Color(0xFFB5D36B),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'BUKA • KIOS A-12',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                        color: Color(0xFF556B1E),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 40), // Balance back button
        ],
      ),
    );
  }

  // --- 1. Hero Store Showcase Banner & Profile Overlay ---
  Widget _buildStoreHeroCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFF594045),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Image with Badge & Gradient
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: SizedBox(
              height: 192,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://api.builder.io/api/v1/image/assets/TEMP/3f84626ba8ebbd8d7723599ac4859ed33ef84946?width=716',
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      color: const Color(0xFFD8E3FB),
                      child: const Center(
                        child: Icon(Icons.store, size: 64, color: Color(0xFF4B6515)),
                      ),
                    ),
                  ),
                  // Dark bottom gradient overlay
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Color.fromRGBO(0, 0, 0, 0.45),
                        ],
                      ),
                    ),
                  ),
                  // Stall Code Badge
                  Positioned(
                    left: 12,
                    top: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(251, 191, 36, 0.70),
                        borderRadius: BorderRadius.circular(9999),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.05),
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.string(
                            '''<svg width="12" height="11" viewBox="0 0 12 11" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M11.1107 4.69583V9.33333C11.1107 9.65417 10.9965 9.92882 10.768 10.1573C10.5395 10.3858 10.2649 10.5 9.94405 10.5H1.77738C1.45655 10.5 1.18189 10.3858 0.953423 10.1573C0.72495 9.92882 0.610714 9.65417 0.610714 9.33333V4.69583C0.387103 4.49167 0.214534 4.22917 0.093006 3.90833C-0.0285218 3.5875 -0.0309524 3.2375 0.0857143 2.85833L0.698214 0.875C0.775992 0.622222 0.914534 0.413194 1.11384 0.247917C1.31314 0.0826389 1.54405 0 1.80655 0H9.91488C10.1774 0 10.4059 0.0802083 10.6003 0.240625C10.7947 0.401042 10.9357 0.6125 11.0232 0.875L11.6357 2.85833C11.7524 3.2375 11.75 3.58264 11.6284 3.89375C11.5069 4.20486 11.3343 4.47222 11.1107 4.69583V4.69583M7.14405 4.08333C7.40655 4.08333 7.60585 3.9934 7.74196 3.81354C7.87808 3.63368 7.93155 3.43194 7.90238 3.20833L7.58155 1.16667H6.44405V3.325C6.44405 3.52917 6.5121 3.7066 6.64821 3.85729C6.78433 4.00799 6.9496 4.08333 7.14405 4.08333V4.08333M4.51905 4.08333C4.74266 4.08333 4.92495 4.00799 5.06592 3.85729C5.20689 3.7066 5.27738 3.52917 5.27738 3.325V1.16667H4.13988L3.81905 3.20833C3.78016 3.44167 3.8312 3.64583 3.97217 3.82083C4.11314 3.99583 4.29544 4.08333 4.51905 4.08333V4.08333M1.92321 4.08333C2.09821 4.08333 2.25134 4.02014 2.38259 3.89375C2.51384 3.76736 2.59405 3.60694 2.62321 3.4125L2.94405 1.16667H1.80655V1.16667V1.16667L1.22321 3.12083C1.16488 3.31528 1.19648 3.52431 1.31801 3.74792C1.43953 3.97153 1.64127 4.08333 1.92321 4.08333V4.08333M9.79821 4.08333C10.0802 4.08333 10.2843 3.97153 10.4107 3.74792C10.5371 3.52431 10.5663 3.31528 10.4982 3.12083L9.88571 1.16667V1.16667V1.16667H8.77738L9.09821 3.4125C9.12738 3.60694 9.20759 3.76736 9.33884 3.89375C9.47009 4.02014 9.62321 4.08333 9.79821 4.08333V4.08333M1.77738 9.33333H9.94405V9.33333V9.33333V5.22083C9.89544 5.24028 9.86384 5.25 9.84926 5.25C9.83467 5.25 9.81766 5.25 9.79821 5.25C9.53571 5.25 9.30481 5.20625 9.10551 5.11875C8.9062 5.03125 8.70933 4.89028 8.51488 4.69583C8.33988 4.87083 8.14058 5.00694 7.91696 5.10417C7.69335 5.20139 7.45516 5.25 7.20238 5.25C6.93988 5.25 6.6944 5.20139 6.46592 5.10417C6.23745 5.00694 6.03571 4.87083 5.86071 4.69583C5.69544 4.87083 5.50342 5.00694 5.28467 5.10417C5.06592 5.20139 4.83016 5.25 4.57738 5.25C4.29544 5.25 4.04023 5.20139 3.81176 5.10417C3.58328 5.00694 3.38155 4.87083 3.20655 4.69583C3.00238 4.9 2.80064 5.0434 2.60134 5.12604C2.40203 5.20868 2.17599 5.25 1.92321 5.25C1.90377 5.25 1.88189 5.25 1.85759 5.25C1.83328 5.25 1.80655 5.24028 1.77738 5.22083V9.33333V9.33333V9.33333V9.33333M9.94405 9.33333H1.77738V9.33333V9.33333V9.33333C1.80655 9.33333 1.83328 9.33333 1.85759 9.33333C1.88189 9.33333 1.90377 9.33333 1.92321 9.33333C2.17599 9.33333 2.40203 9.33333 2.60134 9.33333C2.80064 9.33333 3.00238 9.33333 3.20655 9.33333C3.29405 9.33333 3.38884 9.33333 3.49092 9.33333C3.59301 9.33333 3.70238 9.33333 3.81905 9.33333C3.93571 9.33333 4.05724 9.33333 4.18363 9.33333C4.31002 9.33333 4.44127 9.33333 4.57738 9.33333C4.70377 9.33333 4.8253 9.33333 4.94196 9.33333C5.05863 9.33333 5.17287 9.33333 5.28467 9.33333C5.39648 9.33333 5.50099 9.33333 5.59821 9.33333C5.69544 9.33333 5.78294 9.33333 5.86071 9.33333C6.03571 9.33333 6.23745 9.33333 6.46592 9.33333C6.6944 9.33333 6.93988 9.33333 7.20238 9.33333C7.32877 9.33333 7.4503 9.33333 7.56696 9.33333C7.68363 9.33333 7.79787 9.33333 7.90967 9.33333C8.02148 9.33333 8.12842 9.33333 8.23051 9.33333C8.33259 9.33333 8.42738 9.33333 8.51488 9.33333C8.70933 9.33333 8.9062 9.33333 9.10551 9.33333C9.30481 9.33333 9.53571 9.33333 9.79821 9.33333C9.81766 9.33333 9.83467 9.33333 9.84926 9.33333C9.86384 9.33333 9.89544 9.33333 9.94405 9.33333V9.33333V9.33333V9.33333V9.33333" fill="#F59E0B"/>
</svg>''',
                            width: 12,
                            height: 11,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'Kios Oro-Oro Dowo',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.4,
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

          // Merchant Info Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar + Store Name + Category
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Floating Avatar Square
                    Container(
                      width: 58,
                      height: 58,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.12),
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          'https://api.builder.io/api/v1/image/assets/TEMP/425379cfc6cc9d4055ada9eb00aa5d46dcdd209e?width=112',
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            color: const Color(0xFFFBBF24),
                            child: const Icon(Icons.bakery_dining, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _store.name,
                            style: const TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                              color: Color(0xFF111C2D),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _store.category,
                            style: const TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.24,
                              color: Color(0xFF594045),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Quick Stats & Ratings
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(194, 220, 128, 0.80),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color.fromRGBO(234, 156, 175, 0.20),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Stat 1: Rating
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.string(
                                  '''<svg width="14" height="13" viewBox="0 0 14 13" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M2.55 12.6667L3.63333 7.98333L0 4.83333L4.8 4.41667L6.66667 0L8.53333 4.41667L13.3333 4.83333L9.7 7.98333L10.7833 12.6667L6.66667 10.1833L2.55 12.6667V12.6667" fill="#F59E0B"/>
</svg>''',
                                  width: 14,
                                  height: 13,
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  '4.9',
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF111C2D),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              '180+ Ulasan',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF594045),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(height: 24, width: 1, color: Colors.black12),
                      // Stat 2: Operational Hours
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.string(
                                  '''<svg width="14" height="14" viewBox="0 0 14 14" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M8.86667 9.8L9.8 8.86667L7.33333 6.4V3.33333H6V6.93333L8.86667 9.8V9.8M6.66667 13.3333C5.74444 13.3333 4.87778 13.1583 4.06667 12.8083C3.25556 12.4583 2.55 11.9833 1.95 11.3833C1.35 10.7833 0.875 10.0778 0.525 9.26667C0.175 8.45555 0 7.58889 0 6.66667C0 5.74444 0.175 4.87778 0.525 4.06667C0.875 3.25556 1.35 2.55 1.95 1.95C2.55 1.35 3.25556 0.875 4.06667 0.525C4.87778 0.175 5.74444 0 6.66667 0C7.58889 0 8.45555 0.175 9.26667 0.525C10.0778 0.875 10.7833 1.35 11.3833 1.95C11.9833 2.55 12.4583 3.25556 12.8083 4.06667C13.1583 4.87778 13.3333 5.74444 13.3333 6.66667C13.3333 7.58889 13.1583 8.45555 12.8083 9.26667C12.4583 10.0778 11.9833 10.7833 11.3833 11.3833C10.7833 11.9833 10.0778 12.4583 9.26667 12.8083C8.45555 13.1583 7.58889 13.3333 6.66667 13.3333V13.3333M6.66667 6.66667V6.66667V6.66667V6.66667V6.66667V6.66667V6.66667V6.66667V6.66667V6.66667M6.66667 12C8.14444 12 9.40278 11.4806 10.4417 10.4417C11.4806 9.40278 12 8.14444 12 6.66667C12 5.18889 11.4806 3.93056 10.4417 2.89167C9.40278 1.85278 8.14444 1.33333 6.66667 1.33333C5.18889 1.33333 3.93056 1.85278 2.89167 2.89167C1.85278 3.93056 1.33333 5.18889 1.33333 6.66667C1.33333 8.14444 1.85278 9.40278 2.89167 10.4417C3.93056 11.4806 5.18889 12 6.66667 12V12" fill="#556B18"/>
</svg>''',
                                  width: 14,
                                  height: 14,
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  '06.00',
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF111C2D),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Tutup 17.00',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF594045),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(height: 24, width: 1, color: Colors.black12),
                      // Stat 3: Guaranteed Product
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.string(
                                  '''<svg width="11" height="14" viewBox="0 0 11 14" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M4.63333 9.03333L8.4 5.26667L7.45 4.31667L4.63333 7.13333L3.23333 5.73333L2.28333 6.68333L4.63333 9.03333V9.03333M5.33333 13.3333C3.78889 12.9444 2.51389 12.0583 1.50833 10.675C0.502778 9.29167 0 7.75556 0 6.06667V2L5.33333 0L10.6667 2V6.06667C10.6667 7.75556 10.1639 9.29167 9.15833 10.675C8.15278 12.0583 6.87778 12.9444 5.33333 13.3333V13.3333M5.33333 11.9333C6.48889 11.5667 7.44444 10.8333 8.2 9.73333C8.95555 8.63333 9.33333 7.41111 9.33333 6.06667V2.91667L5.33333 1.41667L1.33333 2.91667V6.06667C1.33333 7.41111 1.71111 8.63333 2.46667 9.73333C3.22222 10.8333 4.17778 11.5667 5.33333 11.9333V11.9333M5.33333 6.66667V6.66667V6.66667V6.66667V6.66667V6.66667V6.66667V6.66667V6.66667V6.66667" fill="#FBBF24"/>
</svg>''',
                                  width: 11,
                                  height: 14,
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  '100%',
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF111C2D),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Produk Asli',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF594045),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Location Pin Callout
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(194, 220, 128, 0.20),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.string(
                        '''<svg width="11" height="15" viewBox="0 0 11 15" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M5.25 10.8562C6.4875 9.85625 7.42188 8.89375 8.05313 7.96875C8.68438 7.04375 9 6.175 9 5.3625C9 4.2375 8.65 3.3125 7.95 2.5875C7.25 1.8625 6.35 1.5 5.25 1.5C4.15 1.5 3.25 1.8625 2.55 2.5875C1.85 3.3125 1.5 4.2375 1.5 5.3625C1.5 6.175 1.81563 7.04375 2.44688 7.96875C3.07812 8.89375 4.0125 9.85625 5.25 10.8562V10.8562M5.25 12.75C3.4875 11.45 2.17188 10.1875 1.30313 8.9625C0.434375 7.7375 0 6.5375 0 5.3625C0 3.8 0.4875 2.51562 1.4625 1.50937C2.4375 0.503125 3.7 0 5.25 0C6.8 0 8.0625 0.503125 9.0375 1.50937C10.0125 2.51562 10.5 3.8 10.5 5.3625C10.5 6.5375 10.0656 7.7375 9.19687 8.9625C8.32812 10.1875 7.0125 11.45 5.25 12.75V12.75M5.25 6.75C5.6625 6.75 6.01562 6.60312 6.30937 6.30937C6.60312 6.01562 6.75 5.6625 6.75 5.25C6.75 4.8375 6.60312 4.48438 6.30937 4.19063C6.01562 3.89688 5.6625 3.75 5.25 3.75C4.8375 3.75 4.48438 3.89688 4.19063 4.19063C3.89688 4.48438 3.75 4.8375 3.75 5.25C3.75 5.6625 3.89688 6.01562 4.19063 6.30937C4.48438 6.60312 4.8375 6.75 5.25 6.75V6.75M0 15V13.5H10.5V15H0V15M5.25 5.25V5.25V5.25V5.25V5.25V5.25V5.25V5.25V5.25V5.25" fill="#F59E0B"/>
</svg>''',
                        width: 11,
                        height: 15,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Pasar Oro-Oro Dowo, Blok A No. 12, Klojen, Kota Malang',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF111C2D),
                            height: 1.33,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Quick Action Button: Hubungi Penjual
                InkWell(
                  onTap: () async {
                    final uri = Uri.parse('https://wa.me/6281234567890?text=Halo%20Lumpur%20Kentang%2027,%20saya%20ingin%20tanya%20produk');
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBBF24),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(213, 105, 137, 0.28),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.string(
                          '''<svg width="15" height="15" viewBox="0 0 15 15" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M3 9H9V7.5H3V9V9M3 6.75H12V5.25H3V6.75V6.75M3 4.5H12V3H3V4.5V4.5M0 15V1.5C0 1.0875 0.146875 0.734375 0.440625 0.440625C0.734375 0.146875 1.0875 0 1.5 0H13.5C13.9125 0 14.2656 0.146875 14.5594 0.440625C14.8531 0.734375 15 1.0875 15 1.5V10.5C15 10.9125 14.8531 11.2656 14.5594 11.5594C14.2656 11.8531 13.9125 12 13.5 12H3L0 15V15M2.3625 10.5H13.5V10.5V10.5V1.5V1.5V1.5H1.5V1.5V1.5V11.3438L2.3625 10.5V10.5M1.5 10.5V10.5V1.5V1.5V1.5V1.5V1.5V1.5V10.5V10.5V10.5V10.5V10.5" fill="white"/>
</svg>''',
                          width: 15,
                          height: 15,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Hubungi Penjual',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.24,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 2. Store Heritage & Guarantee Story Card ---
  Widget _buildStoryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFF594045),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  SvgPicture.string(
                    '''<svg width="15" height="14" viewBox="0 0 15 14" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M0.833333 1.66667V0H14.1667V1.66667H0.833333V1.66667M0.833333 13.3333V8.33333H0V6.66667L0.833333 2.5H14.1667L15 6.66667V8.33333H14.1667V13.3333H12.5V8.33333H9.16667V13.3333H0.833333V13.3333M2.5 11.6667H7.5V8.33333H2.5V11.6667V11.6667M1.70833 6.66667V6.66667H13.2917V6.66667H1.70833V6.66667M1.70833 6.66667H13.2917L12.7917 4.16667H2.20833L1.70833 6.66667V6.66667" fill="#F59E0B"/>
</svg>''',
                    width: 15,
                    height: 14,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Tentang Kios Kami',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111C2D),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBBF24),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: const Text(
                  'Sejak 2012',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Lumpur Kentang Wolak Walik 27 adalah lapak kuliner legendaris dan viral di Pasar Rakyat Oro-oro Dowo, Kota Malang, yang menyajikan kue lumpur tradisional berbahan dasar kentang dengan tekstur sangat lembut dan wangi khas.',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF594045),
              height: 1.62,
            ),
          ),
        ],
      ),
    );
  }

  // --- 3. Store Atmosphere & Display Gallery ---
  Widget _buildAtmosphereGallery() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Suasana Kios & Etalase',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111C2D),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Langsung dari lorong Blok A Pasar Oro-Oro Dowo',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF594045),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                const Text(
                  'Lihat Semua',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF594045),
                  ),
                ),
                const SizedBox(width: 4),
                SvgPicture.string(
                  '''<svg width="5" height="8" viewBox="0 0 5 8" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M3.06667 4L0 0.933333L0.933333 0L4.93333 4L0.933333 8L0 7.06667L3.06667 4V4" fill="#594045"/>
</svg>''',
                  width: 5,
                  height: 8,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Gallery Grid (3 items row with +6 Foto overlay on 3rd)
        Row(
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    'https://api.builder.io/api/v1/image/assets/TEMP/${_galleryImages[0]}?width=228',
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(color: const Color(0xFFD8E3FB)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    'https://api.builder.io/api/v1/image/assets/TEMP/${_galleryImages[1]}?width=228',
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(color: const Color(0xFFD8E3FB)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        'https://api.builder.io/api/v1/image/assets/TEMP/${_galleryImages[2]}?width=228',
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(color: const Color(0xFFD8E3FB)),
                      ),
                      Container(
                        color: const Color.fromRGBO(0, 0, 0, 0.40),
                        child: const Center(
                          child: Text(
                            '+6 Foto',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.24,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- 4. Product Catalog Header & 2-Column Grid ---
  Widget _buildProductCatalog() {
    // 5 products from Figma design
    final products = [
      (
        name: 'Kismis',
        desc: 'Rasanya Enak',
        price: 'Rp 7.000',
        rating: '4.9',
        reviews: '(92)',
        isBestSeller: false,
        imgUrl: 'https://api.builder.io/api/v1/image/assets/TEMP/21b4c2ec08c13f5b8d044fe28f748385fda57c9f?width=294',
      ),
      (
        name: 'keju',
        desc: 'Rasanya Enak',
        price: 'Rp 7.000',
        rating: '5.0',
        reviews: '(45)',
        isBestSeller: true,
        imgUrl: 'https://api.builder.io/api/v1/image/assets/TEMP/360cecd29a4db8b153e24126ea1b3790b28fe2c8?width=294',
      ),
      (
        name: 'kelapa',
        desc: 'Rasanya Enak',
        price: 'Rp 7.000',
        rating: '4.8',
        reviews: '(31)',
        isBestSeller: false,
        imgUrl: 'https://api.builder.io/api/v1/image/assets/TEMP/5d35cd7ab75926c8c87e84cb2d4e6f66d7a2ce13?width=294',
      ),
      (
        name: 'Bikang Suji',
        desc: 'Rasanya Enak',
        price: 'Rp 4.000',
        rating: '4.9',
        reviews: '(19)',
        isBestSeller: false,
        imgUrl: 'https://api.builder.io/api/v1/image/assets/TEMP/10471f540d1e6ace767beefb3d34cd99a98a0c89?width=294',
      ),
      (
        name: 'Lemper Ayam',
        desc: 'Rasanya Enak',
        price: 'Rp 7.000',
        rating: '4.9',
        reviews: '(92)',
        isBestSeller: false,
        imgUrl: 'https://api.builder.io/api/v1/image/assets/TEMP/94c69679b89de043e1cf782342cf4a13b4bea560?width=294',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.string(
                  '''<svg width="18" height="19" viewBox="0 0 18 19" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M3.20833 8.25L8.25 0L13.2917 8.25H3.20833V8.25M13.2917 18.3333C12.1458 18.3333 11.1719 17.9323 10.3698 17.1302C9.56771 16.3281 9.16667 15.3542 9.16667 14.2083C9.16667 13.0625 9.56771 12.0885 10.3698 11.2865C11.1719 10.4844 12.1458 10.0833 13.2917 10.0833C14.4375 10.0833 15.4115 10.4844 16.2135 11.2865C17.0156 12.0885 17.4167 13.0625 17.4167 14.2083C17.4167 15.3542 17.0156 16.3281 16.2135 17.1302C15.4115 17.9323 14.4375 18.3333 13.2917 18.3333V18.3333M0 17.875V10.5417H7.33333V17.875H0V17.875M13.2917 16.5C13.9333 16.5 14.4757 16.2785 14.9187 15.8354C15.3618 15.3924 15.5833 14.85 15.5833 14.2083C15.5833 13.5667 15.3618 13.0243 14.9187 12.5813C14.4757 12.1382 13.9333 11.9167 13.2917 11.9167C12.65 11.9167 12.1076 12.1382 11.6646 12.5813C11.2215 13.0243 11 13.5667 11 14.2083C11 14.85 11.2215 15.3924 11.6646 15.8354C12.1076 16.2785 12.65 16.5 13.2917 16.5V16.5M1.83333 16.0417H5.5V12.375H1.83333V16.0417V16.0417M6.4625 6.41667H10.0375L8.25 3.52917L6.4625 6.41667V6.41667M8.25 6.41667V6.41667V6.41667V6.41667V6.41667M5.5 12.375V12.375V12.375V12.375V12.375V12.375M13.2917 14.2083V14.2083V14.2083V14.2083V14.2083V14.2083V14.2083V14.2083V14.2083V14.2083" fill="#F59E0B"/>
</svg>''',
                  width: 18,
                  height: 19,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Katalog Produk Kios',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111C2D),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFFBBF24),
                borderRadius: BorderRadius.circular(9999),
              ),
              child: const Text(
                '5 Pilihan',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // 2-Column Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 173 / 290,
          ),
          itemBuilder: (context, index) {
            final item = products[index];
            return Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFBBF24), width: 1),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.05),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image with optional Terlaris badge
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F3FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              item.imgUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => const Center(
                                child: Icon(Icons.fastfood, color: Color(0xFFFBBF24)),
                              ),
                            ),
                          ),
                        ),
                        if (item.isBestSeller)
                          Positioned(
                            left: 8,
                            top: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFC2DC80),
                                borderRadius: BorderRadius.circular(9999),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.05),
                                    blurRadius: 2,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: const Text(
                                'Terlaris',
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF283700),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Rating row
                  Row(
                    children: [
                      SvgPicture.string(
                        '''<svg width="12" height="12" viewBox="0 0 12 12" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M2.23125 11.0833L3.17917 6.98542L0 4.22917L4.2 3.86458L5.83333 0L7.46667 3.86458L11.6667 4.22917L8.4875 6.98542L9.43542 11.0833L5.83333 8.91042L2.23125 11.0833V11.0833" fill="#D56989"/>
</svg>''',
                        width: 12,
                        height: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.rating,
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF111C2D),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.reviews,
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF594045),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Product Title
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111C2D),
                    ),
                  ),

                  // Product Short Desc
                  Text(
                    item.desc,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF594045),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Divider & Price
                  Container(
                    padding: const EdgeInsets.only(top: 6),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Color.fromRGBO(240, 243, 255, 0.80),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          item.price,
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFF59E0B),
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 2),
                          child: Text(
                            '/pcs',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF594045),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // --- 5. Trust & Buyer Guarantee Banner (Reviews) ---
  Widget _buildReviewsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color.fromRGBO(224, 190, 196, 0.30),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with + Tulis Ulasan button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.string(
                    '''<svg width="19" height="19" viewBox="0 0 19 19" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M3.66667 11H6.4625L11.0458 6.41667C11.1833 6.27917 11.2865 6.12257 11.3552 5.94688C11.424 5.77118 11.4583 5.59931 11.4583 5.43125C11.4583 5.26319 11.4201 5.09896 11.3438 4.93854C11.2674 4.77813 11.1681 4.62917 11.0458 4.49167L10.2208 3.62083C10.0833 3.48333 9.93056 3.38021 9.7625 3.31146C9.59444 3.24271 9.41875 3.20833 9.23542 3.20833C9.06736 3.20833 8.89549 3.24271 8.71979 3.31146C8.5441 3.38021 8.3875 3.48333 8.25 3.62083L3.66667 8.20417V11V11M10.0833 5.43125V5.43125L9.23542 4.58333V4.58333L10.0833 5.43125V5.43125M5.04167 9.625V8.75417L7.35625 6.43958L7.81458 6.85208L8.22708 7.31042L5.9125 9.625H5.04167V9.625M7.81458 6.85208L8.22708 7.31042V7.31042L7.35625 6.43958V6.43958L7.81458 6.85208V6.85208M8.41042 11H14.6667V9.16667H10.2437L8.41042 11V11M0 18.3333V1.83333C0 1.32917 0.179514 0.897569 0.538542 0.538542C0.897569 0.179514 1.32917 0 1.83333 0H16.5C17.0042 0 17.4358 0.179514 17.7948 0.538542C18.1538 0.897569 18.3333 1.32917 18.3333 1.83333V12.8333C18.3333 13.3375 18.1538 13.7691 17.7948 14.1281C17.4358 14.4872 17.0042 14.6667 16.5 14.6667H3.66667L0 18.3333V18.3333M2.8875 12.8333H16.5V12.8333V12.8333V1.83333V1.83333V1.83333H1.83333V1.83333V1.83333V13.8646L2.8875 12.8333V12.8333M1.83333 12.8333V12.8333V1.83333V1.83333V1.83333V1.83333V1.83333V1.83333V12.8333V12.8333V12.8333V12.8333V12.8333" fill="#4B6515"/>
</svg>''',
                    width: 19,
                    height: 19,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Ulasan Toko &\nPembeli',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111C2D),
                      height: 1.25,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => goTo(context, '/tulis-ulasan-toko'),
                borderRadius: BorderRadius.circular(9999),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBBF24),
                    borderRadius: BorderRadius.circular(9999),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.05),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      SvgPicture.string(
                        '''<svg width="12" height="12" viewBox="0 0 12 12" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M1.25 10H2.14062L8.25 3.89062L7.35938 3L1.25 9.10938V10V10M0 11.25V8.59375L8.25 0.359375C8.375 0.244792 8.51302 0.15625 8.66406 0.09375C8.8151 0.03125 8.97396 0 9.14062 0C9.30729 0 9.46875 0.03125 9.625 0.09375C9.78125 0.15625 9.91667 0.25 10.0312 0.375L10.8906 1.25C11.0156 1.36458 11.1068 1.5 11.1641 1.65625C11.2214 1.8125 11.25 1.96875 11.25 2.125C11.25 2.29167 11.2214 2.45052 11.1641 2.60156C11.1068 2.7526 11.0156 2.89062 10.8906 3.01562L2.65625 11.25H0V11.25M10 2.125V2.125L9.125 1.25V1.25L10 2.125V2.125M7.79688 3.45312L7.35938 3V3L8.25 3.89062V3.89062L7.79688 3.45312V3.45312" fill="white"/>
</svg>''',
                        width: 12,
                        height: 12,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        '+ Tulis Ulasan',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Rating Highlights Box
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(251, 191, 36, 0.25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.05),
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          SvgPicture.string(
                            '''<svg width="15" height="15" viewBox="0 0 15 15" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M2.86875 14.25L4.0875 8.98125L0 5.4375L5.4 4.96875L7.5 0L9.6 4.96875L15 5.4375L10.9125 8.98125L12.1313 14.25L7.5 11.4563L2.86875 14.25V14.25" fill="#F59E0B"/>
</svg>''',
                            width: 15,
                            height: 15,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            '4.9',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF111C2D),
                            ),
                          ),
                          const Text(
                            '/5.0',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF594045),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '180+ Ulasan Pembeli',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111C2D),
                          ),
                        ),
                        Text(
                          '98% Pembeli Puas',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF485C13),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // 5 stars
                Row(
                  children: List.generate(
                    5,
                    (_) => Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: SvgPicture.string(
                        '''<svg width="14" height="13" viewBox="0 0 14 13" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M2.55 12.6667L3.63333 7.98333L0 4.83333L4.8 4.41667L6.66667 0L8.53333 4.41667L13.3333 4.83333L9.7 7.98333L10.7833 12.6667L6.66667 10.1833L2.55 12.6667V12.6667" fill="#F59E0B"/>
</svg>''',
                        width: 14,
                        height: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Review 1: Ibu Maya Lestari
          _buildReviewItem(
            name: 'Ibu Maya Lestari',
            time: '2 hari lalu • Pembeli Terverifikasi',
            text: '“Bahan katun adem banget, jahitan rapi! Pengiriman lewat kurir pasar cepat sampai dalam 25 menit. Bu Serli juga ramah sekali pas ditanya ukuran via chat.”',
          ),
          const SizedBox(height: 10),

          // Review 2: Dimas Priyambodo
          _buildReviewItem(
            name: 'Dimas Priyambodo',
            time: '1 minggu lalu • Pembeli Terverifikasi',
            text: '“Kemeja linen santai kualitasnya jempolan, warna sesuai foto etalase. Pilihan belanja terpercaya di Pasar Oro-Oro Dowo.”',
          ),
          const SizedBox(height: 12),

          // Action Button: Lihat Semua Ulasan
          InkWell(
            onTap: () => goTo(context, '/review-pasar'),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Lihat Semua 180+ Ulasan Toko',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.24,
                    color: Color(0xFFFBBF24),
                  ),
                ),
                const SizedBox(width: 4),
                SvgPicture.string(
                  '''<svg width="12" height="12" viewBox="0 0 12 12" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M9.13125 6.75H0V5.25H9.13125L4.93125 1.05L6 0L12 6L6 12L4.93125 10.95L9.13125 6.75V6.75" fill="#FBBF24"/>
</svg>''',
                  width: 12,
                  height: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Review Card Builder ---
  Widget _buildReviewItem({
    required String name,
    required String time,
    required String text,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(194, 220, 128, 0.35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color.fromRGBO(194, 220, 128, 0.80),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111C2D),
                    ),
                  ),
                  Text(
                    time,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF594045),
                    ),
                  ),
                ],
              ),
              Row(
                children: List.generate(
                  5,
                  (_) => Padding(
                    padding: const EdgeInsets.only(left: 1.5),
                    child: SvgPicture.string(
                      '''<svg width="11" height="11" viewBox="0 0 11 11" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M2.07188 10.2917L2.95208 6.48646L0 3.92708L3.9 3.58854L5.41667 0L6.93333 3.58854L10.8333 3.92708L7.88125 6.48646L8.76146 10.2917L5.41667 8.27396L2.07188 10.2917V10.2917" fill="#F59E0B"/>
</svg>''',
                      width: 11,
                      height: 11,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            text,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFF594045),
              height: 1.37,
            ),
          ),
        ],
      ),
    );
  }

  // --- Floating Bottom Navigation Bar (Tab Toko Active) ---
  Widget _buildFloatingBottomNav(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: const Color(0xFFC2DC80), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(213, 105, 137, 0.15),
            blurRadius: 25,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Home Tab
          InkWell(
            onTap: () => goTo(context, '/home'),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 32,
                  height: 32,
                  child: Center(
                    child: SvgPicture.string(
                      '''<svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M10 14V8.66667C10 8.29872 9.70128 8 9.33333 8H6.66667C6.29872 8 6 8.29872 6 8.66667V14" stroke-width="1.33333" stroke-linecap="round" stroke-linejoin="round" stroke="#6B7280"/>
<path d="M2 6.66666C1.99991 6.27408 2.17283 5.90141 2.47267 5.64799L7.13933 1.64799C7.63626 1.22801 8.36374 1.22801 8.86067 1.64799L13.5273 5.64799C13.8272 5.90141 14.0001 6.27408 14 6.66666V12.6667C14 13.4025 13.4026 14 12.6667 14H3.33333C2.59745 14 2 13.4025 2 12.6667V6.66666" stroke-width="1.33333" stroke-linecap="round" stroke-linejoin="round" stroke="#6B7280"/>
</svg>''',
                      width: 16,
                      height: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Home',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),

          // Toko Tab (ACTIVE)
          InkWell(
            onTap: () => goTo(context, '/toko'),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(194, 220, 128, 0.50),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Center(
                    child: SvgPicture.string(
                      '''<svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M12.5 17.5V13.3333C12.5 12.8731 12.1269 12.5 11.6667 12.5H8.33333C7.8731 12.5 7.5 12.8731 7.5 13.3333V17.5" stroke-width="1.66667" stroke-linecap="round" stroke-linejoin="round" stroke="#4B6515"/>
<path d="M14.8119 8.59175C14.4509 8.24624 13.8819 8.24624 13.521 8.59175C12.7161 9.35947 11.4501 9.35947 10.6452 8.59175C10.2844 8.24677 9.716 8.24677 9.35519 8.59175C8.55018 9.36 7.28353 9.36 6.47852 8.59175C6.1176 8.24624 5.54861 8.24624 5.18769 8.59175C4.41219 9.33178 3.20171 9.36256 2.38961 8.6629C1.57751 7.96324 1.42887 6.76153 2.04602 5.88508L4.45352 2.39841C4.76369 1.94073 5.28064 1.66665 5.83352 1.66675H14.1669C14.7181 1.66654 15.2337 1.93888 15.5444 2.39425L17.9569 5.88758C18.5742 6.76476 18.4246 7.9673 17.6112 8.66649C16.7977 9.36568 15.5864 9.33381 14.8119 8.59175Z" stroke-width="1.66667" stroke-linecap="round" stroke-linejoin="round" stroke="#4B6515"/>
<path d="M3.3335 9.125V15.8333C3.3335 16.7538 4.07969 17.5 5.00016 17.5H15.0002C15.9206 17.5 16.6668 16.7538 16.6668 15.8333V9.125" stroke-width="1.66667" stroke-linecap="round" stroke-linejoin="round" stroke="#4B6515"/>
</svg>''',
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Toko',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF4B6515),
                  ),
                ),
              ],
            ),
          ),

          // Promo Tab
          InkWell(
            onTap: () => goTo(context, '/promo'),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 32,
                  height: 32,
                  child: Center(
                    child: SvgPicture.string(
                      '''<svg width="23" height="23" viewBox="0 0 23 23" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M16.9213 17.8795C13.9273 20.8735 9.07303 20.8735 6.07901 17.8795C4.582 16.3825 3.8335 14.4204 3.8335 12.4583C3.83349 10.4963 4.582 8.53418 6.07901 7.03717C6.07901 7.03717 6.70854 8.62496 8.62521 9.58329C8.62521 7.66662 9.10437 4.79162 11.4866 2.875C13.4168 4.79167 15.4209 5.53672 16.9213 7.03717C18.4183 8.53418 19.1668 10.4963 19.1668 12.4583C19.1668 14.4204 18.4183 16.3825 16.9213 17.8795ZM13.5331 15.4496C12.4103 16.5723 10.59 16.5723 9.46723 15.4496C8.90586 14.8882 8.62517 14.1524 8.62516 13.4167L10.5418 13.4166L11.5141 10.5417C12.2452 10.5452 12.9753 10.8259 13.5331 11.3837C14.0945 11.9451 14.3752 12.6809 14.3752 13.4167C14.3752 14.1524 14.0945 14.8882 13.5331 15.4496Z" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" stroke="#6B7280"/>
</svg>''',
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Promo',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),

          // Review Pasar Tab
          InkWell(
            onTap: () => goTo(context, '/review-pasar'),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 32,
                  height: 32,
                  child: Center(
                    child: SvgPicture.string(
                      '''<svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M5.96647 12H8.7623L13.3456 7.41667C13.4831 7.27917 13.5863 7.12257 13.655 6.94688C13.7238 6.77118 13.7581 6.59931 13.7581 6.43125C13.7581 6.26319 13.7199 6.09896 13.6436 5.93854C13.5672 5.77813 13.4679 5.62917 13.3456 5.49167L12.5206 4.62083C12.3831 4.48333 12.2304 4.38021 12.0623 4.31146C11.8942 4.24271 11.7186 4.20833 11.5352 4.20833C11.3672 4.20833 11.1953 4.24271 11.0196 4.31146C10.8439 4.38021 10.6873 4.48333 10.5498 4.62083L5.96647 9.20417V12V12M12.3831 6.43125V6.43125L11.5352 5.58333V5.58333L12.3831 6.43125V6.43125M7.34147 10.625V9.75417L9.65605 7.43958L10.1144 7.85208L10.5269 8.31042L8.2123 10.625H7.34147V10.625M10.1144 7.85208L10.5269 8.31042V8.31042L9.65605 7.43958V7.43958L10.1144 7.85208V7.85208M10.7102 12H16.9665V10.1667H12.5436L10.7102 12V12M2.2998 19.3333V2.83333C2.2998 2.32917 2.47932 1.89757 2.83835 1.53854C3.19737 1.17951 3.62897 1 4.13314 1H18.7998C19.304 1 19.7356 1.17951 20.0946 1.53854C20.4536 1.89757 20.6331 2.32917 20.6331 2.83333V13.8333C20.6331 14.3375 20.4536 14.7691 20.0946 15.1281C19.7356 15.4872 19.304 15.6667 18.7998 15.6667H5.96647L2.2998 19.3333V19.3333M5.1873 13.8333H18.7998V13.8333V13.8333V2.83333V2.83333V2.83333H4.13314V2.83333V2.83333V14.8646L5.1873 13.8333V13.8333M4.13314 13.8333V13.8333V2.83333V2.83333V2.83333V2.83333V2.83333V2.83333V13.8333V13.8333V13.8333V13.8333V13.8333" fill="#6B7280"/>
</svg>''',
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Review Pasar',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
