import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/bento/bento_card.dart';
import '../../../../shared/widgets/controls/nine_text_field.dart';

class VehicleSectionWidget extends StatelessWidget {
  final String category;
  final String brand;
  final String model;
  final String year;
  final String licensePlate;
  final String transmission;
  final Function({
    required String category,
    required String brand,
    required String model,
    required String year,
    required String licensePlate,
    required String transmission,
  }) onUpdated;

  const VehicleSectionWidget({
    super.key,
    required this.category,
    required this.brand,
    required this.model,
    required this.year,
    required this.licensePlate,
    required this.transmission,
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
            'Informasi kendaraan memastikan suku cadang & slot mekanik sesuai.',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 16),
          // Vehicle Type Segment
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
                    isSelected: category == 'car',
                    onTap: () => onUpdated(
                      category: 'car',
                      brand: brand,
                      model: model,
                      year: year,
                      licensePlate: licensePlate,
                      transmission: transmission,
                    ),
                  ),
                ),
                Expanded(
                  child: _buildSegmentButton(
                    label: 'Motor',
                    icon: Icons.two_wheeler_rounded,
                    isSelected: category == 'motorcycle',
                    onTap: () => onUpdated(
                      category: 'motorcycle',
                      brand: brand,
                      model: model,
                      year: year,
                      licensePlate: licensePlate,
                      transmission: transmission,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          BentoCard(
            child: Column(
              children: [
                NineTextField(
                  label: 'Merek Kendaraan *',
                  hint: 'Contoh: Toyota, Honda, Mitsubishi',
                  initialValue: brand,
                  prefixIcon: const Icon(Icons.branding_watermark_outlined, size: 20),
                  onChanged: (val) => onUpdated(
                    category: category,
                    brand: val,
                    model: model,
                    year: year,
                    licensePlate: licensePlate,
                    transmission: transmission,
                  ),
                ),
                const SizedBox(height: 14),
                NineTextField(
                  label: 'Model Kendaraan *',
                  hint: 'Contoh: Innova Zenix, HR-V, Fortuner, NMAX',
                  initialValue: model,
                  prefixIcon: const Icon(Icons.car_rental_outlined, size: 20),
                  onChanged: (val) => onUpdated(
                    category: category,
                    brand: brand,
                    model: val,
                    year: year,
                    licensePlate: licensePlate,
                    transmission: transmission,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: NineTextField(
                        label: 'Nomor Polisi *',
                        hint: 'B 1234 NNE',
                        initialValue: licensePlate,
                        prefixIcon: const Icon(Icons.pin_outlined, size: 20),
                        onChanged: (val) => onUpdated(
                          category: category,
                          brand: brand,
                          model: model,
                          year: year,
                          licensePlate: val.toUpperCase(),
                          transmission: transmission,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: NineTextField(
                        label: 'Tahun',
                        hint: '2024',
                        initialValue: year,
                        keyboardType: TextInputType.number,
                        onChanged: (val) => onUpdated(
                          category: category,
                          brand: brand,
                          model: model,
                          year: val,
                          licensePlate: licensePlate,
                          transmission: transmission,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // Transmission selector
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tipe Transmisi',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildChoiceChip(
                          label: 'Otomatis (A/T)',
                          isSelected: transmission == 'automatic',
                          onTap: () => onUpdated(
                            category: category,
                            brand: brand,
                            model: model,
                            year: year,
                            licensePlate: licensePlate,
                            transmission: 'automatic',
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildChoiceChip(
                          label: 'Manual (M/T)',
                          isSelected: transmission == 'manual',
                          onTap: () => onUpdated(
                            category: category,
                            brand: brand,
                            model: model,
                            year: year,
                            licensePlate: licensePlate,
                            transmission: 'manual',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
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
              ? [
                  const BoxShadow(
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

  Widget _buildChoiceChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.obsidian : AppColors.surfaceMuted,
          borderRadius: AppRadius.buttonRadius,
          border: Border.all(
            color: isSelected ? AppColors.obsidian : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
