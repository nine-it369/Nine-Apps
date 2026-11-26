import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Dark Obsidian LED Matrix Strip Preview Banner with Neon Glow
class NineLedMatrixBanner extends StatelessWidget {
  final String text;
  final Color color;
  final double height;

  const NineLedMatrixBanner({
    super.key,
    required this.text,
    this.color = AppColors.primary,
    this.height = 48.0,
  });

  @override
  Widget build(BuildContext context) {
    final displayText = text.trim().isEmpty ? 'NINE AUTOSERIES' : text.toUpperCase();

    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0E11),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.black.withAlpha(45), width: 1.0),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.35),
            blurRadius: 6.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        displayText,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.mono.copyWith(
          fontSize: 13.0,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
          color: color,
          shadows: [
            Shadow(
              color: color.withAlpha(190),
              blurRadius: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}

/// Floating Smoked-Glass HUD Status Pill
class NineHudStatusPill extends StatelessWidget {
  final String hexCode;
  final String modeName;
  final Color color;
  final VoidCallback? onTap;

  const NineHudStatusPill({
    super.key,
    required this.hexCode,
    required this.modeName,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 30.0,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(20, 21, 25, 0.84),
          borderRadius: BorderRadius.circular(999.0),
          border: Border.all(color: Colors.white.withAlpha(42), width: 1.0),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.45),
              blurRadius: 10.0,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              hexCode.toUpperCase(),
              style: AppTextStyles.mono.copyWith(
                fontSize: 11.0,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: Text(
                '•',
                style: TextStyle(color: Colors.white.withAlpha(80), fontSize: 11.0),
              ),
            ),
            Flexible(
              child: Text(
                modeName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.mono.copyWith(
                  fontSize: 11.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withAlpha(235),
                ),
              ),
            ),
            if (onTap != null) ...[
              const SizedBox(width: 6.0),
              const Icon(Icons.edit_outlined, size: 12.0, color: AppColors.primary),
            ],
          ],
        ),
      ),
    );
  }
}
