import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/date_time_utils.dart';
import '../../../../shared/widgets/bento/bento_card.dart';
import '../../domain/entities/booking_availability_entity.dart';
import '../../domain/entities/workshop_entity.dart';

class ScheduleSectionWidget extends StatelessWidget {
  final List<WorkshopEntity> workshops;
  final WorkshopEntity? selectedWorkshop;
  final DateTime? selectedDate;
  final List<BookingAvailabilityEntity> timeSlots;
  final String? selectedTimeSlot;
  final ValueChanged<WorkshopEntity> onSelectWorkshop;
  final ValueChanged<DateTime> onSelectDate;
  final ValueChanged<String> onSelectTimeSlot;

  const ScheduleSectionWidget({
    super.key,
    required this.workshops,
    required this.selectedWorkshop,
    required this.selectedDate,
    required this.timeSlots,
    required this.selectedTimeSlot,
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
            'Pilih cabang bengkel resmi Nine AutoSeries dan tentukan waktu kedatangan.',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 16),

          // 1. Workshop Branch Selection
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
                          Text(ws.name, style: AppTextStyles.h3.copyWith(fontSize: 14)),
                          const SizedBox(height: 2),
                          Text(
                            ws.address,
                            style: AppTextStyles.bodySmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Jam Buka: ${ws.operatingHours ?? "09:00 - 18:00"}',
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryDark),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 22),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 16),

          // 2. Date Selection (Next 14 Days)
          Text('Tanggal Kedatangan *', style: AppTextStyles.h3),
          const SizedBox(height: 8),
          SizedBox(
            height: 72,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 14,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final date = DateTime.now().add(Duration(days: index + 1));
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

          // 3. Time Slot Selection
          Text('Pilih Jam Kedatangan *', style: AppTextStyles.h3),
          const SizedBox(height: 4),
          Text(
            selectedDate != null
                ? 'Jadwal untuk: ${DateTimeUtils.formatDisplayDate(selectedDate!)}'
                : 'Pilih tanggal di atas terlebih dahulu',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: timeSlots.map((slot) {
              final isSelected = selectedTimeSlot == slot.timeSlot;
              final isAvailable = slot.isAvailable;

              return GestureDetector(
                onTap: isAvailable ? () => onSelectTimeSlot(slot.timeSlot) : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: isSelected
                            ? AppColors.textPrimary
                            : (isAvailable ? AppColors.textPrimary : AppColors.textMuted),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        slot.timeSlot,
                        style: AppTextStyles.mono.copyWith(
                          color: isSelected
                              ? AppColors.textPrimary
                              : (isAvailable ? AppColors.textPrimary : AppColors.textMuted),
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
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
