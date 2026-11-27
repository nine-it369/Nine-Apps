import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nine_ui_app/nine_ui.dart';
import '../../../../core/router/route_names.dart';
import '../blocs/mall_bloc.dart';
import '../blocs/mall_event.dart';
import '../blocs/mall_state.dart';

class MallCartScreen extends StatelessWidget {
  const MallCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF14171A),
        foregroundColor: Colors.white,
        title: const Text(
          'Keranjang Belanja',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(TablerIcons.trash, size: 20),
            tooltip: 'Kosongkan Keranjang',
            onPressed: () {
              context.read<MallBloc>().add(const ClearCartEvent());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Keranjang belanja dikosongkan')),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<MallBloc, MallState>(
        builder: (context, state) {
          final items = state.cartItems;

          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(TablerIcons.shopping_cart_x, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  const Text(
                    'Keranjang Belanja Masih Kosong',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF14171A)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Jelajahi suku cadang dan lampu berkualitas di Nine Mall',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 20),
                  NineSpringTap(
                    onTap: () => context.pop(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8DC63F),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Mulai Belanja',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF14171A)),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          final allSelected = items.every((i) => i.isSelected);

          return Column(
            children: [
              // Warehouse Header / Select All Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: Color(0x0F000000))),
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: allSelected,
                      activeColor: const Color(0xFF8DC63F),
                      checkColor: const Color(0xFF14171A),
                      onChanged: (val) {
                        context.read<MallBloc>().add(ToggleAllCartSelectionEvent(val ?? true));
                      },
                    ),
                    const SizedBox(width: 4),
                    const Icon(TablerIcons.building_warehouse, size: 18, color: Color(0xFF1C8000)),
                    const SizedBox(width: 6),
                    const Text(
                      'Gudang Utama Jakarta',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF14171A)),
                    ),
                  ],
                ),
              ),

              // Item List
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: item.isSelected ? const Color(0xFF8DC63F) : const Color(0x10000000),
                          width: item.isSelected ? 1.5 : 1.0,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x04000000),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: item.isSelected,
                                activeColor: const Color(0xFF8DC63F),
                                checkColor: const Color(0xFF14171A),
                                onChanged: (_) {
                                  context.read<MallBloc>().add(ToggleCartItemSelectionEvent(item.id));
                                },
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  item.product.resolvedImageUrl,
                                  width: 68,
                                  height: 68,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    width: 68,
                                    height: 68,
                                    color: Colors.grey.shade200,
                                    child: const Icon(TablerIcons.photo_off, color: Colors.grey),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.product.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, height: 1.2),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'SKU: ${item.product.sku}',
                                      style: TextStyle(fontSize: 10, color: Colors.grey.shade600, fontFamily: 'monospace'),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      currencyFormat.format(item.unitPrice),
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFF1C8000),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(TablerIcons.x, size: 18, color: Colors.grey),
                                onPressed: () {
                                  context.read<MallBloc>().add(RemoveCartItemEvent(item.id));
                                },
                              ),
                            ],
                          ),
                          const Divider(height: 16, color: Color(0x0F000000)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Installation badge indicator
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: item.withInstallation ? const Color(0xFFE8F5DC) : const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  item.withInstallation ? '+ Pasang di Bengkel Nine' : 'Kirim Ekspedisi Saja',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.bold,
                                    color: item.withInstallation ? const Color(0xFF1C8000) : Colors.grey.shade700,
                                  ),
                                ),
                              ),

                              // Quantity Stepper
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAF6),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.black.withAlpha(15)),
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove, size: 14),
                                      constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        if (item.quantity > 1) {
                                          context.read<MallBloc>().add(
                                                UpdateCartQuantityEvent(cartItemId: item.id, delta: -1),
                                              );
                                        }
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text(
                                        '${item.quantity}',
                                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add, size: 14),
                                      constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        context.read<MallBloc>().add(
                                              UpdateCartQuantityEvent(cartItemId: item.id, delta: 1),
                                            );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Bottom Sticky Checkout Bar
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
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
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Pembayaran',
                          style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          currencyFormat.format(state.cartSelectedSubtotal),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF14171A),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    NineSpringTap(
                      onTap: state.cartSelectedCount > 0
                          ? () => context.push(RouteNames.mallCheckout)
                          : () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Pilih minimal 1 produk untuk checkout')),
                              );
                            },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          color: state.cartSelectedCount > 0 ? const Color(0xFF8DC63F) : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          'Checkout (${state.cartSelectedCount})',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: state.cartSelectedCount > 0 ? const Color(0xFF14171A) : Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
