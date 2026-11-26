import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_time_utils.dart';
import '../../../../shared/widgets/bento/bento_card.dart';
import '../../../../shared/widgets/controls/nine_text_field.dart';
import '../../../../shared/widgets/pills/borderless_status_tag.dart';
import '../../domain/entities/voucher_entity.dart';
import '../blocs/booking_state.dart';

class ReviewSectionWidget extends StatefulWidget {
  final BookingState state;
  final ValueChanged<VoucherEntity> onApplyVoucher;
  final ValueChanged<String> onApplyVoucherCode;
  final VoidCallback onRemoveVoucher;

  const ReviewSectionWidget({
    super.key,
    required this.state,
    required this.onApplyVoucher,
    required this.onApplyVoucherCode,
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

  String _formatCountdown(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Slot Lock Countdown Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: AppRadius.buttonRadius,
            ),
            child: Row(
              children: [
                const Icon(Icons.timer_outlined, color: Color(0xFFB45309), size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Slot Anda ditahan sementara. Segera konfirmasi dalam:',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: const Color(0xFF92400E),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  _formatCountdown(state.reviewSecondsRemaining),
                  style: AppTextStyles.mono.copyWith(
                    color: const Color(0xFFB45309),
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          Text('Konfirmasi & Ringkasan Booking', style: AppTextStyles.h2),
          const SizedBox(height: 4),
          Text(
            'Pastikan seluruh data kendaraan, jadwal, dan layanan sudah benar.',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 14),

          BentoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Data Pelanggan & Kendaraan', style: AppTextStyles.h3),
                    BorderlessStatusTag.info(
                      state.vehicleType == 'car' ? 'MOBIL' : 'MOTOR',
                    ),
                  ],
                ),
                const Divider(height: 20, color: AppColors.borderSubtle),
                _buildInfoRow('Nama', state.customerName),
                _buildInfoRow('WhatsApp', state.customerPhone),
                if (state.customerEmail.isNotEmpty) _buildInfoRow('Email', state.customerEmail),
                _buildInfoRow('Kota', state.cityName),
                _buildInfoRow('Alamat', state.custAddress),
                _buildInfoRow('Kendaraan', '${state.vehicleModel} (${state.vehicleColor})'),
                _buildInfoRow('Nomor Polisi', state.vehiclePlat),
              ],
            ),
          ),

          const SizedBox(height: 12),

          BentoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Jadwal & Lokasi Servis', style: AppTextStyles.h3),
                    const Icon(Icons.calendar_month_rounded, color: AppColors.primaryDark, size: 20),
                  ],
                ),
                const Divider(height: 20, color: AppColors.borderSubtle),
                _buildInfoRow('Cabang Bengkel', state.selectedWorkshop?.name ?? '-'),
                _buildInfoRow(
                  'Tanggal Kedatangan',
                  state.selectedDate != null
                      ? DateTimeUtils.formatDisplayDate(state.selectedDate!)
                      : '-',
                ),
                _buildInfoRow('Jam Kedatangan', '${state.selectedHour ?? "-"} WIB'),
                _buildInfoRow('Estimasi Pengerjaan', '~${state.estimatedMinutes} menit'),
              ],
            ),
          ),

          const SizedBox(height: 12),

          BentoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Rincian Layanan & Paket', style: AppTextStyles.h3),
                const Divider(height: 20, color: AppColors.borderSubtle),
                ...state.selectedServices.map((service) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(service.name, style: AppTextStyles.bodyMedium)),
                        Text(
                          CurrencyFormatter.format(service.nowPrice),
                          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  );
                }),
                ...state.selectedPackages.map((pkg) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text('[Paket] ${pkg.name}', style: AppTextStyles.bodyMedium)),
                        Text(
                          CurrencyFormatter.format(pkg.effectivePrice(state.isEv)),
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

          BentoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Voucher Promo Tersedia', style: AppTextStyles.h3),
                const SizedBox(height: 8),
                if (state.appliedVoucher != null)
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
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(Icons.local_offer_rounded, color: AppColors.primaryDark, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${state.appliedVoucher!.code} (-${CurrencyFormatter.format(state.voucherDiscount)})',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primaryDark,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: widget.onRemoveVoucher,
                          icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.danger),
                        ),
                      ],
                    ),
                  )
                else ...[
                  if (state.availableVouchers.isNotEmpty) ...[
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: state.availableVouchers.map((v) {
                        return ActionChip(
                          avatar: const Icon(Icons.confirmation_number_outlined, size: 16),
                          label: Text(v.code, style: AppTextStyles.mono.copyWith(fontSize: 11)),
                          onPressed: state.isValidatingVoucher ? null : () => widget.onApplyVoucher(v),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: NineTextField(
                          hint: 'Masukkan kode voucher',
                          controller: _voucherController,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: state.isValidatingVoucher
                            ? null
                            : () {
                                if (_voucherController.text.trim().isNotEmpty) {
                                  widget.onApplyVoucherCode(_voucherController.text);
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.obsidian,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: AppRadius.buttonRadius),
                        ),
                        child: state.isValidatingVoucher
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Text('Pakai'),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 12),

          BentoCard(
            backgroundColor: AppColors.obsidian,
            child: Column(
              children: [
                _buildPriceRow('Subtotal Biaya', CurrencyFormatter.format(state.subTotal)),
                if (state.voucherDiscount > 0)
                  _buildPriceRow(
                    'Diskon Voucher',
                    '- ${CurrencyFormatter.format(state.voucherDiscount)}',
                    highlightColor: AppColors.primary,
                  ),
                const Divider(height: 16, color: Colors.white24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Estimasi Biaya',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      CurrencyFormatter.format(state.totalAmount),
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

  Widget _buildPriceRow(String label, String value, {Color? highlightColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70)),
          Text(
            value,
            style: AppTextStyles.bodyLarge.copyWith(
              color: highlightColor ?? Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
