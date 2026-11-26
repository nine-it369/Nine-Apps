import 'package:flutter/material.dart';

/// Quick Automotive Color Swatch Capsule Rail (Putih 6000K, Amber Sein, Devil Red, Cyber Green)
class NineColorSwatchRail extends StatelessWidget {
  final List<Color> colors;
  final List<String> tooltips;
  final Color selectedColor;
  final ValueChanged<Color> onSelect;
  final double width;
  final double height;

  const NineColorSwatchRail({
    super.key,
    required this.colors,
    required this.tooltips,
    required this.selectedColor,
    required this.onSelect,
    this.width = 44.0,
    this.height = 156.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(20, 21, 25, 0.82),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.white.withAlpha(38), width: 1.0),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.55),
            blurRadius: 24.0,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(colors.length, (i) {
          final c = colors[i];
          final isSel = c.toARGB32() == selectedColor.toARGB32();
          return Tooltip(
            message: i < tooltips.length ? tooltips[i] : '',
            child: GestureDetector(
              onTap: () => onSelect(c),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 20.0,
                height: 20.0,
                decoration: BoxDecoration(
                  color: c,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSel ? Colors.white : Colors.white.withAlpha(90),
                    width: isSel ? 2.5 : 1.0,
                  ),
                  boxShadow: isSel
                      ? [BoxShadow(color: c.withAlpha(180), blurRadius: 8.0, spreadRadius: 1.0)]
                      : null,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class NineColorPresetItem {
  final String name;
  final Color color;
  final String hex;
  const NineColorPresetItem(this.name, this.color, this.hex);
}

const List<NineColorPresetItem> kAutomotiveColorPresets = [
  NineColorPresetItem('Cyber Green', Color(0xFF8DC63F), '#8DC63F'),
  NineColorPresetItem('Ice Blue', Color(0xFF00D2FF), '#00D2FF'),
  NineColorPresetItem('Devil Red', Color(0xFFED1C24), '#ED1C24'),
  NineColorPresetItem('Golden Amber', Color(0xFFBA983D), '#BA983D'),
  NineColorPresetItem('Purple Neon', Color(0xFFA855F7), '#A855F7'),
  NineColorPresetItem('Hot Pink', Color(0xFFEC4899), '#EC4899'),
  NineColorPresetItem('Lava Orange', Color(0xFFF97316), '#F97316'),
  NineColorPresetItem('Pure White 6000K', Color(0xFFFFFFFF), '#FFFFFF'),
];
