import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:nine_ui_app/nine_ui.dart';
import '../../../../core/theme/app_colors.dart';

/// SCR-26A: Dompet Voucher Kupon Screen (screen-profile-vouchers)
/// Replicates D:\Q4 Planning\design\src\modules\settings\settings.template.html (lines 584-760)
class VouchersScreen extends StatefulWidget {
  const VouchersScreen({super.key});

  @override
  State<VouchersScreen> createState() => _VouchersScreenState();
}

class _VouchersScreenState extends State<VouchersScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: NineSpringTap(
          onTap: () => Navigator.pop(context),
          child: const Center(
            child: Icon(TablerIcons.chevron_left, color: Color(0xFF18191D)),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kupon Saya',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF18191D)),
            ),
            Text(
              '3 Voucher Promo Aktif Tersedia',
              style: TextStyle(fontSize: 10.5, color: Colors.grey.shade600),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF18191D),
          unselectedLabelColor: Colors.grey.shade500,
          labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Tersedia (3)'),
            Tab(text: 'Terpakai (1)'),
            Tab(text: 'Kedaluwarsa (0)'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAvailableVouchersTab(),
          _buildUsedVouchersTab(),
          const Center(child: Text('Tidak ada kupon kedaluwarsa', style: TextStyle(color: Colors.grey))),
        ],
      ),
    );
  }

  Widget _buildAvailableVouchersTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildVoucherItem(
          code: 'PAKET100K',
          title: 'Diskon Rp 100.000 Servis',
          subtitle: 'Min. transaksi Rp 1.500.000 di Nine Garage',
          expiry: 'Berlaku s/d 31 Des 2026',
          discount: '100Rb',
          discountUnit: 'OFF',
          isAvailable: true,
        ),
        const SizedBox(height: 12),
        _buildVoucherItem(
          code: 'ONGKIRFREE',
          title: 'Gratis Ongkir Seluruh Jawa',
          subtitle: 'Khusus pembelian suku cadang di Nine Mall',
          expiry: 'Berlaku s/d 15 Des 2026',
          discount: 'GRATIS',
          discountUnit: 'ONGKIR',
          isAvailable: true,
        ),
        const SizedBox(height: 12),
        _buildVoucherItem(
          code: 'CASHBACK10',
          title: 'Cashback N-Coins 10%',
          subtitle: 'Maksimal 500 N-Coins per instalasi',
          expiry: 'Berlaku s/d 20 Des 2026',
          discount: '10%',
          discountUnit: 'COINS',
          isAvailable: true,
        ),
      ],
    );
  }

  Widget _buildUsedVouchersTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildVoucherItem(
          code: 'WELCOME50K',
          title: 'Diskon Pengguna Baru Rp 50.000',
          subtitle: 'Telah digunakan pada transaksi #BK-SUR-202611',
          expiry: 'Digunakan 04 Nov 2026',
          discount: '50Rb',
          discountUnit: 'OFF',
          isAvailable: false,
        ),
      ],
    );
  }

  Widget _buildVoucherItem({
    required String code,
    required String title,
    required String subtitle,
    required String expiry,
    required String discount,
    required String discountUnit,
    required bool isAvailable,
  }) {
    return Container(
      height: 94,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withAlpha(15)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          // Left Ticket Stub
          Container(
            width: 82,
            color: isAvailable ? const Color(0xFF18191D) : Colors.grey.shade400,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  discount,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                Text(
                  discountUnit,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF8DC63F),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),

          // Right Voucher Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF18191D),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10.5,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        expiry,
                        style: TextStyle(fontSize: 9.5, color: Colors.grey.shade500),
                      ),
                      if (isAvailable)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECFDF5),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF10B981), width: 0.8),
                          ),
                          child: Text(
                            code,
                            style: const TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF047857),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
