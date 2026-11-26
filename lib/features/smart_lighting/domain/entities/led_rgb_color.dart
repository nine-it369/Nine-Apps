import 'package:equatable/equatable.dart';

/// Pure Dart representation of an RGB color for the Domain Layer.
/// Keeps the Domain layer strictly free of `dart:ui` / `package:flutter`.
class LedRgbColor extends Equatable {
  final int r;
  final int g;
  final int b;

  const LedRgbColor(this.r, this.g, this.b);

  factory LedRgbColor.fromHex(String hex) {
    final cleaned = hex.replaceAll('#', '').trim();
    if (cleaned.length == 6) {
      final value = int.tryParse(cleaned, radix: 16);
      if (value != null) {
        return LedRgbColor(
          (value >> 16) & 0xFF,
          (value >> 8) & 0xFF,
          value & 0xFF,
        );
      }
    }
    return const LedRgbColor(0x8D, 0xC6, 0x3F);
  }

  String toHex() {
    final rHex = r.clamp(0, 255).toRadixString(16).padLeft(2, '0');
    final gHex = g.clamp(0, 255).toRadixString(16).padLeft(2, '0');
    final bHex = b.clamp(0, 255).toRadixString(16).padLeft(2, '0');
    return '#$rHex$gHex$bHex'.toUpperCase();
  }

  int toArgbInt() =>
      (0xFF << 24) |
      ((r.clamp(0, 255) & 0xFF) << 16) |
      ((g.clamp(0, 255) & 0xFF) << 8) |
      (b.clamp(0, 255) & 0xFF);

  @override
  List<Object?> get props => [r, g, b];
}
