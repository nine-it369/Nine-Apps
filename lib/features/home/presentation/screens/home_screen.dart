import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nine_ui_app/nine_ui.dart';
import '../../../../core/router/route_names.dart';
import '../../../mall/presentation/blocs/mall_bloc.dart';
import '../../../mall/presentation/blocs/mall_state.dart';
import '../../../profile/presentation/blocs/profile_bloc.dart';
import '../../../profile/presentation/blocs/profile_state.dart';
import '../../../smart_lighting/presentation/widgets/home_hero_led_card.dart';

/// SCR-02: Master Home Screen (screen-home-dashcam)
/// Replicates D:\Q4 Planning\design\src\modules\home\home.template.html
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF6),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 110),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Top Soft Atmospheric Green Wash Header with Search & Active Vehicle
            _buildTopAtmosphericHeader(context),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),

                  // 2. Hardware Cockpit Hero Viewport: Smart Lamp Hero Card
                  const HomeHeroLedCard(),

                  const SizedBox(height: 20),

                  // 3. Quick Bento Services Grid (Mall, Garage, IoT, Roadside)
                  _buildQuickServicesBento(context),

                  const SizedBox(height: 22),

                  // 4. Section: Aktifitas Terkini (Pesanan Mall & Booking SPK)
                  _buildRecentActivities(context),

                  const SizedBox(height: 22),

                  // 5. Editorial Promo Banner
                  _buildPromoBanner(context),

                  const SizedBox(height: 22),

                  // 6. Produk Terbaik (2-Column Grid)
                  _buildBestProducts(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Sub-widgets & Builders ---

  Widget _buildTopAtmosphericHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFDCEEC7), Color(0xFFE8F5DC), Color(0x00FFFFFF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar + Action Squircles (Notification & Cart)
              Row(
                children: [
                  // Search Bar
                  Expanded(
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: Colors.black.withAlpha(12)),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x05000000),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(TablerIcons.search, color: Color(0xFF231F20), size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Cari suku cadang, servis...',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Notification Squircle Button
                  NineSpringTap(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Notifikasi: Sistem telemetri aktif & tersambung')),
                      );
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.black.withAlpha(12)),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(TablerIcons.bell, size: 20, color: Color(0xFF231F20)),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                color: Color(0xFFED1C24),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Cart Squircle Button with Badge
                  NineSpringTap(
                    onTap: () => context.push(RouteNames.mallCart),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF231F20),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(TablerIcons.shopping_cart, size: 20, color: Colors.white),
                          Positioned(
                            top: 6,
                            right: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4.5, vertical: 1.5),
                              decoration: BoxDecoration(
                                color: const Color(0xFF8DC63F),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                '2',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF231F20),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Greeting & Vehicle Selector Pill Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'SELAMAT PAGI,',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF6B7280),
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 2),
                      BlocBuilder<ProfileBloc, ProfileState>(
                        builder: (context, profileState) {
                          final displayName = profileState.user.name.isNotEmpty
                              ? profileState.user.name
                              : 'Aditya Pratama';
                          return Text(
                            displayName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF231F20),
                              letterSpacing: -0.4,
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  // Vehicle Selector Pill
                  NineSpringTap(
                    onTap: () => _showVehicleSwitcherSheet(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black.withAlpha(12)),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x06000000),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(TablerIcons.car, size: 16, color: Color(0xFF231F20)),
                          const SizedBox(width: 6),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Honda HR-V',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF231F20),
                                ),
                              ),
                              Text(
                                'B 1999 NNE',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 4),
                          const Icon(TablerIcons.chevron_down, size: 14, color: Color(0xFF231F20)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickServicesBento(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildBentoCard(
                title: 'Belanja Suku Cadang',
                subtitle: 'Official Store & Garansi',
                icon: TablerIcons.shopping_bag,
                badge: '100% Ori',
                badgeColor: const Color(0xFF8DC63F),
                isDark: true,
                onTap: () => context.go(RouteNames.mall),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildBentoCard(
                title: 'Booking Bengkel',
                subtitle: 'Reservasi & SPK Resmi',
                icon: TablerIcons.tool,
                badge: 'Slot 30m',
                badgeColor: const Color(0xFF3B82F6),
                isDark: false,
                onTap: () => context.push(RouteNames.garage),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildBentoCard(
                title: 'Aksesoris IoT',
                subtitle: 'Smart LED, Dashcam, GPS',
                icon: TablerIcons.devices,
                badge: '3 Online',
                badgeColor: const Color(0xFF047857),
                isDark: false,
                onTap: () => context.go(RouteNames.accessories),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildBentoCard(
                title: 'Bantuan Darurat',
                subtitle: 'Nine Roadside 24 Jam',
                icon: TablerIcons.ambulance,
                badge: 'Siaga 24/7',
                badgeColor: const Color(0xFFEF4444),
                isDark: false,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Hotline Darurat Roadside: 021-5099-9999')),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBentoCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required String badge,
    required Color badgeColor,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return NineSpringTap(
      onTap: onTap,
      child: Container(
        height: 88,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF18191D) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.transparent : Colors.black.withAlpha(12),
          ),
          boxShadow: [
            BoxShadow(
              color: isDark ? const Color(0x1A000000) : const Color(0x06000000),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, size: 20, color: isDark ? Colors.white : const Color(0xFF18191D)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: badgeColor.withAlpha(35),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    badge,
                    style: TextStyle(
                      fontSize: 8.5,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : badgeColor,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF18191D),
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white60 : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivities(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'AKTIFITAS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: Color(0xFF6B7280),
                letterSpacing: 0.8,
              ),
            ),
            NineSpringTap(
              onTap: () => context.push(RouteNames.orderHistory),
              child: const Text(
                'Lihat Semua >',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF18191D),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Activity 1: Mall Order
        NineSpringTap(
          onTap: () => context.push(RouteNames.orderHistory),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black.withAlpha(12)),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(TablerIcons.truck_delivery, size: 20, color: Color(0xFF18191D)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Order #TGR-0987',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF18191D)),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Dalam Pengiriman',
                              style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'BiLED Matrix Pro 3.0" • Tiba hari ini pk 16:30 (J&T Express)',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 10.5, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Activity 2: Booking Bengkel
        NineSpringTap(
          onTap: () => context.push(RouteNames.ticketLookup),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black.withAlpha(12)),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(TablerIcons.calendar_check, size: 20, color: Color(0xFF18191D)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Instalasi BiLED Matrix',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF18191D)),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'SPK Terbit',
                              style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Rabu, 04 Nov 2026 • 10:00 WIB • Nine Garage Surabaya',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 10.5, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPromoBanner(BuildContext context) {
    return NineSpringTap(
      onTap: () => context.go(RouteNames.mall),
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0D141C), Color(0xFF1F2937)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withAlpha(20)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8DC63F),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'PROMO BULAN INI',
                    style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.w900, color: Color(0xFF18191D)),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Diskon S/D 40% BiLED & Foglamp',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Termasuk Jasa Instalasi & Garansi 24 Bulan',
                  style: TextStyle(fontSize: 10.5, color: Colors.white70),
                ),
              ],
            ),
            const Icon(TablerIcons.chevron_right, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBestProducts(BuildContext context) {
    return BlocBuilder<MallBloc, MallState>(
      builder: (context, mallState) {
        final p1 = mallState.products.isNotEmpty ? mallState.products[0] : null;
        final p2 = mallState.products.length > 1 ? mallState.products[1] : null;

        final p1Title = p1?.name ?? 'Luminos Shooting Light Q9 Pro Dual Lens';
        final p1Price = p1 != null
            ? NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(p1.discPrice)
            : 'Rp 1.850.000';
        final p1Orig = p1 != null
            ? NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(p1.price)
            : 'Rp 2.450.000';
        final p1Discount = p1 != null && p1.price > p1.discPrice
            ? '-${((p1.price - p1.discPrice) / p1.price * 100).round()}%'
            : '-24%';

        final p2Title = p2?.name ?? 'BiLED Matrix Pro 3.0" Laser Projector';
        final p2Price = p2 != null
            ? NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(p2.discPrice)
            : 'Rp 2.450.000';
        final p2Orig = p2 != null
            ? NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(p2.price)
            : 'Rp 3.100.000';
        final p2Discount = p2 != null && p2.price > p2.discPrice
            ? '-${((p2.price - p2.discPrice) / p2.price * 100).round()}%'
            : '-21%';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'PRODUK TERBAIK',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF6B7280),
                    letterSpacing: 0.8,
                  ),
                ),
                NineSpringTap(
                  onTap: () => context.go(RouteNames.mall),
                  child: const Text(
                    'Lihat Semua >',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF18191D),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildProductCard(
                    title: p1Title,
                    price: p1Price,
                    originalPrice: p1Orig,
                    rating: '4.9',
                    discount: p1Discount,
                    onTap: () => context.go(RouteNames.mall),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildProductCard(
                    title: p2Title,
                    price: p2Price,
                    originalPrice: p2Orig,
                    rating: '5.0',
                    discount: p2Discount,
                    onTap: () => context.go(RouteNames.mall),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildProductCard({
    required String title,
    required String price,
    required String originalPrice,
    required String rating,
    required String discount,
    required VoidCallback onTap,
  }) {
    return NineSpringTap(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black.withAlpha(12)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x06000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image Placeholder with Badge
            Container(
              height: 110,
              color: const Color(0xFFF8FAFC),
              alignment: Alignment.center,
              child: Stack(
                children: [
                  Center(
                    child: Icon(TablerIcons.bolt, size: 38, color: Colors.grey.shade400),
                  ),
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFED1C24),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        discount,
                        style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.w900, color: Colors.white),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.black.withAlpha(15)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, size: 10, color: Color(0xFFFBBF24)),
                          const SizedBox(width: 2),
                          Text(
                            rating,
                            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF18191D),
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    originalPrice,
                    style: TextStyle(
                      fontSize: 9.5,
                      color: Colors.grey.shade500,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF18191D),
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

  void _showVehicleSwitcherSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Ganti Kendaraan Aktif',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            _buildVehicleOption('Honda HR-V RS Turbo (2022)', 'B 1999 NNE', true, () => Navigator.pop(ctx)),
            _buildVehicleOption('Toyota Innova Zenix Q Hybrid', 'B 8888 LIVE', false, () => Navigator.pop(ctx)),
            _buildVehicleOption('Honda PCX 160 e:HEV', 'B 3456 NNE', false, () => Navigator.pop(ctx)),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleOption(String name, String plate, bool isSelected, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      leading: const Icon(TablerIcons.car),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      subtitle: Text(plate, style: const TextStyle(fontSize: 11)),
      trailing: isSelected ? const Icon(Icons.check_circle, color: Color(0xFF8DC63F)) : null,
    );
  }
}
