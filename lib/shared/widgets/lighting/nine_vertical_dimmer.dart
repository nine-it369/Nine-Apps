import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';

/// Smoked-glass vertical brightness dimmer rail (0.0 to 1.0)
class NineVerticalDimmer extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final double width;
  final double height;

  const NineVerticalDimmer({
    super.key,
    required this.value,
    required this.onChanged,
    this.width = 44.0,
    this.height = 156.0,
  });

  void _handleDrag(Offset localPos) {
    final clampedY = localPos.dy.clamp(0.0, height);
    final normalized = 1.0 - (clampedY / height);
    onChanged(normalized.clamp(0.0, 1.0));
  }

  @override
  Widget build(BuildContext context) {
    final pctInt = (value * 100).round();
    final fillHeight = (height * value).clamp(0.0, height);

    return GestureDetector(
      onVerticalDragStart: (d) => _handleDrag(d.localPosition),
      onVerticalDragUpdate: (d) => _handleDrag(d.localPosition),
      onTapDown: (d) => _handleDrag(d.localPosition),
      child: Container(
        width: width,
        height: height,
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
        clipBehavior: Clip.antiAlias,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              left: 6.0,
              top: height * 0.25,
              child: Container(width: 5.0, height: 1.0, color: Colors.white.withAlpha(64)),
            ),
            Positioned(
              left: 6.0,
              top: height * 0.50,
              child: Container(width: 8.0, height: 1.0, color: Colors.white.withAlpha(85)),
            ),
            Positioned(
              left: 6.0,
              top: height * 0.75,
              child: Container(width: 5.0, height: 1.0, color: Colors.white.withAlpha(64)),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: width,
                height: fillHeight,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Color.fromRGBO(141, 198, 63, 0.85),
                      Color.fromRGBO(141, 198, 63, 0.45),
                    ],
                  ),
                  border: Border(
                    top: BorderSide(color: Colors.white.withAlpha(215), width: 2.0),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 8.0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(140),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.wb_sunny_rounded, size: 11.0, color: Colors.white),
                    const SizedBox(height: 1.0),
                    Text(
                      '$pctInt%',
                      style: AppTextStyles.mono.copyWith(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
