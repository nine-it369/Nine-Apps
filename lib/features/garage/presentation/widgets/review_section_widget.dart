import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_time_utils.dart';
import '../../../../shared/widgets/bento/bento_card.dart';
import '../../../../shared/widgets/controls/nine_text_field.dart';
import '../../../../shared/widgets/pills/borderless_status_tag.dart';
import '../blocs/booking_state.dart';

class ReviewSectionWidget extends StatefulWidget {
  final BookingState state;
  final ValueChanged<String> onApplyVoucher;
  final VoidCallback onRemoveVoucher;

  const ReviewSectionWidget({
    super.key,
    required this.state,
    required this.onApplyVoucher,
    required this.onRemoveVoucher,
  });

  @override
  State<ReviewSectionWidget> createState() => _ReviewSectionWidgetState();
}

class _ReviewSectionWidgetState extends State<ReviewSectionWidget> {
  final _voucherController = TextEditingController();

  @override
  void dispose() {
    _voucherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Konfirmasi & Ringkasan Booking', style: AppTextStyles.h2),
          const SizedBox(height: 6),
          Text(
            'Periksa kembali data reservasi sebelum menerbitkan Digital SPK.',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 16),

          // 1. Pelanggan & Kendaraan Bento Card
          BentoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Data Pelanggan & Kendaraan', style: AppTextStyles.h3),
                    BorderlessStatusTag.info(state.vehicleCategory.toUpperCase()),
                  ],
                ),
                const Divider(height: 20, color: AppColors.borderSubtle),
                _buildInfoRow('Nama Pelanggan', state.customerName),
                _buildInfoRow('Nomor WhatsApp', state.customerPhone),
                if (state.customerEmail.isNotEmpty)
                  _buildInfoRow('Email', state.customerEmail),
                _buildInfoRow('Kendaraan', '${state.vehicleBrand} ${state.vehicleModel} (${state.transmissionType.toUpperCase()})'),
                _buildInfoRow('Nomor Polisi', state.licensePlate),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // 2. Jadwal & Lokasi Bengkel
          BentoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Jadwal & Lokasi Servis', style: AppTextStyles.h3),
                    const Icon(Icons.calendar_month_rounded, color: AppColors.primary, size: 20),
                  ],
                ),
                const Divider(height: 20, color: AppColors.borderSubtle),
                _buildInfoRow('Cabang Bengkel', state.selectedWorkshop?.name ?? '-'),
                _buildInfoRow('Alamat Cabang', state.selectedWorkshop?.address ?? '-'),
                _buildInfoRow(
                  'Tanggal Kedatangan',
                  state.selectedDate != null
                      ? DateTimeUtils.formatDisplayDate(state.selectedDate!)
                      : '-',
                ),
                _buildInfoRow('Jam Kedatangan', '${state.selectedTimeSlot ?? "-"} WIB'),
                _buildInfoRow('Estimasi Pengerjaan', '~${state.estimatedDurationMinutes} menit'),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // 3. Layanan Terpilih
          BentoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Layanan yang Dipesan', style: AppTextStyles.h3),
                    Text('${state.selectedServices.length} Item', style: AppTextStyles.bodySmall),
                  ],
                ),
                const Divider(height: 20, color: AppColors.borderSubtle),
                ...state.selectedServices.map((service) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(service.name, style: AppTextStyles.bodyMedium),
                        ),
                        Text(
                          CurrencyFormatter.format(service.nowPrice),
                          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // 4. Voucher Discount Section
          BentoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Kode Promo & Voucher', style: AppTextStyles.h3),
                const SizedBox(height: 8),
                if (state.appliedVoucherCode != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7FBF2),
                      borderRadius: AppRadius.buttonRadius,
                      border: Border.all(color: AppColors.primary),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.local_offer_rounded, color: AppColors.primaryDark, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              state.appliedVoucherCode!,
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: widget.onRemoveVoucher,
                          icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.danger),
                        ),
                      ],
                    ),
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: NineTextField(
                          hint: 'Ketik NINE50K atau NINE100K',
                          controller: _voucherController,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          if (_voucherController.text.trim().isNotEmpty) {
                            widget.onApplyVoucher(_voucherController.text);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.obsidian,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: AppRadius.buttonRadius),
                        ),
                        child: const Text('Gunakan'),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // 5. Total Price Breakdown
          BentoCard(
            backgroundColor: AppColors.obsidian,
            child: Column(
              children: [
                _buildPriceRow('Subtotal Biaya Jasa', CurrencyFormatter.format(state.subtotalPrice), isDark: true),
                if (state.voucherDiscount > 0)
                  _buildPriceRow(
                    'Diskon Voucher',
                    '- ${CurrencyFormatter.format(state.voucherDiscount)}',
                    isDark: true,
                    highlightColor: AppColors.primary,
                  ),
                const Divider(height: 16, color: Colors.white24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Estimasi Biaya',
                      style: AppTextStyles.bodyLarge.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      CurrencyFormatter.format(state.totalPrice),
                      style: AppTextStyles.h2.copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodySmall),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isDark = false, Color? highlightColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isDark ? Colors.white70 : AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodyLarge.copyWith(
              color: highlightColor ?? (isDark ? Colors.white : AppColors.textPrimary),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
