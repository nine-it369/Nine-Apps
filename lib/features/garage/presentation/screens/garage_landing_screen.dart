import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../shared/widgets/bento/bento_card.dart';
import '../../../../shared/widgets/buttons/nine_primary_button.dart';
import '../../../../shared/widgets/pills/borderless_status_tag.dart';
import '../../domain/entities/workshop_entity.dart';
import '../../domain/usecases/get_workshops_usecase.dart';

class GarageLandingScreen extends StatefulWidget {
  const GarageLandingScreen({super.key});

  @override
  State<GarageLandingScreen> createState() => _GarageLandingScreenState();
}

class _GarageLandingScreenState extends State<GarageLandingScreen> {
  List<WorkshopEntity> _workshops = const [];
  bool _loadingWorkshops = true;

  @override
  void initState() {
    super.initState();
    _loadWorkshops();
  }

  Future<void> _loadWorkshops() async {
    if (!sl.isRegistered<GetWorkshopsUseCase>()) return;
    final res = await sl<GetWorkshopsUseCase>()(const NoParams());
    if (!mounted) return;
    res.fold(
      (_) => setState(() => _loadingWorkshops = false),
      (list) => setState(() {
        _workshops = list;
        _loadingWorkshops = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text('Nine Garage®', style: AppTextStyles.h2),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => context.push(RouteNames.ticketLookup),
            icon: const Icon(Icons.qr_code_scanner_rounded),
            tooltip: 'Cek Tiket SPK',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.obsidian,
                borderRadius: AppRadius.heroRadius,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1F000000),
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BorderlessStatusTag(
                        text: 'BENGKEL RESMI BUKA',
                        backgroundColor: AppColors.primary.withAlpha(50),
                        textColor: AppColors.primary,
                        icon: Icons.storefront_rounded,
                      ),
                      Text(
                        '09:00 - 18:00 WIB',
                        style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Instalasi Presisi & Servis Kendaraan',
                    style: AppTextStyles.h1.copyWith(color: Colors.white, fontSize: 22),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pemasangan Biled Projector, Dashcam 4K, Smart LED & Aksesoris Bergaransi Resmi.',
                    style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
                  ),
                  const SizedBox(height: 20),
                  NinePrimaryButton(
                    label: 'Buat Reservasi Servis (Booking)',
                    icon: Icons.calendar_month_rounded,
                    onPressed: () => context.push(RouteNames.booking),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Text('Menu Layanan Cepat', style: AppTextStyles.h3),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: BentoCard(
                    onTap: () => context.push(RouteNames.booking),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7FBF2),
                            borderRadius: AppRadius.smRadius,
                          ),
                          child: const Icon(Icons.add_task_rounded, color: AppColors.primaryDark),
                        ),
                        const SizedBox(height: 12),
                        Text('Booking Baru', style: AppTextStyles.h3.copyWith(fontSize: 14)),
                        const SizedBox(height: 2),
                        Text('Pilih cabang & slot', style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: BentoCard(
                    onTap: () => context.push(RouteNames.ticketLookup),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: AppRadius.smRadius,
                          ),
                          child: const Icon(Icons.qr_code_scanner_rounded, color: AppColors.info),
                        ),
                        const SizedBox(height: 12),
                        Text('Digital SPK', style: AppTextStyles.h3.copyWith(fontSize: 14)),
                        const SizedBox(height: 2),
                        Text('Cek tiket pengerjaan', style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Text('Cabang Bengkel Resmi', style: AppTextStyles.h3),
            const SizedBox(height: 10),
            if (_loadingWorkshops)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_workshops.isEmpty)
              _buildWorkshopCard(
                'Arcadia Daan Mogot',
                'TGR',
                'Ruko Jl. Arcadia Daan Mogot No. 16-17, Tangerang',
              )
            else
              ..._workshops.map(
                (ws) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildWorkshopCard(ws.name, ws.code, ws.address),
                ),
              ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkshopCard(String name, String code, String address) {
    return BentoCard(
      onTap: () => context.push(RouteNames.booking),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: AppRadius.squircleRadius,
            ),
            child: const Icon(Icons.location_city_rounded, color: AppColors.obsidian, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(name, style: AppTextStyles.h3.copyWith(fontSize: 15))),
                    BorderlessStatusTag.info(code),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  address,
                  style: AppTextStyles.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                BorderlessStatusTag.success('Buka • Reservasi Online'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
