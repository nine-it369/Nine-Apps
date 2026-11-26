import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/widgets/bento/bento_card.dart';
import '../../../../shared/widgets/pills/borderless_status_tag.dart';
import '../../domain/entities/booking_variant_item_entity.dart';
import '../../domain/entities/package_entity.dart';
import '../../domain/entities/service_entity.dart';
import '../../domain/entities/variant_entity.dart';
import 'dialogs/package_child_variant_sheet.dart';
import 'dialogs/promo_terms_dialog.dart';

class ServiceSectionWidget extends StatefulWidget {
  final List<ServiceEntity> availableServices;
  final List<PackageEntity> availablePackages;
  final List<VariantEntity> availableVariants;
  final List<ServiceEntity> selectedServices;
  final List<PackageEntity> selectedPackages;
  final List<BookingVariantItemEntity> selectedVariants;
  final Map<int, Map<int, int>> selectedPackageChildren;
  final bool isEv;
  final bool applyDiscount;
  final ValueChanged<ServiceEntity> onToggleService;
  final ValueChanged<PackageEntity> onTogglePackage;
  final void Function(VariantEntity variant, bool withInstallation) onToggleVariant;
  final void Function(int packageId, int parentVariantId, int childVariantId) onSelectPackageChild;
  final ValueChanged<bool> onToggleApplyDiscount;

  const ServiceSectionWidget({
    super.key,
    required this.availableServices,
    required this.availablePackages,
    this.availableVariants = const [],
    required this.selectedServices,
    required this.selectedPackages,
    this.selectedVariants = const [],
    this.selectedPackageChildren = const {},
    required this.isEv,
    this.applyDiscount = true,
    required this.onToggleService,
    required this.onTogglePackage,
    required this.onToggleVariant,
    required this.onSelectPackageChild,
    required this.onToggleApplyDiscount,
  });

  @override
  State<ServiceSectionWidget> createState() => _ServiceSectionWidgetState();
}

class _ServiceSectionWidgetState extends State<ServiceSectionWidget> {
  int _selectedTab = 0; // 0 = Paket, 1 = Layanan Satuan, 2 = Produk Satuan

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pilih Paket & Produk', style: AppTextStyles.h2),
              const SizedBox(height: 2),
              Text(
                'Pilih paket bundling, layanan satuan, atau produk resmi bergaransi.',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 10),

              // Switch Diskon Promo (Apple HIG Card)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: AppRadius.cardRadius,
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primarySurface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.percent_rounded, size: 16, color: AppColors.primaryDark),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('Aktifkan Diskon Promo', style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.bold)),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () => PromoTermsDialog.show(context),
                                child: const Icon(Icons.info_outline, size: 14, color: AppColors.textMuted),
                              ),
                            ],
                          ),
                          Text(
                            'Klaim harga promo dengan syarat ulasan Google & IG',
                            style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                    Switch.adaptive(
                      value: widget.applyDiscount,
                      activeColor: AppColors.primary,
                      onChanged: widget.onToggleApplyDiscount,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // 3-Tab Segmented Control
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: AppRadius.buttonRadius,
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildTab(
                        label: 'Paket (${widget.availablePackages.length})',
                        isSelected: _selectedTab == 0,
                        onTap: () => setState(() => _selectedTab = 0),
                      ),
                    ),
                    Expanded(
                      child: _buildTab(
                        label: 'Layanan (${widget.availableServices.length})',
                        isSelected: _selectedTab == 1,
                        onTap: () => setState(() => _selectedTab = 1),
                      ),
                    ),
                    Expanded(
                      child: _buildTab(
                        label: 'Produk (${widget.availableVariants.length})',
                        isSelected: _selectedTab == 2,
                        onTap: () => setState(() => _selectedTab = 2),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _selectedTab == 0
              ? _buildPackagesList()
              : _selectedTab == 1
                  ? _buildServicesList()
                  : _buildVariantsList(),
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
        padding: const EdgeInsets.symmetric(vertical: 8),
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
              fontSize: 11,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
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
        final effPrice = widget.applyDiscount
            ? pkg.effectivePrice(widget.isEv)
            : (widget.isEv ? (pkg.evPrice > 0 ? pkg.evPrice : pkg.price) : pkg.price);
        final hasConfigurableChildren = widget.availableVariants.any((v) => v.children.isNotEmpty);
        final hasChildrenSelected = widget.selectedPackageChildren.containsKey(pkg.id);

        return BentoCard(
          onTap: () => widget.onTogglePackage(pkg),
          borderColor: isSelected ? AppColors.primary : AppColors.borderSubtle,
          backgroundColor: isSelected ? const Color(0xFFF7FBF2) : AppColors.surface,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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

              // Button pilih sub-varian jika paket dipilih & memiliki pilihan varian anak
              if (isSelected && hasConfigurableChildren) ...[
                const SizedBox(height: 10),
                const Divider(height: 1, color: AppColors.borderSubtle),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () {
                    PackageChildVariantSheet.show(
                      context: context,
                      package: pkg,
                      allVariants: widget.availableVariants,
                      initialSelections: widget.selectedPackageChildren[pkg.id] ?? {},
                      onSave: (selections) {
                        selections.forEach((parentVarId, childVarId) {
                          widget.onSelectPackageChild(pkg.id, parentVarId, childVarId);
                        });
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: hasChildrenSelected ? AppColors.surface : AppColors.primarySurface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: hasChildrenSelected ? AppColors.primary : AppColors.primaryDark,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.tune_rounded, size: 14, color: AppColors.primaryDark),
                            const SizedBox(width: 6),
                            Text(
                              hasChildrenSelected ? 'Kustomisasi Sub-Varian Telah Diatur' : 'Pilih Sub-Varian (Wajib)',
                              style: AppTextStyles.caption.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          hasChildrenSelected ? 'Ubah' : 'Pilih >',
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
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
        final price = widget.applyDiscount ? service.nowPrice : service.price;

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
                          CurrencyFormatter.format(price),
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

  Widget _buildVariantsList() {
    if (widget.availableVariants.isEmpty) {
      return Center(
        child: Text('Belum ada produk suku cadang tersedia.', style: AppTextStyles.bodyMedium),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: widget.availableVariants.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final variant = widget.availableVariants[index];
        final selectedItem = widget.selectedVariants
            .where((v) => v.variantId == variant.id && v.packageId == null)
            .firstOrNull;
        final isSelected = selectedItem != null;
        final isOutOfStock = !variant.isInStock;
        final price = widget.applyDiscount ? variant.nowPrice : variant.price;
        final installPrice = widget.applyDiscount ? variant.installationPricePromo : variant.installationPrice;

        return BentoCard(
          onTap: isOutOfStock ? null : () => widget.onToggleVariant(variant, selectedItem?.withInstallation ?? false),
          borderColor: isSelected ? AppColors.primary : AppColors.borderSubtle,
          backgroundColor: isOutOfStock
              ? AppColors.surfaceMuted.withValues(alpha: 0.6)
              : isSelected
                  ? const Color(0xFFF7FBF2)
                  : AppColors.surface,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                              child: Text(variant.displayName, style: AppTextStyles.h3.copyWith(fontSize: 15)),
                            ),
                            const SizedBox(width: 6),
                            if (isOutOfStock)
                              BorderlessStatusTag.error('Stok Habis')
                            else if (variant.stock != null)
                              BorderlessStatusTag.neutral('Stok: ${variant.stock}'),
                          ],
                        ),
                        if (variant.subtitle != null && variant.subtitle!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(variant.subtitle!, style: AppTextStyles.bodyMedium.copyWith(fontSize: 12)),
                        ],
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (variant.sku != null && variant.sku!.isNotEmpty)
                              Text('SKU: ${variant.sku}', style: AppTextStyles.caption.copyWith(color: AppColors.textMuted))
                            else
                              const SizedBox.shrink(),
                            Text(
                              CurrencyFormatter.format(price),
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

              // Opsi pasang di bengkel jika produk dipilih
              if (isSelected && !isOutOfStock) ...[
                const SizedBox(height: 8),
                const Divider(height: 1, color: AppColors.borderSubtle),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: selectedItem.withInstallation,
                          activeColor: AppColors.primary,
                          onChanged: (val) {
                            widget.onToggleVariant(variant, val == true);
                          },
                        ),
                        Text(
                          'Pasang di Bengkel (+ ${CurrencyFormatter.format(installPrice)})',
                          style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.timer_outlined, size: 14, color: AppColors.textMuted),
                        const SizedBox(width: 4),
                        Text('${variant.estimatedMinutes} mnt', style: AppTextStyles.caption),
                      ],
                    ),
                  ],
                ),
              ],
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
