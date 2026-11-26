import 'package:flutter/material.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_text_styles.dart';

class BorderlessStatusTag extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;

  const BorderlessStatusTag({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.icon,
  });

  factory BorderlessStatusTag.success(String text) {
    return BorderlessStatusTag(
      text: text,
      backgroundColor: const Color(0xFFE8F7D4),
      textColor: const Color(0xFF4C7B16),
    );
  }

  factory BorderlessStatusTag.pending(String text) {
    return BorderlessStatusTag(
      text: text,
      backgroundColor: const Color(0xFFFEF3C7),
      textColor: const Color(0xFFB45309),
    );
  }

  factory BorderlessStatusTag.info(String text) {
    return BorderlessStatusTag(
      text: text,
      backgroundColor: const Color(0xFFE0E7FF),
      textColor: const Color(0xFF3730A3),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.pillRadius,
        border: Border.all(color: Colors.transparent, width: 0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: AppTextStyles.bodySmall.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
