import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/widgets/bento/bento_card.dart';
import '../../../../shared/widgets/buttons/nine_primary_button.dart';
import '../../../../shared/widgets/buttons/nine_secondary_button.dart';
import '../../../../shared/widgets/pills/borderless_status_tag.dart';
import '../../domain/entities/booking_entity.dart';

class BookingSuccessScreen extends StatelessWidget {
  final BookingEntity? booking;

  const BookingSuccessScreen({super.key, this.booking});

  @override
  Widget build(BuildContext context) {
    final ticket = booking?.bookingTicket ?? 'TGR-2026-0000';

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Konfirmasi Booking', style: AppTextStyles.h3),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: Color(0xFFE8F7D4),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                size: 46,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Reservasi Servis Berhasil!',
              style: AppTextStyles.h1.copyWith(fontSize: 22),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'Digital Work Order (SPK) Anda telah tercatat di sistem bengkel Nine Garage.',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            BentoCard(
              backgroundColor: AppColors.obsidian,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'DIGITAL WORK ORDER',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.mono.copyWith(
                            color: AppColors.primary,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      BorderlessStatusTag.success(
                        (booking?.status ?? 'pending').toUpperCase(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppRadius.squircleRadius,
                    ),
                    child: QrImageView(
                      data: ticket,
                      version: QrVersions.auto,
                      size: 140,
                      eyeStyle: const QrEyeStyle(
                        eyeShape: QrEyeShape.square,
                        color: AppColors.obsidian,
                      ),
                      dataModuleStyle: const QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.square,
                        color: AppColors.obsidian,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    ticket,
                    style: AppTextStyles.mono.copyWith(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tunjukkan QR Code ini saat check-in di resepsionis bengkel',
                    style: AppTextStyles.bodySmall.copyWith(color: Colors.white60),
                    textAlign: TextAlign.center,
                  ),
                  const Divider(height: 24, color: Colors.white24),
                  _buildTicketRow('Pelanggan', booking?.customerName ?? '-'),
                  _buildTicketRow('WhatsApp', booking?.customerPhone ?? '-'),
                  _buildTicketRow(
                    'Kendaraan',
                    '${booking?.vehicleModel ?? "-"} (${booking?.vehiclePlat ?? "-"})',
                  ),
                  _buildTicketRow(
                    'Jadwal',
                    '${booking?.bookingDate ?? "-"}, ${booking?.hour ?? "-"} WIB',
                  ),
                  if (booking != null && booking!.itemNames.isNotEmpty)
                    _buildTicketRow('Layanan', booking!.itemNames.join(', ')),
                  _buildTicketRow(
                    'Total Estimasi',
                    CurrencyFormatter.format(booking?.totalAmount ?? 0),
                    isHighlighted: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            NinePrimaryButton(
              label: 'Kembali ke Beranda Garage',
              icon: Icons.home_rounded,
              onPressed: () => context.go(RouteNames.garage),
            ),
            const SizedBox(height: 10),
            NineSecondaryButton(
              label: 'Cek Tiket SPK Lainnya',
              icon: Icons.qr_code_scanner_rounded,
              onPressed: () => context.pushReplacement(RouteNames.ticketLookup, extra: ticket),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketRow(String label, String value, {bool isHighlighted = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodySmall.copyWith(color: Colors.white70)),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isHighlighted ? AppColors.primary : Colors.white,
                fontWeight: isHighlighted ? FontWeight.w800 : FontWeight.w600,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
