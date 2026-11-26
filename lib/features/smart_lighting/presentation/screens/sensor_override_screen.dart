import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/bento/bento_card.dart';
import '../../../../shared/widgets/buttons/nine_primary_button.dart';
import '../blocs/smart_lighting_bloc.dart';
import '../blocs/smart_lighting_event.dart';
import '../blocs/smart_lighting_state.dart';

/// SCR-22: Sensor Override Rem & Sein (SOP Keamanan Standar Jalan Raya)
class SensorOverrideScreen extends StatelessWidget {
  const SensorOverrideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        title: Text('Sensor Override Rem & Sein', style: AppTextStyles.h3),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left_rounded, size: 28),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<SmartLightingBloc, SmartLightingState>(
        builder: (context, state) {
          final lamp = state.lampState;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: BentoCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceMuted,
                      borderRadius: AppRadius.squircleRadius,
                      border: Border.all(color: AppColors.borderSubtle),
                    ),
                    child: const Icon(Icons.traffic_rounded, size: 30, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 12),
                  Text('SOP Keamanan Standar Jalan Raya', style: AppTextStyles.h3),
                  const SizedBox(height: 6),
                  Text(
                    'Saat rem ditekan atau sein aktif, modul hardware otomatis mengambil alih warna RGB ke merah/kuning standar demi keselamatan lalu lintas.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
                  ),
                  const SizedBox(height: 20),
                  const Divider(height: 1, color: AppColors.borderSubtle),
                  const SizedBox(height: 12),

                  // Brake Override (Locked Red)
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Override Rem (Wajib Merah)', style: AppTextStyles.h3.copyWith(fontSize: 13)),
                            const SizedBox(height: 2),
                            Text(
                              'Saat pedal rem diinjak, LED halo otomatis merah terang',
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: lamp.brakeOverrideLocked,
                        onChanged: null, // Locked by road safety compliance
                        activeTrackColor: AppColors.danger,
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  const Divider(height: 1, color: AppColors.borderSubtle),
                  const SizedBox(height: 12),

                  // Turn Signal Override (Amber Running)
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Override Lampu Sein (Kuning Running)', style: AppTextStyles.h3.copyWith(fontSize: 13)),
                            const SizedBox(height: 2),
                            Text(
                              'Saat tuas sein aktif, mode sequential amber menyala',
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: lamp.turnOverrideEnabled,
                        onChanged: (val) => context.read<SmartLightingBloc>().add(ToggleTurnSafetyOverrideEvent(val)),
                        activeTrackColor: AppColors.primary,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  NinePrimaryButton(
                    label: 'Simpan Konfigurasi Sensor',
                    icon: Icons.verified_user_rounded,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Konfigurasi Sensor Override Terverifikasi!')),
                      );
                      context.pop();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
