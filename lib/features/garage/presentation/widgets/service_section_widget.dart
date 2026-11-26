import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/widgets/bento/bento_card.dart';
import '../../../../shared/widgets/pills/borderless_status_tag.dart';
import '../../domain/entities/package_entity.dart';
import '../../domain/entities/service_entity.dart';

class ServiceSectionWidget extends StatefulWidget {
  final List<ServiceEntity> availableServices;
  final List<PackageEntity> availablePackages;
  final List<ServiceEntity> selectedServices;
  final List<PackageEntity> selectedPackages;
  final bool isEv;
  final ValueChanged<ServiceEntity> onToggleService;
  final ValueChanged<PackageEntity> onTogglePackage;

  const ServiceSectionWidget({
    super.key,
    required this.availableServices,
    required this.availablePackages,
    required this.selectedServices,
    required this.selectedPackages,
    required this.isEv,
    required this.onToggleService,
    required this.onTogglePackage,
  });

  @override
  State<ServiceSectionWidget> createState() => _ServiceSectionWidgetState();
}

class _ServiceSectionWidgetState extends State<ServiceSectionWidget> {
  int _selectedTab = 0; // 0 = Jasa, 1 = Paket Bundling

  @override
  Widget build(BuildContext context) {
    final totalSelectedCount =
        widget.selectedServices.length + widget.selectedPackages.length;
    final totalSubtotal = widget.selectedServices.fold<num>(
          0,
          (sum, i) => sum + i.nowPrice,
        ) +
        widget.selectedPackages.fold<num>(
          0,
          (sum, p) => sum + p.effectivePrice(widget.isEv),
        );
    final totalMinutes = widget.selectedServices.fold<int>(
          0,
          (sum, i) => sum + i.estimatedMinutes,
        ) +
        (widget.selectedPackages.length * 120);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pilih Jasa & Paket Bundling', style: AppTextStyles.h2),
              const SizedBox(height: 4),
              Text(
                'Pilih layanan instalasi resmi atau paket bundling produk + pemasangan.',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 12),
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
                      child: _buildTab(
                        label: 'Jasa Servis (${widget.availableServices.length})',
                        isSelected: _selectedTab == 0,
                        onTap: () => setState(() => _selectedTab = 0),
                      ),
                    ),
                    Expanded(
                      child: _buildTab(
                        label: 'Paket Bundling (${widget.availablePackages.length})',
                        isSelected: _selectedTab == 1,
                        onTap: () => setState(() => _selectedTab = 1),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _selectedTab == 0 ? _buildServicesList() : _buildPackagesList(),
        ),
        if (totalSelectedCount > 0)
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
                      '$totalSelectedCount Item Terpilih',
                      style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      CurrencyFormatter.format(totalSubtotal),
                      style: AppTextStyles.h3.copyWith(color: AppColors.primaryDark),
                    ),
                  ],
                ),
                BorderlessStatusTag.info('Estimasi: ~$totalMinutes mnt'),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildTab({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? const [
                  BoxShadow(
                    color: Color(0x0F000000),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? AppColors.textPrimary : AppColors.textMuted,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildServicesList() {
    if (widget.availableServices.isEmpty) {
      return Center(
        child: Text('Belum ada layanan tersedia untuk kategori ini.', style: AppTextStyles.bodyMedium),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: widget.availableServices.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final service = widget.availableServices[index];
        final isSelected = widget.selectedServices.any((s) => s.id == service.id);

        return BentoCard(
          onTap: () => widget.onToggleService(service),
          borderColor: isSelected ? AppColors.primary : AppColors.borderSubtle,
          backgroundColor: isSelected ? const Color(0xFFF7FBF2) : AppColors.surface,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCheckbox(isSelected),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(service.name, style: AppTextStyles.h3.copyWith(fontSize: 15)),
                        ),
                        const SizedBox(width: 6),
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
                            Text('${service.estimatedMinutes} menit', style: AppTextStyles.bodySmall),
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
    );
  }

  Widget _buildPackagesList() {
    if (widget.availablePackages.isEmpty) {
      return Center(
        child: Text('Belum ada paket bundling tersedia.', style: AppTextStyles.bodyMedium),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: widget.availablePackages.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final pkg = widget.availablePackages[index];
        final isSelected = widget.selectedPackages.any((p) => p.id == pkg.id);
        final effPrice = pkg.effectivePrice(widget.isEv);

        return BentoCard(
          onTap: () => widget.onTogglePackage(pkg),
          borderColor: isSelected ? AppColors.primary : AppColors.borderSubtle,
          backgroundColor: isSelected ? const Color(0xFFF7FBF2) : AppColors.surface,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCheckbox(isSelected),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(pkg.name, style: AppTextStyles.h3.copyWith(fontSize: 15)),
                        ),
                        const SizedBox(width: 6),
                        BorderlessStatusTag.info('PAKET'),
                      ],
                    ),
                    if (pkg.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        pkg.description,
                        style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
                      ),
                    ],
                    if (pkg.benefits.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        pkg.benefits.take(2).join(' • '),
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryDark),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (pkg.price > effPrice) ...[
                          Text(
                            CurrencyFormatter.format(pkg.price),
                            style: AppTextStyles.bodySmall.copyWith(
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          CurrencyFormatter.format(effPrice),
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
    );
  }

  Widget _buildCheckbox(bool isSelected) {
    return Container(
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
    );
  }
}
