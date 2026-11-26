import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/widgets/bento/bento_card.dart';
import '../../../../shared/widgets/pills/borderless_status_tag.dart';
import '../../domain/entities/service_entity.dart';

class ServiceSectionWidget extends StatelessWidget {
  final List<ServiceEntity> availableServices;
  final List<ServiceEntity> selectedServices;
  final ValueChanged<ServiceEntity> onToggleService;

  const ServiceSectionWidget({
    super.key,
    required this.availableServices,
    required this.selectedServices,
    required this.onToggleService,
  });

  @override
  Widget build(BuildContext context) {
    if (availableServices.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.build_circle_outlined, size: 48, color: AppColors.textMuted),
              const SizedBox(height: 12),
              Text('Memuat katalog jasa servis...', style: AppTextStyles.bodyMedium),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pilih Jasa & Layanan Bengkel', style: AppTextStyles.h2),
              const SizedBox(height: 4),
              Text(
                'Pilih satu atau beberapa jasa instalasi resmi dengan garansi resmi Nine.',
                style: AppTextStyles.bodyMedium,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: availableServices.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final service = availableServices[index];
              final isSelected = selectedServices.any((s) => s.id == service.id);

              return BentoCard(
                onTap: () => onToggleService(service),
                borderColor: isSelected ? AppColors.primary : AppColors.borderSubtle,
                backgroundColor: isSelected ? const Color(0xFFF7FBF2) : AppColors.surface,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Selection indicator
                    Container(
                      width: 24,
                      height: 24,
                      margin: const EdgeInsets.only(top: 2, right: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.border,
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(Icons.check_rounded, size: 16, color: AppColors.textPrimary)
                          : null,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  service.name,
                                  style: AppTextStyles.h3.copyWith(fontSize: 15),
                                ),
                              ),
                              BorderlessStatusTag.success('${service.warrantyMonths} Bln Garansi'),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            service.shortDesc,
                            style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.timer_outlined, size: 14, color: AppColors.textMuted),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${service.estimatedMinutes} menit',
                                    style: AppTextStyles.bodySmall,
                                  ),
                                ],
                              ),
                              Text(
                                CurrencyFormatter.format(service.nowPrice),
                                style: AppTextStyles.h3.copyWith(
                                  color: AppColors.primaryDark,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        // Selection summary strip
        if (selectedServices.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.borderSubtle)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${selectedServices.length} Jasa Terpilih',
                      style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      CurrencyFormatter.format(
                        selectedServices.fold<num>(0, (sum, i) => sum + i.nowPrice),
                      ),
                      style: AppTextStyles.h3.copyWith(color: AppColors.primaryDark),
                    ),
                  ],
                ),
                BorderlessStatusTag.info(
                  'Estimasi: ${selectedServices.fold<int>(0, (sum, i) => sum + i.estimatedMinutes)} mnt',
                ),
              ],
            ),
          ),
      ],
    );
  }
}
