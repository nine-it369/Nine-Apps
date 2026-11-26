import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/bento/bento_card.dart';
import '../../../../shared/widgets/controls/nine_text_field.dart';

class VehicleSectionWidget extends StatelessWidget {
  final String vehicleType;
  final bool isEv;
  final String vehicleModel;
  final String vehiclePlat;
  final String vehicleColor;
  final Function({
    String? vehicleType,
    bool? isEv,
    String? model,
    String? plat,
    String? color,
  }) onUpdated;

  const VehicleSectionWidget({
    super.key,
    required this.vehicleType,
    required this.isEv,
    required this.vehicleModel,
    required this.vehiclePlat,
    required this.vehicleColor,
    required this.onUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Detail Kendaraan Servis', style: AppTextStyles.h2),
          const SizedBox(height: 6),
          Text(
            'Spesifikasi kendaraan digunakan untuk menyesuaikan teknisi dan kompatibilitas produk.',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: AppRadius.buttonRadius,
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildSegmentButton(
                    label: 'Mobil',
                    icon: Icons.directions_car_rounded,
                    isSelected: vehicleType == 'car',
                    onTap: () => onUpdated(vehicleType: 'car'),
                  ),
                ),
                Expanded(
                  child: _buildSegmentButton(
                    label: 'Motor',
                    icon: Icons.two_wheeler_rounded,
                    isSelected: vehicleType == 'motorcycle',
                    onTap: () => onUpdated(vehicleType: 'motorcycle'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          BentoCard(
            child: Column(
              children: [
                CheckboxListTile(
                  value: isEv,
                  onChanged: (val) => onUpdated(isEv: val ?? false),
                  title: Text(
                    'Kendaraan Listrik (EV / Hybrid)',
                    style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    'Aktifkan jika kendaraan menggunakan sistem kelistrikan EV',
                    style: AppTextStyles.bodySmall,
                  ),
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: AppColors.obsidian,
                ),
                const Divider(height: 20, color: AppColors.borderSubtle),
                NineTextField(
                  label: 'Merek & Model Kendaraan *',
                  hint: vehicleType == 'car'
                      ? 'Contoh: Toyota Innova Zenix / Honda HR-V'
                      : 'Contoh: Yamaha NMAX / Honda Vario 160',
                  initialValue: vehicleModel,
                  prefixIcon: const Icon(Icons.car_rental_outlined, size: 20),
                  onChanged: (val) => onUpdated(model: val),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: NineTextField(
                        label: 'Nomor Polisi *',
                        hint: 'B 1234 NNE',
                        initialValue: vehiclePlat,
                        prefixIcon: const Icon(Icons.pin_outlined, size: 20),
                        onChanged: (val) => onUpdated(plat: val.toUpperCase()),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: NineTextField(
                        label: 'Warna *',
                        hint: 'Hitam',
                        initialValue: vehicleColor,
                        onChanged: (val) => onUpdated(color: val),
                      ),
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

  Widget _buildSegmentButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? const [
                  BoxShadow(
                    color: Color(0x0F000000),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? AppColors.textPrimary : AppColors.textMuted,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.textPrimary : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
