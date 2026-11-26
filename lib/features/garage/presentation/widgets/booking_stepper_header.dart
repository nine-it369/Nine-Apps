import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class BookingStepperHeader extends StatelessWidget {
  final int currentStep;
  final ValueChanged<int>? onStepTapped;

  const BookingStepperHeader({
    super.key,
    required this.currentStep,
    this.onStepTapped,
  });

  static const List<Map<String, dynamic>> _steps = [
    {'title': 'Kontak', 'icon': Icons.person_outline_rounded},
    {'title': 'Kendaraan', 'icon': Icons.directions_car_outlined},
    {'title': 'Layanan', 'icon': Icons.build_outlined},
    {'title': 'Jadwal', 'icon': Icons.calendar_today_outlined},
    {'title': 'Review', 'icon': Icons.verified_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      color: AppColors.surface,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(_steps.length, (stepIdx) {
          final stepNumber = stepIdx + 1;
          final isCurrent = stepNumber == currentStep;
          final isPassed = stepNumber < currentStep;

          Color bgColor = AppColors.surfaceMuted;
          Color borderColor = AppColors.border;
          Color fgColor = AppColors.textMuted;

          if (isCurrent) {
            bgColor = AppColors.surface;
            borderColor = AppColors.primary;
            fgColor = AppColors.textPrimary;
          } else if (isPassed) {
            bgColor = AppColors.obsidian;
            borderColor = AppColors.obsidian;
            fgColor = Colors.white;
          }

          return Expanded(
            child: GestureDetector(
              onTap: onStepTapped != null ? () => onStepTapped!(stepNumber) : null,
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: stepIdx == 0
                            ? const SizedBox.shrink()
                            : Container(
                                height: 2,
                                color: stepIdx < currentStep
                                    ? AppColors.obsidian
                                    : AppColors.border,
                              ),
                      ),
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: bgColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: borderColor,
                            width: isCurrent ? 2.5 : 1,
                          ),
                        ),
                        child: Center(
                          child: isPassed
                              ? const Icon(Icons.check_rounded, size: 17, color: Colors.white)
                              : Icon(
                                  _steps[stepIdx]['icon'] as IconData,
                                  size: 16,
                                  color: fgColor,
                                ),
                        ),
                      ),
                      Expanded(
                        child: stepIdx == _steps.length - 1
                            ? const SizedBox.shrink()
                            : Container(
                                height: 2,
                                color: isPassed ? AppColors.obsidian : AppColors.border,
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _steps[stepIdx]['title'] as String,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                      color: isCurrent ? AppColors.textPrimary : AppColors.textMuted,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
