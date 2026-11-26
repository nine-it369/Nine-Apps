import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../shared/widgets/buttons/nine_primary_button.dart';

class PromoTermsDialog extends StatelessWidget {
  const PromoTermsDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (ctx) => const PromoTermsDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.dialog)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.percent_rounded, color: AppColors.primaryDark, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('Syarat & Ketentuan Diskon Promo', style: AppTextStyles.h3),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Dapatkan harga promo instalasi resmi Nine dengan memenuhi syarat mudah berikut saat kunjungan bengkel:',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 16),
            _buildTermItem(
              icon: Icons.star_rounded,
              title: 'Ulasan Google Maps Bintang 5',
              desc: 'Berikan ulasan positif dan foto hasil pemasangan di cabang bengkel tempat Anda servis.',
            ),
            const SizedBox(height: 12),
            _buildTermItem(
              icon: Icons.camera_alt_outlined,
              title: 'Post Instagram Story & Tag',
              desc: 'Upload foto/video kendaraan Anda setelah servis dan tag akun resmi @nine_autoseries.',
            ),
            const SizedBox(height: 24),
            NinePrimaryButton(
              label: 'Saya Mengerti & Setuju',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermItem({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(desc, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
            ],
          ),
        ),
      ],
    );
  }
}
