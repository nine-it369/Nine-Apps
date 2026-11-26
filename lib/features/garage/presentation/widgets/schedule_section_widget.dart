import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/date_time_utils.dart';
import '../../../../shared/widgets/bento/bento_card.dart';
import '../../../../shared/widgets/pills/borderless_status_tag.dart';
import '../../domain/entities/booking_availability_entity.dart';
import '../../domain/entities/workshop_entity.dart';

class ScheduleSectionWidget extends StatelessWidget {
  final List<WorkshopEntity> workshops;
  final WorkshopEntity? selectedWorkshop;
  final DateTime? selectedDate;
  final List<BookingAvailabilityEntity> timeSlots;
  final String? selectedHour;
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
          const SizedBox(height: 6),
          Text(
            'Pilih cabang resmi dan slot jam. Slot akan ditahan 3 menit saat Anda masuk ke tahap Review.',
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

          const SizedBox(height: 20),

          Text('Pilih Jam Kedatangan *', style: AppTextStyles.h3),
          const SizedBox(height: 4),
          Text(
            selectedDate != null
                ? 'Jadwal untuk: ${DateTimeUtils.formatDisplayDate(selectedDate!)}'
                : 'Pilih tanggal di atas terlebih dahulu',
            style: AppTextStyles.bodySmall,
          ),
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
