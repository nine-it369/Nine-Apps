import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../shared/widgets/buttons/nine_primary_button.dart';
import '../../../domain/entities/package_entity.dart';
import '../../../domain/entities/variant_entity.dart';

class PackageChildVariantSheet extends StatefulWidget {
  final PackageEntity package;
  final List<VariantEntity> allVariants;
  final Map<int, int> initialSelections; // parentVariantId -> childVariantId
  final void Function(Map<int, int> selectedChildren) onSave;

  const PackageChildVariantSheet({
    super.key,
    required this.package,
    required this.allVariants,
    required this.initialSelections,
    required this.onSave,
  });

  static Future<void> show({
    required BuildContext context,
    required PackageEntity package,
    required List<VariantEntity> allVariants,
    required Map<int, int> initialSelections,
    required void Function(Map<int, int> selectedChildren) onSave,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => PackageChildVariantSheet(
        package: package,
        allVariants: allVariants,
        initialSelections: initialSelections,
        onSave: onSave,
      ),
    );
  }

  @override
  State<PackageChildVariantSheet> createState() => _PackageChildVariantSheetState();
}

class _PackageChildVariantSheetState extends State<PackageChildVariantSheet> {
  late Map<int, int> _selections;

  @override
  void initState() {
    super.initState();
    _selections = Map<int, int>.from(widget.initialSelections);
  }

  List<VariantEntity> _getParentsWithChildren() {
    // Find all variants in allVariants that have children and are relevant
    return widget.allVariants.where((v) => v.children.isNotEmpty).toList();
  }

  @override
  Widget build(BuildContext context) {
    final parents = _getParentsWithChildren();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.sheetRadius,
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Kustomisasi Sub-Varian', style: AppTextStyles.h3),
                      const SizedBox(height: 2),
                      Text(
                        widget.package.name,
                        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textMuted),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.borderSubtle),

          // Options List
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.all(20),
              itemCount: parents.isEmpty ? 1 : parents.length,
              separatorBuilder: (_, _) => const SizedBox(height: 20),
              itemBuilder: (ctx, index) {
                if (parents.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        'Tidak ada sub-varian yang perlu dikonfigurasi untuk paket ini.',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                final parent = parents[index];
                final selectedChildId = _selections[parent.id];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.layers_outlined, size: 16, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Text(
                          parent.displayName.toUpperCase(),
                          style: AppTextStyles.labelSmall.copyWith(color: AppColors.textPrimary),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primarySurface,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Wajib',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ...parent.children.map((child) {
                      final isOutOfStock = child.stock != null && child.stock! <= 0;
                      final isSelected = selectedChildId == child.id;

                      return GestureDetector(
                        onTap: isOutOfStock
                            ? null
                            : () {
                                setState(() {
                                  _selections[parent.id] = child.id;
                                });
                              },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isOutOfStock
                                ? AppColors.surfaceMuted.withValues(alpha: 0.5)
                                : isSelected
                                    ? AppColors.primarySurface.withValues(alpha: 0.3)
                                    : AppColors.surface,
                            borderRadius: AppRadius.cardRadius,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : isOutOfStock
                                      ? AppColors.borderSubtle
                                      : AppColors.border,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected ? AppColors.primary : AppColors.textMuted,
                                    width: isSelected ? 5 : 1.5,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  child.displayName,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: isOutOfStock ? AppColors.textMuted : AppColors.textPrimary,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ),
                              if (isOutOfStock)
                                Text(
                                  '(Habis)',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.error,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                );
              },
            ),
          ),

          // Confirm Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: NinePrimaryButton(
              label: 'Simpan Pilihan Sub-Varian',
              onPressed: () {
                widget.onSave(_selections);
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
