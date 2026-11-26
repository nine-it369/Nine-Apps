import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../shared/widgets/buttons/nine_primary_button.dart';
import '../../../domain/utils/slot_calculator.dart';

class SlotConflictSheet extends StatelessWidget {
  final SlotValidationResult conflict;
  final ValueChanged<String> onSelectSuggestedSlot;

  const SlotConflictSheet({
    super.key,
    required this.conflict,
    required this.onSelectSuggestedSlot,
  });

  static Future<void> show({
    required BuildContext context,
    required SlotValidationResult conflict,
    required ValueChanged<String> onSelectSuggestedSlot,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SlotConflictSheet(
        conflict: conflict,
        onSelectSuggestedSlot: onSelectSuggestedSlot,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.sheetRadius,
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.errorSurface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.access_time_filled_rounded, color: AppColors.error, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text('Waktu Tidak Tersedia', style: AppTextStyles.h3),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Layanan yang Anda pilih membutuhkan estimasi pengerjaan ${conflict.requiredDuration} menit (${conflict.requiredSlots} slot waktu berurutan) dan ${conflict.requiredTechnicians} teknisi.',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 16),
          if (conflict.suggestedSlots.isNotEmpty) ...[
            Text('Saran Jam Mulai yang Tersedia:', style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: conflict.suggestedSlots.map((slot) {
                return ActionChip(
                  label: Text(slot, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
                  backgroundColor: AppColors.primarySurface,
                  side: const BorderSide(color: AppColors.primary),
                  onPressed: () {
                    Navigator.pop(context);
                    onSelectSuggestedSlot(slot);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],
          NinePrimaryButton(
            label: 'Pilih Jadwal Lain',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
