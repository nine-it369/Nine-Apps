import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/date_time_utils.dart';
import '../../../../shared/widgets/bento/bento_card.dart';
import '../../../../shared/widgets/pills/borderless_status_tag.dart';
import '../../domain/entities/booking_availability_entity.dart';
import '../../domain/entities/workshop_entity.dart';
import '../../domain/utils/slot_calculator.dart';
import 'dialogs/slot_conflict_sheet.dart';

class ScheduleSectionWidget extends StatelessWidget {
  final List<WorkshopEntity> workshops;
  final WorkshopEntity? selectedWorkshop;
  final DateTime? selectedDate;
  final List<BookingAvailabilityEntity> timeSlots;
  final String? selectedHour;
  final int estimatedMinutes;
  final int slotsNeeded;
  final int requiredTechnicians;
  final bool isMultiDay;
  final String? endDate;
  final SlotValidationResult? slotConflict;
  final ValueChanged<WorkshopEntity> onSelectWorkshop;
  final ValueChanged<DateTime> onSelectDate;
  final ValueChanged<String> onSelectTimeSlot;

  const ScheduleSectionWidget({
    super.key,
    required this.workshops,
    required this.selectedWorkshop,
    required this.selectedDate,
    required this.timeSlots,
    required this.selectedHour,
    this.estimatedMinutes = 60,
    this.slotsNeeded = 2,
    this.requiredTechnicians = 1,
    this.isMultiDay = false,
    this.endDate,
    this.slotConflict,
    required this.onSelectWorkshop,
    required this.onSelectDate,
    required this.onSelectTimeSlot,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Jadwal & Lokasi Bengkel', style: AppTextStyles.h2),
          const SizedBox(height: 4),
          Text(
            'Pilih cabang resmi dan slot jam. Ketersediaan slot diperbarui secara realtime.',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 16),

          Text('Pilih Cabang Bengkel *', style: AppTextStyles.h3),
          const SizedBox(height: 8),
          ...workshops.map((ws) {
            final isSelected = selectedWorkshop?.id == ws.id;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: BentoCard(
                onTap: () => onSelectWorkshop(ws),
                borderColor: isSelected ? AppColors.primary : AppColors.borderSubtle,
                backgroundColor: isSelected ? const Color(0xFFF7FBF2) : AppColors.surface,
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors.surfaceMuted,
                        borderRadius: AppRadius.smRadius,
                      ),
                      child: Icon(
                        Icons.store_mall_directory_rounded,
                        color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(ws.name, style: AppTextStyles.h3.copyWith(fontSize: 14)),
                              ),
                              BorderlessStatusTag.info(ws.code),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            ws.address,
                            style: AppTextStyles.bodySmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    if (isSelected) ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.check_circle_rounded, color: AppColors.primaryDark, size: 22),
                    ],
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 16),

          Text('Tanggal Kedatangan *', style: AppTextStyles.h3),
          const SizedBox(height: 8),
          SizedBox(
            height: 72,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 14,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final date = DateTime.now().add(Duration(days: index));
                final isSelected = selectedDate != null &&
                    selectedDate!.year == date.year &&
                    selectedDate!.month == date.month &&
                    selectedDate!.day == date.day;

                return GestureDetector(
                  onTap: () => onSelectDate(date),
                  child: Container(
                    width: 60,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.obsidian : AppColors.surface,
                      borderRadius: AppRadius.buttonRadius,
                      border: Border.all(
                        color: isSelected ? AppColors.obsidian : AppColors.border,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _getDayName(date.weekday),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: isSelected ? Colors.white70 : AppColors.textMuted,
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${date.day}',
                          style: AppTextStyles.h3.copyWith(
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          _getMonthName(date.month),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: isSelected ? AppColors.primary : AppColors.textSecondary,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Multi-day Rollover Alert
          if (isMultiDay && endDate != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: AppRadius.cardRadius,
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.date_range_rounded, size: 20, color: Color(0xFFD97706)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pengerjaan Multi-Hari', style: AppTextStyles.labelMedium.copyWith(color: const Color(0xFF92400E), fontWeight: FontWeight.bold)),
                        Text(
                          'Layanan retrofit/bi-led membutuhkan waktu lebih dari 1 hari operasional. Estimasi pengerjaan selesai pada $endDate.',
                          style: AppTextStyles.caption.copyWith(color: const Color(0xFFB45309)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 20),

          // Duration & Tech Requirement Indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: AppRadius.cardRadius,
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Row(
              children: [
                const Icon(Icons.schedule_rounded, size: 16, color: AppColors.primaryDark),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Kebutuhan: ~$estimatedMinutes menit ($slotsNeeded slot berurutan, $requiredTechnicians teknisi)',
                    style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          Text('Pilih Jam Kedatangan *', style: AppTextStyles.h3),
          const SizedBox(height: 4),
          Text(
            selectedDate != null
                ? 'Jadwal untuk: ${DateTimeUtils.formatDisplayDate(selectedDate!)}'
                : 'Pilih tanggal di atas terlebih dahulu',
            style: AppTextStyles.bodySmall,
          ),

          if (slotConflict != null) ...[
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                SlotConflictSheet.show(
                  context: context,
                  conflict: slotConflict!,
                  onSelectSuggestedSlot: onSelectTimeSlot,
                );
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.errorSurface,
                  borderRadius: AppRadius.cardRadius,
                  border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, size: 18, color: AppColors.error),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Jam yang dipilih bentrok. Ketuk untuk melihat saran jam lain >',
                        style: AppTextStyles.caption.copyWith(color: AppColors.error, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          const SizedBox(height: 10),
          if (timeSlots.isEmpty)
            BentoCard(
              child: Text(
                'Tidak ada slot tersedia atau bengkel tutup pada tanggal ini. Silakan pilih tanggal lain.',
                style: AppTextStyles.bodyMedium,
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: timeSlots.map((slot) {
                final isSelected = selectedHour == slot.hour;
                final isAvailable = slot.isAvailable;

                return GestureDetector(
                  onTap: isAvailable ? () => onSelectTimeSlot(slot.hour) : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : (isAvailable ? AppColors.surface : AppColors.surfaceMuted),
                      borderRadius: AppRadius.buttonRadius,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : (isAvailable ? AppColors.border : AppColors.borderSubtle),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 14,
                              color: isSelected
                                  ? AppColors.textPrimary
                                  : (isAvailable ? AppColors.textPrimary : AppColors.textMuted),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              slot.hour,
                              style: AppTextStyles.mono.copyWith(
                                color: isSelected
                                    ? AppColors.textPrimary
                                    : (isAvailable ? AppColors.textPrimary : AppColors.textMuted),
                                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                decoration: !isAvailable ? TextDecoration.lineThrough : null,
                              ),
                            ),
                          ],
                        ),
                        if (isAvailable)
                          Text(
                            'Sisa ${slot.remainingCapacity} pit',
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: 9,
                              color: isSelected ? AppColors.textPrimary : AppColors.primaryDark,
                            ),
                          )
                        else
                          Text(
                            slot.status == 'locked' ? 'Ditahan' : 'Penuh',
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: 9,
                              color: AppColors.danger,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'SEN';
      case 2:
        return 'SEL';
      case 3:
        return 'RAB';
      case 4:
        return 'KAM';
      case 5:
        return 'JUM';
      case 6:
        return 'SAB';
      case 7:
        return 'MIN';
      default:
        return '';
    }
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    return months[month - 1];
  }
}
