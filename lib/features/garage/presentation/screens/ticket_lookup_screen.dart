import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/widgets/bento/bento_card.dart';
import '../../../../shared/widgets/buttons/nine_primary_button.dart';
import '../../../../shared/widgets/buttons/nine_secondary_button.dart';
import '../../../../shared/widgets/controls/nine_text_field.dart';
import '../../../../shared/widgets/pills/borderless_status_tag.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/usecases/get_booking_by_ticket_usecase.dart';

class TicketLookupScreen extends StatefulWidget {
  final String? initialTicket;
  const TicketLookupScreen({super.key, this.initialTicket});

  @override
  State<TicketLookupScreen> createState() => _TicketLookupScreenState();
}

class _TicketLookupScreenState extends State<TicketLookupScreen> {
  late final TextEditingController _ticketController;
  bool _isLoading = false;
  String? _error;
  BookingEntity? _booking;

  @override
  void initState() {
    super.initState();
    _ticketController = TextEditingController(text: widget.initialTicket ?? '');
    if (widget.initialTicket != null && widget.initialTicket!.isNotEmpty) {
      _lookupTicket(widget.initialTicket!);
    }
  }

  @override
  void dispose() {
    _ticketController.dispose();
    super.dispose();
  }

  Future<void> _lookupTicket(String ticket) async {
    final clean = ticket.trim().toUpperCase();
    if (clean.isEmpty) {
      setState(() => _error = 'Masukkan nomor tiket SPK Anda terlebih dahulu.');
      return;
    }
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final useCase = sl<GetBookingByTicketUseCase>();
    final result = await useCase(clean);

    if (!mounted) return;
    result.fold(
      (failure) => setState(() {
        _isLoading = false;
        _error = failure.message;
        _booking = null;
      }),
      (data) => setState(() {
        _isLoading = false;
        _booking = data;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        title: Text('Cek Digital SPK', style: AppTextStyles.h3),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BentoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Lacak Status Servis Bengkel', style: AppTextStyles.h3),
                  const SizedBox(height: 6),
                  Text(
                    'Masukkan kode tiket SPK untuk melihat antrean pit, jadwal, dan QR Code.',
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  NineTextField(
                    label: 'Nomor Tiket Booking / SPK',
                    hint: 'Contoh: TGR-20261126-XXXX',
                    controller: _ticketController,
                    prefixIcon: const Icon(Icons.confirmation_number_outlined, size: 20),
                  ),
                  const SizedBox(height: 12),
                  NinePrimaryButton(
                    label: 'Cari Tiket SPK',
                    icon: Icons.search_rounded,
                    isLoading: _isLoading,
                    onPressed: () => _lookupTicket(_ticketController.text),
                  ),
                ],
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 16),
              BentoCard(
                backgroundColor: const Color(0xFFFEE2E2),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline_rounded, color: AppColors.danger),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _error!,
                        style: AppTextStyles.bodyMedium.copyWith(color: const Color(0xFFB91C1C)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (_booking != null) ...[
              const SizedBox(height: 16),
              BentoCard(
                backgroundColor: AppColors.obsidian,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _booking!.bookingTicket ?? '-',
                          style: AppTextStyles.mono.copyWith(color: AppColors.primary, fontSize: 15),
                        ),
                        BorderlessStatusTag.success(_booking!.status.toUpperCase()),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: AppRadius.squircleRadius,
                      ),
                      child: QrImageView(
                        data: _booking!.bookingTicket ?? '-',
                        size: 120,
                      ),
                    ),
                    const Divider(height: 24, color: Colors.white24),
                    _row('Pelanggan', _booking!.customerName),
                    _row('Kendaraan', '${_booking!.vehicleModel} (${_booking!.vehiclePlat})'),
                    _row('Jadwal', '${_booking!.bookingDate}, ${_booking!.hour} WIB'),
                    if (_booking!.itemNames.isNotEmpty)
                      _row('Layanan', _booking!.itemNames.join(', ')),
                    _row('Total', CurrencyFormatter.format(_booking!.totalAmount), highlight: true),
                    const SizedBox(height: 16),
                    NineSecondaryButton(
                      label: 'Ubah Jadwal Reservasi',
                      icon: Icons.edit_calendar_rounded,
                      onPressed: () {
                        context.push(RouteNames.booking, extra: _booking!.bookingTicket);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _row(String k, String v, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(k, style: AppTextStyles.bodySmall.copyWith(color: Colors.white70)),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              v,
              style: AppTextStyles.bodyMedium.copyWith(
                color: highlight ? AppColors.primary : Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
