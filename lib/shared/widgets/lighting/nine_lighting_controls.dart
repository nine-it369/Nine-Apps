import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Selectable Lighting Mode Card with active Lime Green border & squircle icon
class NineLightingModeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const NineLightingModeCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight.withAlpha(110) : AppColors.surface,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderSubtle,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.textPrimary : AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Icon(
                icon,
                size: 20.0,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.h3.copyWith(fontSize: 12.5),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 11.0,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10.0),
            Container(
              width: 20.0,
              height: 20.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primary : Colors.white,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: isSelected ? 0.0 : 2.0,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 13.0, color: AppColors.textPrimary)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

/// Labeled Precision Range Slider with tabular monospace unit display
class NineLabeledSlider extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final String unit;
  final String? minLabel;
  final String? maxLabel;
  final ValueChanged<double> onChanged;

  const NineLabeledSlider({
    super.key,
    required this.label,
    required this.value,
    this.min = 10.0,
    this.max = 255.0,
    this.unit = 'ms',
    this.minLabel,
    this.maxLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final valInt = value.round();

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppColors.borderSubtle, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: AppTextStyles.h3.copyWith(fontSize: 12.0),
              ),
              Text(
                unit.isNotEmpty ? '$valInt $unit' : '$valInt',
                style: AppTextStyles.mono.copyWith(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4.0),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 5.0,
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.border,
              thumbColor: AppColors.primary,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
              overlayColor: AppColors.primary.withAlpha(50),
            ),
            child: Slider(
              value: value.clamp(min, max),
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
          if (minLabel != null || maxLabel != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(minLabel ?? '', style: AppTextStyles.bodySmall.copyWith(fontSize: 10.0)),
                Text(maxLabel ?? '', style: AppTextStyles.bodySmall.copyWith(fontSize: 10.0)),
              ],
            ),
        ],
      ),
    );
  }
}
