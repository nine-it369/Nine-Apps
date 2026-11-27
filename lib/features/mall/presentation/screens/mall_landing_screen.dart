import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nine_ui_app/nine_ui.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../blocs/mall_bloc.dart';
import '../blocs/mall_event.dart';
import '../blocs/mall_state.dart';

/// SCR-10: Master Mall Screen (screen-mall-landing)
/// Replicates D:\Frontend-Mall (app/pages/index.vue) & D:\Q4 Planning\design\src\modules\mall\mall.template.html
class MallLandingScreen extends StatefulWidget {
  const MallLandingScreen({super.key});

  @override
  State<MallLandingScreen> createState() => _MallLandingScreenState();
}

class _MallLandingScreenState extends State<MallLandingScreen> {
  String _activeCategoryPill = 'all';
  String _activeExploreCategory = 'headlamp';
  String _activeSubcategory = 'lampu-utama';
  final _awbController = TextEditingController();

  final List<Map<String, String>> _categoryPills = [
    {'id': 'all', 'label': 'Semua'},
    {'id': 'biled', 'label': 'BiLED Pro'},
    {'id': 'foglamp', 'label': 'Foglamp Laser'},
    {'id': 'horn', 'label': 'Klakson'},
    {'id': 'dashcam', 'label': 'Dashcam'},
    {'id': 'gps', 'label': 'GPS 4G'},
    {'id': 'relay', 'label': 'Kelistrikan & Relay'},
  ];

  final List<Map<String, dynamic>> _exploreCategories = [
    {'id': 'headlamp', 'label': 'Headlamp & BiLED', 'icon': TablerIcons.bolt},
    {'id': 'shooting', 'label': 'Shooting Light', 'icon': TablerIcons.target},
    {'id': 'lighting_acc', 'label': 'Lighting Acc', 'icon': TablerIcons.arrows_exchange},
    {'id': 'elec_acc', 'label': 'Electrical Acc', 'icon': TablerIcons.cpu},
    {'id': 'interior', 'label': 'Interior Series', 'icon': TablerIcons.armchair},
  ];

  final List<Map<String, String>> _subcategories = [
    {'id': 'lampu-utama', 'label': 'Lampu Utama'},
    {'id': 'biled-projector', 'label': 'Biled Projector'},
    {'id': 'shroud', 'label': 'Shroud'},
    {'id': 'lampu-kabut', 'label': 'Lampu Kabut'},
  ];

  @override
  void dispose() {
    _awbController.dispose();
    super.dispose();
  }

  void _trackAwb() {
    if (_awbController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan nomor resi pengiriman terlebih dahulu.')),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Melacak resi: ${_awbController.text.trim()} (J&T Express - On Delivery)')),
    );
  }

  String _formatRupiah(int amount) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MallBloc, MallState>(
      builder: (context, mallState) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8FAF6),
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Carbon Fiber Header with Search & Category Pills
                _buildCarbonHeader(context, mallState),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 14),

                      // 2. AWB Shipment Quick Tracker (aligned with Frontend-Mall HomeAwbTracker)
                      _buildAwbTracker(context),

                      const SizedBox(height: 18),

                      // 3. Official Store Hero Carousel Banner
                      _buildHeroCarousel(context, mallState),

                      const SizedBox(height: 22),

                      // 4. Jelajahi Produk Kami (Category & Subcategory Tabs + 2-Col Grid)
                      _buildExploreProducts(context, mallState),

                      const SizedBox(height: 24),

                      // 5. Voucher Belanja Section (Perforated Ticket Cards)
                      _buildVoucherSection(context),

                      const SizedBox(height: 24),

                      // 6. Flash Sale / Promo Variants (2-Column Grid)
                      _buildFlashSaleSection(context, mallState),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- Sub-widgets & Builders ---

  Widget _buildCarbonHeader(BuildContext context, MallState mallState) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF14171A),
        border: const Border(
          bottom: BorderSide(color: Color(0x598DC63F), width: 1.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: Title & Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Nine Mall Official Store',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -0.4,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        '100% Suku Cadang Resmi & Garansi Nasional',
                        style: TextStyle(
                          fontSize: 10.5,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  // Action Buttons: History & Cart
                  Row(
                    children: [
                      NineSpringTap(
                        onTap: () => context.push(RouteNames.orderHistory),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(25),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.white.withAlpha(35)),
                          ),
                          child: const Icon(TablerIcons.history, color: Colors.white, size: 18),
                        ),
                      ),
                      const SizedBox(width: 8),
                      NineSpringTap(
                        onTap: () => context.push(RouteNames.mallCart),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(25),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.white.withAlpha(35)),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              const Icon(TablerIcons.shopping_cart, color: Colors.white, size: 18),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF8DC63F),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${mallState.cartTotalQuantity}',
                                    style: const TextStyle(
                                      fontSize: 8.5,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF18191D),
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
                ],
              ),

              const SizedBox(height: 12),

              // Row 2: Search Input
              Container(
                height: 42,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: const [
                    Icon(TablerIcons.search, size: 18, color: Color(0xFF231F20)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Cari BiLED, foglamp, klakson...',
                        style: TextStyle(fontSize: 11.5, color: Color(0xFF58595B)),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Row 3: Horizontal Category Pills
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _categoryPills.map((cat) {
                    final isSelected = cat['id'] == _activeCategoryPill;
                    return Padding(
                      padding: const EdgeInsets.only(right: 6.0),
                      child: NineSpringTap(
                        onTap: () => setState(() => _activeCategoryPill = cat['id']!),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF8DC63F) : Colors.white.withAlpha(35),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            cat['label']!,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: isSelected ? const Color(0xFF231F20) : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAwbTracker(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withAlpha(12)),
        boxShadow: const [
          BoxShadow(color: Color(0x06000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(TablerIcons.truck, size: 16, color: Color(0xFF18191D)),
              SizedBox(width: 6),
              Text(
                'Lacak Pengiriman Pesanan (AWB)',
                style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: Color(0xFF18191D)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 38,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black.withAlpha(15)),
                  ),
                  alignment: Alignment.center,
                  child: TextField(
                    controller: _awbController,
                    style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      hintText: 'Masukkan nomor resi J&T / ekspedisi...',
                      hintStyle: TextStyle(fontSize: 10.5, color: Colors.grey.shade400),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              NineSpringTap(
                onTap: _trackAwb,
                child: Container(
                  height: 38,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Lacak Resi',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF18191D)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCarousel(BuildContext context, MallState mallState) {
    final bannerSubtitle = mallState.products.isNotEmpty
        ? 'Tersedia ${mallState.products.length}+ Varian Terverifikasi nine_try_db'
        : 'Garansi Ganti Baru 24 Bulan • Kirim ke Seluruh Indonesia';

    return Container(
      height: 126,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withAlpha(20)),
        boxShadow: const [
          BoxShadow(color: Color(0x12000000), blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF8DC63F),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'NINE AUTOSERIES OFFICIAL STORE',
                  style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.w900, color: Color(0xFF18191D)),
                ),
              ),
              const Icon(TablerIcons.chevron_right, color: Colors.white, size: 16),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Katalog Suku Cadang Resmi 2026',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 2),
              Text(
                bannerSubtitle,
                style: const TextStyle(fontSize: 10, color: Colors.white70),
              ),
            ],
          ),
          // Dot indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 14, height: 3, decoration: BoxDecoration(color: const Color(0xFF8DC63F), borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 4),
              Container(width: 4, height: 3, decoration: BoxDecoration(color: Colors.white38, borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 4),
              Container(width: 4, height: 3, decoration: BoxDecoration(color: Colors.white38, borderRadius: BorderRadius.circular(2))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExploreProducts(BuildContext context, MallState mallState) {
    final productList = mallState.filteredProducts.isNotEmpty
        ? mallState.filteredProducts
        : mallState.products;
    final p1 = productList.isNotEmpty ? productList[0] : null;
    final p2 = productList.length > 1 ? productList[1] : null;

    final p1Title = p1?.name ?? 'Lampu LED Mobil X9 (H4 H11 HB3 H7) Series';
    final p1Subtitle = (p1?.subtitle.isNotEmpty ?? false) ? p1!.subtitle : (p1?.productName ?? 'Headlamp Foglamp LED Mobil X9');
    final p1Price = p1 != null ? _formatRupiah(p1.discPrice) : 'Rp 319.900';
    final p1Orig = p1 != null ? _formatRupiah(p1.price) : 'Rp 447.000';
    final p1Discount = p1 != null && p1.price > p1.discPrice
        ? '-${((p1.price - p1.discPrice) / p1.price * 100).round()}%'
        : '-28%';
    final p1Tag = p1?.productName.toUpperCase() ?? 'HEADLIGHT';

    final p2Title = p2?.name ?? 'Lampu LED Mobil H11 V8 PRO Laser';
    final p2Subtitle = (p2?.subtitle.isNotEmpty ?? false) ? p2!.subtitle : (p2?.productName ?? 'Headlamp Foglamp LED Mobil HB4');
    final p2Price = p2 != null ? _formatRupiah(p2.discPrice) : 'Rp 649.902';
    final p2Orig = p2 != null ? _formatRupiah(p2.price) : 'Rp 909.000';
    final p2Discount = p2 != null && p2.price > p2.discPrice
        ? '-${((p2.price - p2.discPrice) / p2.price * 100).round()}%'
        : '-29%';
    final p2Tag = p2?.productName.toUpperCase() ?? 'HEADLIGHT';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'JELAJAHI PRODUK KAMI',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF231F20), letterSpacing: 0.8),
            ),
            Text(
              'Lihat Semua >',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF18191D)),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Horizontal Category Cards
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _exploreCategories.map((cat) {
              final isSelected = cat['id'] == _activeExploreCategory;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: NineSpringTap(
                  onTap: () => setState(() => _activeExploreCategory = cat['id'] as String),
                  child: Container(
                    width: 88,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF8DC63F) : Colors.black.withAlpha(12),
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: const [
                        BoxShadow(color: Color(0x06000000), blurRadius: 8, offset: Offset(0, 2)),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(cat['icon'] as IconData, size: 18, color: const Color(0xFF231F20)),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          cat['label'] as String,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                            color: const Color(0xFF231F20),
                            height: 1.15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 10),

        // Subcategory Underline Tabs
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _subcategories.map((sub) {
              final isSelected = sub['id'] == _activeSubcategory;
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: NineSpringTap(
                  onTap: () => setState(() => _activeSubcategory = sub['id']!),
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 6),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isSelected ? const Color(0xFF8DC63F) : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      sub['label']!,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        color: isSelected ? const Color(0xFF231F20) : Colors.grey.shade500,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 12),

        // 2-Column Product Grid
        Row(
          children: [
            Expanded(
              child: _buildMallProductCard(
                categoryTag: p1Tag,
                title: p1Title,
                subtitle: p1Subtitle,
                price: p1Price,
                originalPrice: p1Orig,
                discount: p1Discount,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildMallProductCard(
                categoryTag: p2Tag,
                title: p2Title,
                subtitle: p2Subtitle,
                price: p2Price,
                originalPrice: p2Orig,
                discount: p2Discount,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVoucherSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'VOUCHER BELANJA',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF231F20), letterSpacing: 0.8),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildMallTicket(
                amount: '100Rb',
                unit: 'OFF',
                code: 'PAKET100K',
                title: 'Diskon Belanja Suku Cadang',
                subtitle: 'Min. belanja Rp 1.500.000',
              ),
              const SizedBox(width: 10),
              _buildMallTicket(
                amount: 'GRATIS',
                unit: 'ONGKIR',
                code: 'ONGKIRFREE',
                title: 'Gratis Ongkir Seluruh Jawa',
                subtitle: 'Min. belanja Rp 250.000',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMallTicket({
    required String amount,
    required String unit,
    required String code,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: 260,
      height: 86,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withAlpha(15)),
        boxShadow: const [
          BoxShadow(color: Color(0x06000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Container(
            width: 72,
            color: const Color(0xFF231F20),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(amount, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white)),
                Text(unit, style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.w800, color: Color(0xFF8DC63F))),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
                      Text(subtitle, style: TextStyle(fontSize: 9.5, color: Colors.grey.shade600)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFF10B981), width: 0.8),
                    ),
                    child: Text(code, style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.w900, color: Color(0xFF047857))),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlashSaleSection(BuildContext context, MallState mallState) {
    final p3 = mallState.products.length > 2 ? mallState.products[2] : null;
    final p4 = mallState.products.length > 3 ? mallState.products[3] : null;

    final p3Title = p3?.name ?? 'Luminos Shooting Light Q9 Pro Dual Lens';
    final p3Subtitle = (p3?.subtitle.isNotEmpty ?? false) ? p3!.subtitle : (p3?.productName ?? 'Laser LED High Power 80W');
    final p3Price = p3 != null ? _formatRupiah(p3.discPrice) : 'Rp 1.850.000';
    final p3Orig = p3 != null ? _formatRupiah(p3.price) : 'Rp 2.450.000';
    final p3Discount = p3 != null && p3.price > p3.discPrice
        ? '-${((p3.price - p3.discPrice) / p3.price * 100).round()}%'
        : '-24%';
    final p3Tag = p3?.productName.toUpperCase() ?? 'SHOOTING LIGHT';

    final p4Title = p4?.name ?? 'BiLED Matrix Pro 3.0" Laser Projector';
    final p4Subtitle = (p4?.subtitle.isNotEmpty ?? false) ? p4!.subtitle : (p4?.productName ?? 'Paket Lensa Ganda Ultra Wide');
    final p4Price = p4 != null ? _formatRupiah(p4.discPrice) : 'Rp 2.450.000';
    final p4Orig = p4 != null ? _formatRupiah(p4.price) : 'Rp 3.100.000';
    final p4Discount = p4 != null && p4.price > p4.discPrice
        ? '-${((p4.price - p4.discPrice) / p4.price * 100).round()}%'
        : '-21%';
    final p4Tag = p4?.productName.toUpperCase() ?? 'PROJECTOR';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'FLASH SALE NINE MALL',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF231F20), letterSpacing: 0.8),
            ),
            Text(
              'Lihat Semua >',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF18191D)),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildMallProductCard(
                categoryTag: p3Tag,
                title: p3Title,
                subtitle: p3Subtitle,
                price: p3Price,
                originalPrice: p3Orig,
                discount: p3Discount,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildMallProductCard(
                categoryTag: p4Tag,
                title: p4Title,
                subtitle: p4Subtitle,
                price: p4Price,
                originalPrice: p4Orig,
                discount: p4Discount,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMallProductCard({
    required String categoryTag,
    required String title,
    required String subtitle,
    required String price,
    required String originalPrice,
    required String discount,
  }) {
    return NineSpringTap(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Membuka PDP: $title')),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black.withAlpha(15)),
          boxShadow: const [
            BoxShadow(color: Color(0x06000000), blurRadius: 8, offset: Offset(0, 2)),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 110,
              color: const Color(0xFFF8FAFC),
              alignment: Alignment.center,
              child: Stack(
                children: [
                  Center(
                    child: Icon(TablerIcons.bolt, size: 36, color: Colors.grey.shade400),
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
                    child: Text(
                      'nine®',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey.shade600),
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
                    categoryTag,
                    style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.w800, color: Color(0xFF6B7280)),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF18191D), height: 1.2),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            originalPrice,
                            style: TextStyle(fontSize: 9, color: Colors.grey.shade400, decoration: TextDecoration.lineThrough),
                          ),
                          Text(
                            price,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF18191D)),
                          ),
                        ],
                      ),
                      NineSpringTap(
                        onTap: () {
                          final state = context.read<MallBloc>().state;
                          if (state.products.isNotEmpty) {
                            final match = state.products.firstWhere(
                              (p) => p.name == title || p.productName == title,
                              orElse: () => state.products.first,
                            );
                            context.read<MallBloc>().add(AddToCartEvent(product: match, quantity: 1));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('$title ditambahkan ke keranjang!'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          }
                        },
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: const Color(0xFF8DC63F),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(TablerIcons.plus, size: 15, color: Color(0xFF14171A)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
