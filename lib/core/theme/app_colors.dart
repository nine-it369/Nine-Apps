import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Signature Brand Colors
  static const Color primary = Color(0xFF8DC63F); // Nine Lime Green
  static const Color primaryDark = Color(0xFF76A834);
  static const Color primaryLight = Color(0xFFE6F3D4);

  // Surface & Canvas (Never pure #000000 / #FFFFFF)
  static const Color obsidian = Color(0xFF141518); // Rich Obsidian Black
  static const Color obsidianSurface = Color(0xFF1E2024);
  static const Color canvas = Color(0xFFFAFAFB); // Soft Silk Off-White
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF8FAFC);

  // Border & Dividers
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderSubtle = Color(0x0F000000);

  // Text
  static const Color textPrimary = Color(0xFF231F20);
  static const Color textSecondary = Color(0xFF58595B);
  static const Color textMuted = Color(0xFF8E8E93);
  static const Color textInverse = Color(0xFFFFFFFF);

  // Secondary Accents
  static const Color danger = Color(0xFFED1C24);
  static const Color error = Color(0xFFED1C24);
  static const Color errorSurface = Color(0xFFFEE2E2);
  static const Color primarySurface = Color(0xFFE6F3D4);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF4366B0);
  static const Color gold = Color(0xFFBA983D);
}
