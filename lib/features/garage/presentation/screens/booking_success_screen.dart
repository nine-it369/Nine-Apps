import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/widgets/bento/bento_card.dart';
import '../../../../shared/widgets/buttons/nine_primary_button.dart';
import '../../../../shared/widgets/pills/borderless_status_tag.dart';
import '../../domain/entities/booking_entity.dart';

class BookingSuccessScreen extends StatelessWidget {
  final BookingEntity? booking;

  const BookingSuccessScreen({super.key, this.booking});

  @override
  Widget build(BuildContext context) {
    final ticket = booking?.bookingTicket ?? 'BK-2026-1123-8891';

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Konfirmasi Booking', style: AppTextStyles.h3),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            // Success Icon Bubble
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFFE8F7D4),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                size: 52,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Reservasi Servis Berhasil!',
              style: AppTextStyles.h1.copyWith(fontSize: 22),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'Digital Work Order (SPK) Anda telah diterbitkan ke sistem Nine Garage.',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Digital Ticket Bento Card
            BentoCard(
              backgroundColor: AppColors.obsidian,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'DIGITAL WORK ORDER',
                        style: AppTextStyles.mono.copyWith(
                          color: AppColors.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      BorderlessStatusTag.success('TERJADWAL'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    ticket,
                    style: AppTextStyles.mono.copyWith(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tunjukkan tiket ini saat tiba di resepsionis bengkel',
                    style: AppTextStyles.bodySmall.copyWith(color: Colors.white60),
                  ),
                  const Divider(height: 24, color: Colors.white24),
                  _buildTicketRow('Pelanggan', booking?.customerName ?? 'Pelanggan Nine'),
                  _buildTicketRow('Kendaraan', '${booking?.vehicleBrand ?? "Toyota"} ${booking?.vehicleModel ?? "Mobil"} (${booking?.licensePlate ?? "B 1234 NNE"})'),
                  _buildTicketRow('Cabang Bengkel', booking?.workshopName ?? 'Arcadia Daan Mogot'),
                  _buildTicketRow('Jadwal', '${booking?.bookingDate ?? "Besok"}, ${booking?.timeSlot ?? "10:00"} WIB'),
                  _buildTicketRow('Total Biaya', CurrencyFormatter.format(booking?.totalPrice ?? 0), isHighlighted: true),
                ],
              ),
            ),

            const SizedBox(height: 32),

            NinePrimaryButton(
              label: 'Kembali ke Beranda Garage',
              icon: Icons.home_rounded,
              onPressed: () => context.go(RouteNames.garage),
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
