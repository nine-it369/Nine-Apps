import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nine_ui_app/nine_ui.dart';
import '../../../../core/router/route_names.dart';
import '../../../profile/presentation/blocs/profile_bloc.dart';
import '../../../profile/presentation/blocs/profile_state.dart';
import '../blocs/mall_bloc.dart';
import '../blocs/mall_event.dart';
import '../blocs/mall_state.dart';

class MallCheckoutScreen extends StatefulWidget {
  const MallCheckoutScreen({super.key});

  @override
  State<MallCheckoutScreen> createState() => _MallCheckoutScreenState();
}

class _MallCheckoutScreenState extends State<MallCheckoutScreen> {
  int _selectedCourierIndex = 0;
  final List<Map<String, dynamic>> _couriers = [
    {'name': 'J&T Express Reguler', 'est': '2 - 3 Hari', 'cost': 18000},
    {'name': 'SiCepat BEST (Next Day)', 'est': '1 Hari', 'cost': 24000},
    {'name': 'GoSend / Grab Instant', 'est': '3 Jam', 'cost': 35000},
  ];

  int _selectedPaymentIndex = 0;
  final List<Map<String, dynamic>> _paymentMethods = [
    {'name': 'BCA Virtual Account', 'icon': TablerIcons.building_bank, 'desc': 'Verifikasi otomatis'},
    {'name': 'Mandiri Virtual Account', 'icon': TablerIcons.building_bank, 'desc': 'Verifikasi otomatis'},
    {'name': 'QRIS Nine AutoPay', 'icon': TablerIcons.qrcode, 'desc': 'Scan dari BCA, GoPay, OVO, Dana'},
    {'name': 'N-Coins (Saldo Poin)', 'icon': TablerIcons.coin, 'desc': 'Gunakan 2.450 Poin aktif'},
  ];

  bool _withWorkshopInstallation = false;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF14171A),
        foregroundColor: Colors.white,
        title: const Text(
          'Checkout Pesanan',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: BlocBuilder<MallBloc, MallState>(
        builder: (context, mallState) {
          final selectedItems = mallState.cartItems.where((i) => i.isSelected).toList();
          final subtotal = mallState.cartSelectedSubtotal;
          final shippingCost = _couriers[_selectedCourierIndex]['cost'] as int;
          final installCost = _withWorkshopInstallation ? 50000 : 0;
          final grandTotal = subtotal + shippingCost + installCost;

          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Alamat Pengiriman
                _buildSectionHeader('ALAMAT PENGIRIMAN'),
                BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, profState) {
                    final primaryAddr = profState.addresses.isNotEmpty
                        ? profState.addresses.firstWhere((a) => a.isPrimary, orElse: () => profState.addresses.first)
                        : null;

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0x10000000)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(TablerIcons.map_pin, size: 20, color: Color(0xFF1C8000)),
                              const SizedBox(width: 8),
                              Text(
                                primaryAddr?.label ?? 'Alamat Rumah Utama',
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF14171A)),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () => context.push(RouteNames.savedAddresses),
                                child: const Text(
                                  'Ubah',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1C8000)),
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 16, color: Color(0x0F000000)),
                          Text(
                            primaryAddr != null
                                ? '${primaryAddr.recipientName} (${primaryAddr.phone})'
                                : 'Aditya Pratama (08123456789)',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            primaryAddr != null
                                ? '${primaryAddr.fullAddress}, ${primaryAddr.city ?? ''} ${primaryAddr.postalCode ?? ''}'
                                : 'Jl. Widara Raya No. 38 D-E, Grogol Petamburan, Jakarta Barat 11460',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.4),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                // 2. Ringkasan Item
                _buildSectionHeader('PRODUK YANG DIBELI (${selectedItems.length})'),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0x10000000)),
                  ),
                  child: Column(
                    children: selectedItems.map((item) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item.product.resolvedImageUrl,
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(width: 48, height: 48, color: Colors.grey.shade200),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '${item.quantity} x ${currencyFormat.format(item.unitPrice)}',
                                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              currencyFormat.format(item.subtotal),
                              style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF14171A)),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 16),

                // 3. Pemasangan di Bengkel Mitra
                _buildSectionHeader('INSTALASI DI BENGKEL NINE'),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0x10000000)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5E9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(TablerIcons.tool, color: Color(0xFF1C8000), size: 20),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pasang di Bengkel Nine®',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Pemasangan rapi bergaransi (+Rp 50.000)',
                              style: TextStyle(fontSize: 11, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Switch.adaptive(
                        value: _withWorkshopInstallation,
                        activeColor: const Color(0xFF8DC63F),
                        onChanged: (val) {
                          setState(() {
                            _withWorkshopInstallation = val;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 4. Opsi Kurir Ekspedisi
                _buildSectionHeader('OPSI PENGIRIMAN'),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0x10000000)),
                  ),
                  child: Column(
                    children: List.generate(_couriers.length, (idx) {
                      final c = _couriers[idx];
                      final isSel = _selectedCourierIndex == idx;
                      return Column(
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                            leading: Radio<int>(
                              value: idx,
                              groupValue: _selectedCourierIndex,
                              activeColor: const Color(0xFF8DC63F),
                              onChanged: (val) => setState(() => _selectedCourierIndex = val ?? 0),
                            ),
                            title: Text(
                              c['name'] as String,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                              ),
                            ),
                            subtitle: Text('Estimasi ${c['est']}', style: const TextStyle(fontSize: 11)),
                            trailing: Text(
                              currencyFormat.format(c['cost']),
                              style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF1C8000)),
                            ),
                            onTap: () => setState(() => _selectedCourierIndex = idx),
                          ),
                          if (idx < _couriers.length - 1)
                            const Divider(height: 1, indent: 54, color: Color(0x0F000000)),
                        ],
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 16),

                // 5. Metode Pembayaran
                _buildSectionHeader('METODE PEMBAYARAN'),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0x10000000)),
                  ),
                  child: Column(
                    children: List.generate(_paymentMethods.length, (idx) {
                      final p = _paymentMethods[idx];
                      final isSel = _selectedPaymentIndex == idx;
                      return Column(
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                            leading: Radio<int>(
                              value: idx,
                              groupValue: _selectedPaymentIndex,
                              activeColor: const Color(0xFF8DC63F),
                              onChanged: (val) => setState(() => _selectedPaymentIndex = val ?? 0),
                            ),
                            title: Text(
                              p['name'] as String,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(p['desc'] as String, style: const TextStyle(fontSize: 11)),
                            onTap: () => setState(() => _selectedPaymentIndex = idx),
                          ),
                          if (idx < _paymentMethods.length - 1)
                            const Divider(height: 1, indent: 54, color: Color(0x0F000000)),
                        ],
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 16),

                // 6. Rincian Tagihan
                _buildSectionHeader('RINCIAN TAGIHAN'),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0x10000000)),
                  ),
                  child: Column(
                    children: [
                      _buildSummaryRow('Subtotal Produk', currencyFormat.format(subtotal)),
                      const SizedBox(height: 8),
                      _buildSummaryRow('Biaya Pengiriman', currencyFormat.format(shippingCost)),
                      if (_withWorkshopInstallation) ...[
                        const SizedBox(height: 8),
                        _buildSummaryRow('Jasa Pasang di Bengkel Nine', currencyFormat.format(installCost)),
                      ],
                      const Divider(height: 24, color: Color(0x14000000)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Pembayaran',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF14171A)),
                          ),
                          Text(
                            currencyFormat.format(grandTotal),
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1C8000),
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
        },
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 16,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: NineSpringTap(
          onTap: () => _handlePaymentSuccess(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF8DC63F),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: Text(
                'Bayar Sekarang',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF14171A)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handlePaymentSuccess(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5DC),
                  shape: BoxShape.circle,
                ),
                child: const Icon(TablerIcons.check, color: Color(0xFF1C8000), size: 36),
              ),
              const SizedBox(height: 16),
              const Text(
                'Pesanan Berhasil Dibuat!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF14171A)),
              ),
              const SizedBox(height: 6),
              Text(
                'Invoice #ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)} telah diterbitkan dan sedang disiapkan oleh gudang.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.4),
              ),
              const SizedBox(height: 20),
              NineSpringTap(
                onTap: () {
                  Navigator.of(dialogCtx).pop();
                  context.read<MallBloc>().add(const ClearCartEvent());
                  context.push(RouteNames.orderHistory);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF14171A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      'Lihat Riwayat Pesanan',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w900,
          color: Color(0xFF6B7280),
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 12.5, color: Colors.grey.shade700)),
        Text(value, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Color(0xFF14171A))),
      ],
    );
  }
}
