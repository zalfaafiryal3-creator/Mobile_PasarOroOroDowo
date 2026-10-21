import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../widgets/market_ui.dart';

class MarketFacilitiesScreen extends StatelessWidget {
  const MarketFacilitiesScreen({super.key});

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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 6),
                          // Section 1: Hero Card
                          _buildHeroCard(),
                          const SizedBox(height: 16),
                          // Section 2: Facilities Grid & Parking Banner Card
                          _buildFacilitiesCard(),
                          const SizedBox(height: 14),
                          // Section 3: SNI Banner / Badge
                          _buildSniBanner(),
                          const SizedBox(height: 16),
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

                // Floating Bottom Navigation Bar
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
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        border: const Border(
          bottom: BorderSide(color: Color.fromRGBO(194, 220, 128, 0.25)),
        ),
      ),
      child: Row(
        children: [
          // Back button
          InkWell(
            onTap: () => goBack(context),
            borderRadius: BorderRadius.circular(9999),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.05),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Center(
                child: SvgPicture.string(
                  '''<svg width="14" height="14" viewBox="0 0 14 14" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M3.1875 7.5L7.85417 12.1667L6.66667 13.3333L0 6.66667L6.66667 0L7.85417 1.16667L3.1875 5.83333H13.3333V7.5H3.1875V7.5" fill="#111C2D"/>
</svg>''',
                  width: 14,
                  height: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Title and Location Subtitle
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Fasilitas Pasar',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.4,
                    color: Color(0xFF594045),
                    height: 1.5,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.string(
                      '''<svg width="10" height="12" viewBox="0 0 10 12" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M4.78524 11.4891C4.63983 11.4891 4.495 11.4637 4.35075 11.4127C4.2065 11.3618 4.07742 11.2854 3.9635 11.1835C3.3176 10.5932 2.74695 10.0198 2.25154 9.46332C1.75613 8.90683 1.34267 8.36619 1.01116 7.8414C0.679657 7.31661 0.428253 6.80836 0.256952 6.31665C0.0856507 5.82494 0 5.3487 0 4.88796C0 3.39707 0.481303 2.20969 1.44391 1.32582C2.40652 0.441939 3.52029 0 4.78524 0C6.05018 0 7.16396 0.441939 8.12657 1.32582C9.08917 2.20969 9.57048 3.39707 9.57048 4.88796C9.57048 5.3487 9.48483 5.82494 9.31352 6.31665C9.14222 6.80836 8.89082 7.31661 8.55931 7.8414C8.22781 8.36619 7.81435 8.90683 7.31894 9.46332C6.82352 10.0198 6.25287 10.5932 5.60698 11.1835C5.49306 11.2854 5.36398 11.3618 5.21973 11.4127C5.07548 11.4637 4.93065 11.4891 4.78524 11.4891V11.4891M4.78524 5.98678C5.1177 5.98678 5.40107 5.86964 5.63535 5.63535C5.86964 5.40107 5.98678 5.1177 5.98678 4.78524C5.98678 4.45278 5.86964 4.16941 5.63535 3.93512C5.40107 3.70084 5.1177 3.5837 4.78524 3.5837C4.45278 3.5837 4.16941 3.70084 3.93512 3.93512C3.70084 4.16941 3.5837 4.45278 3.5837 4.78524C3.5837 5.1177 3.70084 5.40107 3.93512 5.63535C4.16941 5.86964 4.45278 5.98678 4.78524 5.98678V5.98678" fill="#4B6515"/>
</svg>''',
                      width: 10,
                      height: 12,
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Pasar Oro-Oro Dowo, Malang',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4B6515),
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

  // --- Hero Card ---
  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color.fromRGBO(254, 215, 205, 0.60),
          width: 1,
        ),
        gradient: const LinearGradient(
          colors: [
            Color.fromRGBO(194, 220, 128, 0.70),
            Color(0xFFFBBF24),
            Color(0xFFC2DC80),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.5, 1.0],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(89, 64, 69, 0.25),
            blurRadius: 25,
            spreadRadius: -3,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Decorative background petal 1
            Positioned(
              right: -23,
              bottom: -23,
              child: Container(
                width: 112,
                height: 112,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(222, 59, 117, 0.10),
                ),
              ),
            ),
            // Decorative background petal 2
            Positioned(
              left: -15,
              top: -15,
              child: Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(251, 191, 36, 0.15),
                ),
              ),
            ),

            // Hero Card Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status pill: Cagar Budaya SNI
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(9999),
                      border: Border.all(
                        color: const Color(0xFFC2DC80),
                        width: 1,
                      ),
                    ),
                    child: const Text(
                      'Cagar Budaya SNI',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF4B6515),
                        letterSpacing: 0.275,
                      ),
                    ),
                  ),
                  const SizedBox(height: 11),

                  // Heading
                  const Text(
                    'Kenyamanan Berbelanja Modern',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                      color: Color(0xFF111C2D),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Subtitle
                  const Text(
                    'Standar kebersihan prima berpadu nuansa arsitektur kolonial cagar budaya sejak 1932. Terbuka, ramah, dan inklusif untuk seluruh warga.',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF4B5563),
                      height: 1.33,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Quick Metrics Bar
                  Container(
                    padding: const EdgeInsets.only(top: 8.7),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Color(0xFFFFE4E6), width: 1),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildMetricItem(
                            '12+ Sarana',
                            'Lengkap &\nTerawat',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildMetricItem(
                            '100% Inklusif',
                            'Ramah \nDisabilitas',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildMetricItem(
                            'Higienis',
                            'Sanitasi \nTiap Hari',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Metric Pill ---
  Widget _buildMetricItem(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.80),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF4B6515), width: 1),
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.24,
              color: Color(0xFF111C2D),
              height: 1.33,
            ),
          ),
          const SizedBox(height: 5.5),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: Color(0xFF9CA3AF),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // --- Section 4: Facilities Card & Grid ---
  Widget _buildFacilitiesCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF594045), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(89, 64, 69, 0.15),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
          BoxShadow(
            color: Color.fromRGBO(89, 64, 69, 0.08),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header of Facilities
          Container(
            padding: const EdgeInsets.only(bottom: 8),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFF3F4F6), width: 1),
              ),
            ),
            child: Row(
              children: [
                // Icon building/market
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(194, 220, 128, 0.35),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: SvgPicture.string(
                      '''<svg width="17" height="17" viewBox="0 0 17 17" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M7.43339 15.8909V5.89086H1.19109C0.956182 5.89086 0.80514 5.78118 0.73796 5.56182C0.67078 5.34247 0.732148 5.16727 0.922064 5.03623L7.79254 0.186595C7.96524 0.0621982 8.14822 0 8.34145 0C8.53469 0 8.71766 0.0621982 8.89037 0.186595L15.7608 5.03623C15.9508 5.16727 16.0121 5.34247 15.9449 5.56182C15.8778 5.78118 15.7267 5.89086 15.4918 5.89086H9.24952V15.8909C9.24952 16.1469 9.16218 16.3622 8.98751 16.5369C8.81285 16.7116 8.59749 16.7989 8.34145 16.7989C8.08541 16.7989 7.87006 16.7116 7.69539 16.5369C7.52072 16.3622 7.43339 16.1469 7.43339 15.8909ZM0.53755 15.8909V12.3592L0.0167162 9.50997C-0.0282718 9.25393 0.0175466 9.02733 0.154171 8.83017C0.290796 8.633 0.487128 8.51027 0.743167 8.46196C0.988639 8.41365 1.21343 8.46128 1.41753 8.60485C1.62164 8.74842 1.74619 8.94294 1.79118 9.18841L2.2554 11.6495H4.8188C5.08481 11.6495 5.30929 11.7409 5.49226 11.9239C5.67524 12.1069 5.76672 12.3314 5.76672 12.5974V15.8909C5.76672 16.1469 5.67939 16.3622 5.50472 16.5369C5.33005 16.7116 5.1147 16.7989 4.85866 16.7989C4.60262 16.7989 4.38644 16.7108 4.21011 16.5344C4.03378 16.3581 3.94561 16.1419 3.94561 15.8859V13.4656H2.35368V15.8909C2.35368 16.1469 2.26634 16.3622 2.09167 16.5369C1.91701 16.7116 1.70165 16.7989 1.44561 16.7989C1.18957 16.7989 0.97422 16.7116 0.799552 16.5369C0.624884 16.3622 0.53755 16.1469 0.53755 15.8909ZM10.9162 15.8859V12.5974C10.9162 12.3314 11.0077 12.1069 11.1906 11.9239C11.3736 11.7409 11.5981 11.6495 11.8641 11.6495H14.4275L14.8917 9.18841C14.9367 8.94294 15.0586 8.74842 15.2574 8.60485C15.4563 8.46128 15.6837 8.41365 15.9397 8.46196C16.1958 8.51027 16.3921 8.633 16.5287 8.83017C16.6654 9.02733 16.7112 9.25393 16.6662 9.50997L16.1454 12.3592V15.8909C16.1454 16.1469 16.058 16.3622 15.8834 16.5369C15.7087 16.7116 15.4933 16.7989 15.2373 16.7989C14.9813 16.7989 14.7659 16.7116 14.5912 16.5369C14.4166 16.3622 14.3292 16.1469 14.3292 15.8909V13.4656H12.7373V15.8909C12.7373 16.1469 12.65 16.3622 12.4753 16.5369C12.3006 16.7116 12.0853 16.7989 11.8292 16.7989C11.5732 16.7989 11.357 16.7108 11.1807 16.5344C11.0043 16.3581 10.9162 16.1419 10.9162 15.8859Z" fill="#4B6515"/>
</svg>''',
                      width: 17,
                      height: 17,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fasilitas & Parkir',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF111827),
                          height: 1.43,
                        ),
                      ),
                      Text(
                        'Kenyamanan & sarana pendukung pasar',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF9CA3AF),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const Text(
                  '7 Fasilitas',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 2-column Facilities Grid
          Column(
            children: [
              // Row 1: Toilet Bersih & Mushola
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildFacilityGridItem(
                      iconSvg: '''<svg width="12" height="14" viewBox="0 0 12 14" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M1 12.6946V8.39312H0.746379C0.536233 8.39312 0.3593 8.32126 0.21558 8.17754C0.0718601 8.03382 0 7.85688 0 7.64674V4.72645C0 4.35978 0.130556 4.0459 0.391667 3.78478C0.652778 3.52367 0.966667 3.39312 1.33333 3.39312H3.45689C3.82355 3.39312 4.13744 3.52367 4.39855 3.78478C4.65966 4.0459 4.79022 4.35978 4.79022 4.72645V7.64674C4.79022 7.85688 4.71836 8.03382 4.57464 8.17754C4.43092 8.32126 4.25399 8.39312 4.04384 8.39312H3.79022V12.6946C3.79022 12.9074 3.71703 13.087 3.57065 13.2333C3.42428 13.3797 3.24469 13.4529 3.03188 13.4529H1.75834C1.54553 13.4529 1.36594 13.3797 1.21957 13.2333C1.07319 13.087 1 12.9074 1 12.6946V12.6946M2.3971 2.78623C2.01184 2.78623 1.68267 2.65036 1.4096 2.37863C1.13653 2.10689 1 1.77838 1 1.39312C1 1.00785 1.13653 0.679348 1.4096 0.407609C1.68267 0.13587 2.01184 0 2.3971 0C2.78237 0 3.11087 0.13587 3.38261 0.407609C3.65435 0.679348 3.79022 1.00785 3.79022 1.39312C3.79022 1.77838 3.65435 2.10689 3.38261 2.37863C3.11087 2.65036 2.78237 2.78623 2.3971 2.78623V2.78623M7.45689 12.6946V9.51667H6.47718C6.22307 9.51667 6.01939 9.41238 5.86613 9.20381C5.71287 8.99523 5.68044 8.76522 5.76884 8.51377L7.15689 4.33696C7.25109 4.03744 7.42295 3.80526 7.67247 3.6404C7.92198 3.47554 8.20339 3.39312 8.51667 3.39312C8.82996 3.39312 9.11202 3.47554 9.36287 3.6404C9.61371 3.80526 9.78624 4.03744 9.88044 4.33696L11.2685 8.51377C11.3569 8.76522 11.3245 8.99523 11.1712 9.20381C11.0179 9.41238 10.8143 9.51667 10.5601 9.51667H9.58044V12.6946C9.58044 12.9074 9.50725 13.087 9.36087 13.2333C9.2145 13.3797 9.03491 13.4529 8.8221 13.4529H8.21522C8.00242 13.4529 7.82283 13.3797 7.67645 13.2333C7.53008 13.087 7.45689 12.9074 7.45689 12.6946V12.6946M8.51667 2.78623C8.1314 2.78623 7.8029 2.65036 7.53116 2.37863C7.25942 2.10689 7.12355 1.77838 7.12355 1.39312C7.12355 1.00785 7.25942 0.679348 7.53116 0.407609C7.8029 0.13587 8.1314 0 8.51667 0C8.90194 0 9.2311 0.13587 9.50417 0.407609C9.77724 0.679348 9.91377 1.00785 9.91377 1.39312C9.91377 1.77838 9.77724 2.10689 9.50417 2.37863C9.2311 2.65036 8.90194 2.78623 8.51667 2.78623V2.78623" fill="#F59E0B"/>
</svg>''',
                      iconBgColor: const Color.fromRGBO(251, 191, 36, 0.35),
                      title: 'Toilet Bersih',
                      subtitle: 'Terpisah pria/wanita\n& ramah difabel.',
                      minHeight: 89.5,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildFacilityGridItem(
                      iconSvg: '''<svg width="17" height="14" viewBox="0 0 17 14" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M4.58949 4.45725C4.37742 4.45725 4.22615 4.41268 4.13569 4.32355C4.04523 4.23442 4 4.08382 4 3.87174C4 3.41135 4.10888 2.98496 4.32663 2.59257C4.54438 2.20018 4.83768 1.87778 5.20652 1.62536L7.24203 0.261232C7.49614 0.0870775 7.77935 0 8.09167 0C8.40399 0 8.6872 0.0870775 8.94131 0.261232L10.9768 1.62536C11.3457 1.87778 11.639 2.20018 11.8567 2.59257C12.0745 2.98496 12.1833 3.41135 12.1833 3.87174C12.1833 4.08382 12.1388 4.23442 12.0496 4.32355C11.9605 4.41268 11.8099 4.45725 11.5978 4.45725H4.58949V4.45725M0.666667 11.8649V5.0029C0.466667 4.87271 0.305556 4.7064 0.183333 4.50399C0.0611111 4.30157 0 4.0686 0 3.80507C0 3.53358 0.141969 3.20254 0.425906 2.81196C0.709844 2.42138 1.04288 2.04324 1.425 1.67753C1.80713 2.04324 2.14016 2.42138 2.4241 2.81196C2.70804 3.20254 2.85 3.53358 2.85 3.80507C2.85 4.0686 2.78889 4.30157 2.66667 4.50399C2.54445 4.7064 2.38334 4.87271 2.18334 5.0029V7.7413H3.33333V6.47174C3.33333 6.17536 3.42222 5.89873 3.6 5.64185C3.77778 5.38496 4.02271 5.21232 4.33478 5.12391H11.8486C12.1606 5.21232 12.4056 5.38496 12.5833 5.64185C12.7611 5.89873 12.85 6.17536 12.85 6.47174V7.7413H14V5.0029C13.8 4.87271 13.6389 4.7064 13.5167 4.50399C13.3944 4.30157 13.3333 4.0686 13.3333 3.80507C13.3333 3.53358 13.4753 3.20254 13.7592 2.81196C14.0432 2.42138 14.3762 2.04324 14.7583 1.67753C15.1405 2.04324 15.4735 2.42138 15.7574 2.81196C16.0414 3.20254 16.1833 3.53358 16.1833 3.80507C16.1833 4.0686 16.1222 4.30157 16 4.50399C15.8778 4.7064 15.7167 4.87271 15.5167 5.0029V11.8649C15.5167 12.2847 15.3688 12.6424 15.0732 12.938C14.7775 13.2337 14.4198 13.3815 14 13.3815H10.2909C10.0781 13.3815 9.89856 13.3083 9.75218 13.162C9.6058 13.0156 9.53261 12.836 9.53261 12.6232V10.6232C9.53261 10.2273 9.39143 9.88817 9.10906 9.6058C8.82669 9.32343 8.48756 9.18225 8.09167 9.18225C7.69577 9.18225 7.35664 9.32343 7.07428 9.6058C6.79191 9.88817 6.65072 10.2273 6.65072 10.6232V12.6232C6.65072 12.836 6.57754 13.0156 6.43116 13.162C6.28478 13.3083 6.10519 13.3815 5.89239 13.3815H2.18334C1.76353 13.3815 1.4058 13.2337 1.11015 12.938C0.814493 12.6424 0.666667 12.2847 0.666667 11.8649V11.8649" fill="#4B6515"/>
</svg>''',
                      iconBgColor: const Color.fromRGBO(194, 220, 128, 0.50),
                      title: 'Mushola',
                      subtitle: 'Terletak di Lt. 2,\nmukena & karpet\nbersih.',
                      minHeight: 89.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Row 2: Parkir & Foodcourt Legenda
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildFacilityGridItem(
                      iconSvg: '''<svg width="9" height="13" viewBox="0 0 9 13" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M2.90979 8.24312V10.8181C2.90979 11.2193 2.76794 11.5618 2.48424 11.8455C2.20055 12.1292 1.8583 12.271 1.45749 12.271C1.05668 12.271 0.713561 12.1284 0.428137 11.8431C0.142712 11.5578 0 11.2148 0 10.8141V1.4529C0 1.05169 0.142653 0.70924 0.42796 0.425544C0.713267 0.141848 1.05624 0 1.45689 0H4.75435C5.93189 0 6.92349 0.40151 7.72917 1.20453C8.53485 2.00755 8.93769 2.98056 8.93769 4.12355C8.93769 5.26655 8.53485 6.23889 7.72917 7.04058C6.92349 7.84228 5.93189 8.24312 4.75435 8.24312H2.90979V8.24312M2.90979 5.45689H4.80399C5.17065 5.45689 5.48454 5.32633 5.74565 5.06522C6.00676 4.80411 6.13732 4.49022 6.13732 4.12355C6.13732 3.75689 6.00676 3.443 5.74565 3.18189C5.48454 2.92078 5.17065 2.79022 4.80399 2.79022H2.90979V5.45689V5.45689" fill="#4B6515"/>
</svg>''',
                      iconBgColor: const Color.fromRGBO(194, 220, 128, 0.60),
                      title: 'Parkir',
                      subtitle: 'Area motor & mobil\ndengan penjagaan\nresmi.',
                      minHeight: 77,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildFacilityGridItem(
                      iconSvg: '''<svg width="11" height="14" viewBox="0 0 11 14" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M2.12355 4.66667V0.726451C2.12355 0.521619 2.19342 0.349336 2.33316 0.209602C2.47289 0.0698673 2.64517 0 2.85 0C3.05484 0 3.22712 0.0698673 3.36685 0.209602C3.50659 0.349336 3.57645 0.521619 3.57645 0.726451V4.66667H4.24312V0.726451C4.24312 0.521619 4.31365 0.349336 4.45472 0.209602C4.59578 0.0698673 4.76873 0 4.97356 0C5.17839 0 5.35067 0.0698673 5.49041 0.209602C5.63014 0.349336 5.70001 0.521619 5.70001 0.726451V4.66667C5.70001 5.32343 5.4924 5.89843 5.07718 6.39167C4.66196 6.88491 4.16172 7.2093 3.57645 7.36486V12.7265C3.57645 12.9313 3.50659 13.1036 3.36685 13.2433C3.22712 13.383 3.05484 13.4529 2.85 13.4529C2.64517 13.4529 2.47289 13.383 2.33316 13.2433C2.19342 13.1036 2.12355 12.9313 2.12355 12.7265V7.36486C1.53829 7.2093 1.03805 6.88491 0.622827 6.39167C0.207609 5.89843 0 5.32343 0 4.66667V0.726451C0 0.521619 0.0705315 0.349336 0.211595 0.209602C0.352658 0.0698673 0.525605 0 0.730436 0C0.935267 0 1.10755 0.0698673 1.24729 0.209602C1.38702 0.349336 1.45689 0.521619 1.45689 0.726451V4.66667H2.12355V4.66667M8.97356 8.11957H7.73189C7.51909 8.11957 7.3395 8.04638 7.19312 7.9C7.04675 7.75362 6.97356 7.57403 6.97356 7.36123V3.39312C6.97356 2.60737 7.26565 1.84541 7.84983 1.10725C8.434 0.369082 9.03431 0 9.65073 0C9.87465 0 10.0599 0.088406 10.2065 0.265218C10.3531 0.44203 10.4265 0.649277 10.4265 0.886959V12.7265C10.4265 12.9313 10.3566 13.1036 10.2169 13.2433C10.0771 13.383 9.90484 13.4529 9.70001 13.4529C9.49518 13.4529 9.32289 13.383 9.18316 13.2433C9.04343 13.1036 8.97356 12.9313 8.97356 12.7265V8.11957V8.11957" fill="#F59E0B"/>
</svg>''',
                      iconBgColor: const Color.fromRGBO(251, 191, 36, 0.35),
                      title: 'Foodcourt Legenda',
                      subtitle: 'Kue lumpur, serabi,\nbakpao kentang.',
                      minHeight: 77,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Row 3: Laktasi & Medis & Aksesibilitas Difabel
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildFacilityGridItem(
                      iconSvg: '''<svg width="14" height="14" viewBox="0 0 14 14" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M11.1893 2.78623C10.8063 2.78623 10.4777 2.64988 10.2033 2.37716C9.92887 2.10445 9.79168 1.77661 9.79168 1.39365C9.79168 1.01068 9.92887 0.68267 10.2033 0.409602C10.4777 0.136534 10.8063 0 11.1893 0C11.5723 0 11.9001 0.136358 12.1728 0.409073C12.4455 0.681788 12.5819 1.00963 12.5819 1.39259C12.5819 1.77555 12.4455 2.10356 12.1728 2.37663C11.9001 2.6497 11.5723 2.78623 11.1893 2.78623V2.78623M10.3667 12.7703V8.15145C10.3667 7.72336 10.2594 7.33808 10.0449 6.9956C9.83044 6.65313 9.55339 6.3872 9.21378 6.19783L9.86487 4.35761C9.95907 4.08249 10.1283 3.86027 10.3725 3.69094C10.6167 3.52162 10.8888 3.43696 11.1888 3.43696C11.4888 3.43696 11.7609 3.52162 12.0051 3.69094C12.2493 3.86027 12.4185 4.08249 12.5127 4.35761L13.9486 8.5337C14.0396 8.78515 14.0077 9.01649 13.8529 9.22772C13.6981 9.43895 13.4923 9.54457 13.2355 9.54457H12.546V12.7703C12.546 12.9831 12.4728 13.1627 12.3265 13.3091C12.1801 13.4554 12.0005 13.5286 11.7877 13.5286H11.125C10.9122 13.5286 10.7326 13.4554 10.5862 13.3091C10.4399 13.1627 10.3667 12.9831 10.3667 12.7703V12.7703M7.30759 6.51667C7.01341 6.51667 6.76311 6.41281 6.55671 6.20508C6.35031 5.99735 6.24711 5.74639 6.24711 5.4522C6.24711 5.15801 6.35007 4.90795 6.55601 4.70202C6.76194 4.49608 7.012 4.39312 7.30619 4.39312C7.60038 4.39312 7.85067 4.49608 8.05707 4.70202C8.26347 4.90795 8.36667 5.15801 8.36667 5.4522C8.36667 5.74639 8.26371 5.99735 8.05778 6.20508C7.85184 6.41281 7.60178 6.51667 7.30759 6.51667V6.51667M2.45742 2.78623C2.07445 2.78623 1.74644 2.64988 1.47337 2.37716C1.2003 2.10445 1.06377 1.77661 1.06377 1.39365C1.06377 1.01068 1.20013 0.68267 1.47284 0.409602C1.74556 0.136534 2.0734 0 2.45636 0C2.83932 0 3.16733 0.136358 3.4404 0.409073C3.71347 0.681788 3.85 1.00963 3.85 1.39259C3.85 1.77555 3.71365 2.10356 3.44093 2.37663C3.16822 2.6497 2.84038 2.78623 2.45742 2.78623V2.78623M1 12.7703V8.8779H0.746379C0.534905 8.8779 0.35764 8.80638 0.214584 8.66332C0.0715279 8.52026 0 8.343 0 8.13153V4.96957C0 4.55249 0.148507 4.19544 0.445522 3.89842C0.742537 3.60141 1.09959 3.4529 1.51667 3.4529H3.3971C3.81419 3.4529 4.17124 3.60141 4.46825 3.89842C4.76527 4.19544 4.91377 4.55249 4.91377 4.96957V8.13153C4.91377 8.343 4.84225 8.52026 4.69919 8.66332C4.55613 8.80638 4.37887 8.8779 4.1674 8.8779H3.91377V12.7703C3.91377 12.9831 3.84058 13.1627 3.69421 13.3091C3.54783 13.4554 3.36824 13.5286 3.15544 13.5286H1.75834C1.54553 13.5286 1.36594 13.4554 1.21957 13.3091C1.07319 13.1627 1 12.9831 1 12.7703V12.7703M6.24711 12.7703V10.85V10.85C6.05822 10.85 5.89988 10.7861 5.77211 10.6583C5.64433 10.5306 5.58044 10.3722 5.58044 10.1833V8.29095C5.58044 7.97597 5.69161 7.70731 5.91396 7.48497C6.1363 7.26262 6.40496 7.15145 6.71994 7.15145H7.89385C8.20882 7.15145 8.47748 7.26262 8.69983 7.48497C8.92217 7.70731 9.03334 7.97597 9.03334 8.29095V10.1833C9.03334 10.3722 8.96945 10.5306 8.84167 10.6583C8.7139 10.7861 8.55556 10.85 8.36667 10.85V10.85V12.7703C8.36667 12.9831 8.29349 13.1627 8.14711 13.3091C8.00073 13.4554 7.82114 13.5286 7.60834 13.5286H7.00544C6.79264 13.5286 6.61305 13.4554 6.46667 13.3091C6.3203 13.1627 6.24711 12.9831 6.24711 12.7703V12.7703" fill="#F59E0B"/>
</svg>''',
                      iconBgColor: const Color.fromRGBO(251, 191, 36, 0.35),
                      title: 'Laktasi & Pos Medis',
                      subtitle: 'Ruang ibu menyusui\n& P3K terpadu.',
                      minHeight: 77,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildFacilityGridItem(
                      iconSvg: '''<svg width="14" height="17" viewBox="0 0 14 17" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M4.16667 16.25C3.01389 16.25 2.03125 15.8438 1.21875 15.0312C0.40625 14.2188 0 13.2361 0 12.0833C0 10.9306 0.40625 9.94792 1.21875 9.13542C2.03125 8.32292 3.01389 7.91667 4.16667 7.91667V9.58333C3.47222 9.58333 2.88194 9.82639 2.39583 10.3125C1.90972 10.7986 1.66667 11.3889 1.66667 12.0833C1.66667 12.7778 1.90972 13.3681 2.39583 13.8542C2.88194 14.3403 3.47222 14.5833 4.16667 14.5833C4.86111 14.5833 5.45139 14.3403 5.9375 13.8542C6.42361 13.3681 6.66667 12.7778 6.66667 12.0833H8.33333C8.33333 13.2361 7.92708 14.2188 7.11458 15.0312C6.30208 15.8438 5.31944 16.25 4.16667 16.25V16.25M11.6667 15.4167V11.25V11.25V11.25H6.66667C6.05556 11.25 5.58333 10.9896 5.25 10.4688C4.91667 9.94792 4.875 9.40278 5.125 8.83333L6.66667 5.41667H4.77083L4.27083 6.70833L2.66667 6.25L3.25 4.75C3.375 4.43056 3.57986 4.18403 3.86458 4.01042C4.14931 3.83681 4.45833 3.75 4.79167 3.75H9.125C9.75 3.75 10.2257 4.00347 10.5521 4.51042C10.8785 5.01736 10.9167 5.55556 10.6667 6.125L9.29167 9.16667H11.6667C12.125 9.16667 12.5174 9.32986 12.8438 9.65625C13.1701 9.98264 13.3333 10.375 13.3333 10.8333V15.4167H11.6667V15.4167M10.8333 3.33333C10.375 3.33333 9.98264 3.17014 9.65625 2.84375C9.32986 2.51736 9.16667 2.125 9.16667 1.66667C9.16667 1.20833 9.32986 0.815972 9.65625 0.489583C9.98264 0.163194 10.375 0 10.8333 0C11.2917 0 11.684 0.163194 12.0104 0.489583C12.3368 0.815972 12.5 1.20833 12.5 1.66667C12.5 2.125 12.3368 2.51736 12.0104 2.84375C11.684 3.17014 11.2917 3.33333 10.8333 3.33333V3.33333" fill="#4B6515"/>
</svg>''',
                      iconBgColor: const Color.fromRGBO(194, 220, 128, 0.50),
                      title: 'Aksesibilitas Difabel',
                      subtitle: 'Jalur kursi roda &\npegangan ramah.',
                      minHeight: 77,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Row 4: Pojok Daur Ulang & Kompos (Left column)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildFacilityGridItem(
                      iconSvg: '''<svg width="14" height="14" viewBox="0 0 14 14" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M5.36068 4.2413L6.47408 2.39384L5.47481 0.728623C5.33616 0.506401 5.14051 0.39529 4.88785 0.39529C4.63519 0.39529 4.44087 0.506401 4.30488 0.728623L3.03749 2.85072C2.93266 3.03019 2.90301 3.22222 2.94854 3.42681C2.99407 3.6314 3.10657 3.78611 3.28604 3.89094L4.32046 4.50652C4.49993 4.61135 4.69196 4.63823 4.89655 4.58714C5.10114 4.53605 5.25585 4.42077 5.36068 4.2413V4.2413M11.5324 9.50471L10.423 7.65327C10.3097 7.4738 10.2807 7.2811 10.336 7.07518C10.3914 6.86927 10.5087 6.71389 10.6882 6.60906L11.7353 6.01015C11.9148 5.90797 12.1047 5.88177 12.3051 5.93152C12.5054 5.98128 12.658 6.0959 12.7629 6.27537L13.4683 7.45218C13.5905 7.64638 13.6572 7.86148 13.6683 8.09747C13.6794 8.33346 13.6294 8.55411 13.5183 8.75942C13.4045 8.98696 13.238 9.16806 13.0187 9.30272C12.7993 9.43738 12.5592 9.50471 12.2984 9.50471H11.5324V9.50471M8.9335 13.6087L7.39981 12.075C7.24788 11.9231 7.17191 11.7449 7.17191 11.5406C7.17191 11.3362 7.24788 11.1581 7.39981 11.0062L8.9335 9.47247C9.0579 9.34807 9.19673 9.31764 9.34999 9.38116C9.50325 9.44469 9.57988 9.56353 9.57988 9.73769V10.1833H12.8063L11.8197 12.1525C11.6975 12.3801 11.5282 12.5612 11.3118 12.6958C11.0953 12.8305 10.858 12.8978 10.5998 12.8978H9.57988V13.3435C9.57988 13.5176 9.50325 13.6365 9.34999 13.7C9.19673 13.7635 9.0579 13.7331 8.9335 13.6087V13.6087M3.01031 12.8978C2.78543 12.8978 2.58 12.8388 2.39401 12.7208C2.20802 12.6028 2.06925 12.4467 1.9777 12.2525C1.88882 12.0721 1.84648 11.8833 1.85071 11.6862C1.85494 11.4891 1.90838 11.3046 2.01104 11.1326L2.58966 10.1833H4.7498C4.96261 10.1833 5.1422 10.2565 5.28857 10.4029C5.43495 10.5493 5.50814 10.7289 5.50814 10.9417V12.1395C5.50814 12.3523 5.43495 12.5319 5.28857 12.6783C5.1422 12.8246 4.96261 12.8978 4.7498 12.8978H3.01031V12.8978M1.33241 10.9659L0.229153 8.75942C0.123839 8.55411 0.0752878 8.33624 0.0835004 8.1058C0.091713 7.87537 0.15693 7.65749 0.279153 7.45218L0.553791 6.99022L0.179517 6.7674C0.0386952 6.67899 -0.019276 6.54982 0.00560328 6.37989C0.0304826 6.20997 0.124444 6.10568 0.287488 6.06703L2.37662 5.54892C2.58096 5.49916 2.77366 5.52748 2.9547 5.63388C3.13574 5.74028 3.25113 5.89566 3.30089 6.1L3.81901 8.20181C3.85766 8.36486 3.8079 8.4968 3.66973 8.59765C3.53157 8.69849 3.39208 8.70471 3.25125 8.61631L2.87698 8.3808L1.33241 10.9659V10.9659M9.75814 4.97174L7.673 4.45363C7.50995 4.41498 7.41811 4.31069 7.39745 4.14076C7.3768 3.97083 7.43689 3.84167 7.57771 3.75326L7.95198 3.53044L5.82879 0H8.22263C8.46128 0 8.68405 0.0596619 8.89093 0.178986C9.09782 0.298309 9.26503 0.4593 9.39256 0.661957L10.2752 2.13986L10.6368 1.91703C10.7776 1.82862 10.9171 1.83551 11.0552 1.93768C11.1934 2.03986 11.2432 2.17247 11.2045 2.33551L10.6824 4.42065C10.63 4.625 10.5139 4.78038 10.3342 4.88678C10.1545 4.99318 9.96249 5.0215 9.75814 4.97174V4.97174" fill="#0F766E"/>
</svg>''',
                      iconBgColor: const Color.fromRGBO(194, 220, 128, 0.60),
                      title: 'Pojok Daur Ulang\n & Kompos',
                      subtitle: 'Pengelolaan sampah\norganik terpadu.',
                      minHeight: 77,
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Empty space to preserve grid balance
                  const Expanded(child: SizedBox()),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Official Parking Rate Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(251, 191, 36, 0.35),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color.fromRGBO(194, 220, 128, 0.70),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                SvgPicture.string(
                  '''<svg width="19" height="14" viewBox="0 0 19 14" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M1.89584 13.7917C1.37448 13.7917 0.928171 13.606 0.556903 13.2348C0.185634 12.8635 0 12.4172 0 11.8958V3.75182C0 3.48582 0.0914858 3.26133 0.274457 3.07836C0.457429 2.89539 0.681916 2.8039 0.947919 2.8039C1.21392 2.8039 1.43841 2.89539 1.62138 3.07836C1.80435 3.26133 1.89584 3.48582 1.89584 3.75182V11.8958V11.8958V11.8958H15.0399C15.3059 11.8958 15.5303 11.9873 15.7133 12.1703C15.8963 12.3533 15.9878 12.5778 15.9878 12.8438C15.9878 13.1098 15.8963 13.3342 15.7133 13.5172C15.5303 13.7002 15.3059 13.7917 15.0399 13.7917H1.89584V13.7917M5.38361 10.3039C4.86226 10.3039 4.41595 10.1183 4.04468 9.747C3.67341 9.37573 3.48778 8.92942 3.48778 8.40806V1.89584C3.48778 1.37448 3.67341 0.928171 4.04468 0.556903C4.41595 0.185634 4.86226 0 5.38361 0H16.7464C17.2677 0 17.714 0.185634 18.0853 0.556903C18.4566 0.928171 18.6422 1.37448 18.6422 1.89584V8.40806C18.6422 8.92942 18.4566 9.37573 18.0853 9.747C17.714 10.1183 17.2677 10.3039 16.7464 10.3039H5.38361V10.3039M6.97555 8.48279C6.97555 8.02446 6.81236 7.6321 6.48597 7.30571C6.15958 6.97932 5.76722 6.81613 5.30888 6.81613V8.48279V8.48279V8.48279H6.97555V8.48279M15.1544 8.48279H16.8211V8.48279V8.48279V6.81613C16.3628 6.81613 15.9704 6.97932 15.644 7.30571C15.3176 7.6321 15.1544 8.02446 15.1544 8.48279V8.48279M11.0625 7.64946C11.7569 7.64946 12.3472 7.4064 12.8333 6.92029C13.3194 6.43418 13.5625 5.8439 13.5625 5.14946C13.5625 4.45502 13.3194 3.86474 12.8333 3.37863C12.3472 2.89252 11.7569 2.64946 11.0625 2.64946C10.3681 2.64946 9.77778 2.89252 9.29167 3.37863C8.80556 3.86474 8.5625 4.45502 8.5625 5.14946C8.5625 5.8439 8.80556 6.43418 9.29167 6.92029C9.77778 7.4064 10.3681 7.64946 11.0625 7.64946V7.64946M5.30888 3.48279C5.76722 3.48279 6.15958 3.3196 6.48597 2.99321C6.81236 2.66682 6.97555 2.27446 6.97555 1.81613H5.30888V1.81613V1.81613V3.48279V3.48279M16.8211 3.48279V1.81613V1.81613V1.81613H15.1544C15.1544 2.27446 15.3176 2.66682 15.644 2.99321C15.9704 3.3196 16.3628 3.48279 16.8211 3.48279V3.48279" fill="#4B6515"/>
</svg>''',
                  width: 19,
                  height: 14,
                ),
                const SizedBox(width: 8),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tarif Parkir Resmi Pemkot',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                        height: 1.33,
                      ),
                    ),
                    Text(
                      'Motor Rp 2.000 • Mobil Rp 3.000',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF4B5563),
                        height: 1.5,
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

  // --- Facility Grid Item ---
  Widget _buildFacilityGridItem({
    required String iconSvg,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required double minHeight,
  }) {
    return Container(
      constraints: BoxConstraints(minHeight: minHeight),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF6F3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: SvgPicture.string(iconSvg),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
                    height: 1.33,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF6B7280),
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- SNI Accreditation Banner ---
  Widget _buildSniBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFBBF24),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF4B6515), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFC2DC80),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          SvgPicture.string(
            '''<svg width="15" height="14" viewBox="0 0 15 14" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M6.56413 7.392L5.62537 6.46592C5.49517 6.33572 5.33376 6.27063 5.14113 6.27063C4.94849 6.27063 4.78285 6.33995 4.64421 6.4786C4.51401 6.60879 4.44892 6.77232 4.44892 6.96918C4.44892 7.16604 4.51401 7.32956 4.64421 7.45976L6.02971 8.84526C6.18164 8.9972 6.35979 9.07316 6.56413 9.07316C6.76848 9.07316 6.94662 8.9972 7.09856 8.84526L9.88406 6.05976C10.0227 5.92111 10.0899 5.75758 10.0857 5.56918C10.0815 5.38077 10.0143 5.21724 9.88406 5.0786C9.74541 4.93995 9.57977 4.86851 9.38714 4.86428C9.19451 4.86006 9.02887 4.92727 8.89022 5.06592L6.56413 7.392V7.392M4.60181 13.5688L3.6471 11.9514L1.8337 11.5554C1.64577 11.5168 1.49451 11.4187 1.37989 11.2612C1.26528 11.1037 1.21908 10.9297 1.2413 10.7391L1.42464 8.87968L0.19058 7.46229C0.0635267 7.32147 0 7.1571 0 6.96918C0 6.78125 0.0635267 6.61688 0.19058 6.47606L1.42464 5.05867L1.2413 3.19925C1.21908 3.00867 1.26528 2.83463 1.37989 2.67715C1.49451 2.51966 1.64577 2.42159 1.8337 2.38294L3.6471 1.98693L4.60181 0.369537C4.70133 0.206493 4.84016 0.0959851 5.0183 0.0380139C5.19644 -0.0199573 5.37392 -0.0116239 5.55073 0.0630139L7.26413 0.788376L8.97754 0.0630139C9.15435 -0.0116239 9.33183 -0.0199573 9.50997 0.0380139C9.68811 0.0959851 9.82694 0.206493 9.92645 0.369537L10.8812 1.98693L12.6946 2.38294C12.8825 2.42159 13.0338 2.51966 13.1484 2.67715C13.263 2.83463 13.3092 3.00867 13.287 3.19925L13.1036 5.05867L14.3377 6.47606C14.4647 6.61688 14.5283 6.78125 14.5283 6.96918C14.5283 7.1571 14.4647 7.32147 14.3377 7.46229L13.1036 8.87968L13.287 10.7391C13.3092 10.9297 13.263 11.1037 13.1484 11.2612C13.0338 11.4187 12.8825 11.5168 12.6946 11.5554L10.8812 11.9514L9.92645 13.5688C9.82694 13.7319 9.68811 13.8424 9.50997 13.9003C9.33183 13.9583 9.15435 13.95 8.97754 13.8753L7.26413 13.15L5.55073 13.8753C5.37392 13.95 5.19644 13.9583 5.0183 13.9003C4.84016 13.8424 4.70133 13.7319 4.60181 13.5688V13.5688" fill="black"/>
</svg>''',
            width: 15,
            height: 14,
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Pasar terakreditasi SNI Pasar Rakyat dengan kebersihan lorong & sirkulasi udara optimal.',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Floating Bottom Navigation Bar ---
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
          // Home Tab (Active)
          InkWell(
            onTap: () => goTo(context, '/home'),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(194, 220, 128, 0.35),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Center(
                    child: SvgPicture.string(
                      '''<svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M10 14V8.66667C10 8.29872 9.70128 8 9.33333 8H6.66667C6.29872 8 6 8.29872 6 8.66667V14" stroke-width="1.33333" stroke-linecap="round" stroke-linejoin="round" stroke="#4B6515"/>
<path d="M2 6.66666C1.99991 6.27408 2.17283 5.90141 2.47267 5.64799L7.13933 1.64799C7.63626 1.22801 8.36374 1.22801 8.86067 1.64799L13.5273 5.64799C13.8272 5.90141 14.0001 6.27408 14 6.66666V12.6667C14 13.4025 13.4026 14 12.6667 14H3.33333C2.59745 14 2 13.4025 2 12.6667V6.66666" stroke-width="1.33333" stroke-linecap="round" stroke-linejoin="round" stroke="#4B6515"/>
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
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF4B6515),
                  ),
                ),
              ],
            ),
          ),

          // Toko Tab
          InkWell(
            onTap: () => goTo(context, '/toko'),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 32,
                  height: 32,
                  child: Center(
                    child: SvgPicture.string(
                      '''<svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M12.5 17.5V13.3333C12.5 12.8731 12.1269 12.5 11.6667 12.5H8.33333C7.8731 12.5 7.5 12.8731 7.5 13.3333V17.5" stroke-width="1.66667" stroke-linecap="round" stroke-linejoin="round" stroke="#6B7280"/>
<path d="M14.8116 8.59169C14.4507 8.24618 13.8817 8.24618 13.5208 8.59169C12.7159 9.35941 11.4498 9.35941 10.6449 8.59169C10.2841 8.24671 9.71575 8.24671 9.35494 8.59169C8.54994 9.35994 7.28329 9.35994 6.47828 8.59169C6.11736 8.24618 5.54836 8.24618 5.18744 8.59169C4.41195 9.33172 3.20147 9.36249 2.38937 8.66284C1.57726 7.96318 1.42862 6.76146 2.04578 5.88502L4.45328 2.39835C4.76345 1.94067 5.28039 1.66659 5.83328 1.66669H14.1666C14.7178 1.66648 15.2335 1.93882 15.5441 2.39419L17.9566 5.88752C18.5739 6.7647 18.4243 7.96724 17.6109 8.66643C16.7975 9.36562 15.5861 9.33292 14.8116 8.59085" stroke-width="1.66667" stroke-linecap="round" stroke-linejoin="round" stroke="#6B7280"/>
<path d="M3.33337 9.125V15.8333C3.33337 16.7538 4.07957 17.5 5.00004 17.5H15C15.9205 17.5 16.6667 16.7538 16.6667 15.8333V9.125" stroke-width="1.66667" stroke-linecap="round" stroke-linejoin="round" stroke="#6B7280"/>
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
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF9CA3AF),
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
<path d="M16.9212 17.8795C13.9272 20.8735 9.07291 20.8735 6.07889 17.8795C4.58188 16.3825 3.83338 14.4204 3.83337 12.4583C3.83337 10.4963 4.58188 8.53418 6.07889 7.03717C6.07889 7.03717 6.70842 8.62496 8.62508 9.58329C8.62508 7.66662 9.10425 4.79162 11.4865 2.875C13.4167 4.79167 15.4207 5.53672 16.9212 7.03717C18.4182 8.53418 19.1667 10.4963 19.1667 12.4583C19.1667 14.4204 18.4182 16.3825 16.9212 17.8795ZM13.533 15.4496C12.4102 16.5723 10.5899 16.5723 9.46711 15.4496C8.90574 14.8882 8.62505 14.1524 8.62504 13.4167L10.5417 13.4166L11.514 10.5417C12.2451 10.5452 12.9751 10.8259 13.533 11.3837C14.0944 11.9451 14.375 12.6809 14.375 13.4167C14.375 14.1524 14.0943 14.8882 13.533 15.4496Z" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" stroke="#6B7280"/>
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
<path d="M5.96672 12H8.76255L13.3459 7.41667C13.4834 7.27917 13.5865 7.12257 13.6553 6.94688C13.724 6.77118 13.7584 6.59931 13.7584 6.43125C13.7584 6.26319 13.7202 6.09896 13.6438 5.93854C13.5674 5.77813 13.4681 5.62917 13.3459 5.49167L12.5209 4.62083C12.3834 4.48333 12.2306 4.38021 12.0625 4.31146C11.8945 4.24271 11.7188 4.20833 11.5355 4.20833C11.3674 4.20833 11.1955 4.24271 11.0198 4.31146C10.8441 4.38021 10.6875 4.48333 10.55 4.62083L5.96672 9.20417V12V12M12.3834 6.43125V6.43125L11.5355 5.58333V5.58333L12.3834 6.43125V6.43125M7.34172 10.625V9.75417L9.6563 7.43958L10.1146 7.85208L10.5271 8.31042L8.21255 10.625H7.34172V10.625M10.1146 7.85208L10.5271 8.31042V8.31042L9.6563 7.43958V7.43958L10.1146 7.85208V7.85208M10.7105 12H16.9667V10.1667H12.5438L10.7105 12V12M2.30005 19.3333V2.83333C2.30005 2.32917 2.47956 1.89757 2.83859 1.53854C3.19762 1.17951 3.62922 1 4.13338 1H18.8C19.3042 1 19.7358 1.17951 20.0948 1.53854C20.4539 1.89757 20.6334 2.32917 20.6334 2.83333V13.8333C20.6334 14.3375 20.4539 14.7691 20.0948 15.1281C19.7358 15.4872 19.3042 15.6667 18.8 15.6667H5.96672L2.30005 19.3333V19.3333M5.18755 13.8333H18.8V13.8333V13.8333V2.83333V2.83333V2.83333H4.13338V2.83333V2.83333V14.8646L5.18755 13.8333V13.8333M4.13338 13.8333V13.8333V2.83333V2.83333V2.83333V2.83333V2.83333V2.83333V13.8333V13.8333V13.8333V13.8333V13.8333" fill="#6B7280"/>
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
