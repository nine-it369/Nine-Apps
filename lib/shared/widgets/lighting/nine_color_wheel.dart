import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Interactive 360-degree HSV Conic Color Wheel matching Q4 Planning Design
class NineColorWheel extends StatefulWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorChanged;
  final double size;

  const NineColorWheel({
    super.key,
    required this.selectedColor,
    required this.onColorChanged,
    this.size = 162.0,
  });

  @override
  State<NineColorWheel> createState() => _NineColorWheelState();
}

class _NineColorWheelState extends State<NineColorWheel> {
  late Offset _thumbPosition;

  @override
  void initState() {
    super.initState();
    _thumbPosition = _colorToOffset(widget.selectedColor);
  }

  @override
  void didUpdateWidget(NineColorWheel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedColor != widget.selectedColor) {
      _thumbPosition = _colorToOffset(widget.selectedColor);
    }
  }

  Offset _colorToOffset(Color color) {
    final hsv = HSVColor.fromColor(color);
    final radius = widget.size / 2.0;
    final r = hsv.saturation * (radius - 12.0);
    final angle = hsv.hue * (math.pi / 180.0);
    return Offset(
      radius + r * math.cos(angle),
      radius + r * math.sin(angle),
    );
  }

  void _handleTouch(Offset localPos) {
    final radius = widget.size / 2.0;
    final dx = localPos.dx - radius;
    final dy = localPos.dy - radius;
    final dist = math.sqrt(dx * dx + dy * dy);
    final maxRadius = radius - 10.0;

    if (dist < 10.0) {
      setState(() => _thumbPosition = Offset(radius, radius));
      widget.onColorChanged(Colors.white);
      return;
    }

    final clampedDist = math.min(dist, maxRadius);
    var angle = math.atan2(dy, dx);
    if (angle < 0) angle += 2 * math.pi;

    final hue = (angle * (180.0 / math.pi)) % 360.0;
    final saturation = (clampedDist / maxRadius).clamp(0.0, 1.0);

    setState(() {
      _thumbPosition = Offset(
        radius + clampedDist * math.cos(angle),
        radius + clampedDist * math.sin(angle),
      );
    });

    widget.onColorChanged(HSVColor.fromAHSV(1.0, hue, saturation, 1.0).toColor());
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.size / 2.0;

    return GestureDetector(
      onPanStart: (d) => _handleTouch(d.localPosition),
      onPanUpdate: (d) => _handleTouch(d.localPosition),
      onTapDown: (d) => _handleTouch(d.localPosition),
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3.5),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.45),
              blurRadius: 16.0,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: widget.size,
              height: widget.size,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: SweepGradient(
                  colors: [
                    Color(0xFFFF0000),
                    Color(0xFFFFFF00),
                    Color(0xFF00FF00),
                    Color(0xFF00FFFF),
                    Color(0xFF0000FF),
                    Color(0xFFFF00FF),
                    Color(0xFFFF0000),
                  ],
                ),
              ),
            ),
            Container(
              width: widget.size,
              height: widget.size,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color.fromRGBO(255, 255, 255, 0.94),
                    Color.fromRGBO(255, 255, 255, 0.34),
                    Color.fromRGBO(255, 255, 255, 0.0),
                  ],
                  stops: [0.0, 0.34, 0.70],
                ),
              ),
            ),
            Positioned(
              left: radius - 8.0,
              top: radius - 8.0,
              child: Container(
                width: 16.0,
                height: 16.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withAlpha(40),
                  border: Border.all(color: Colors.white.withAlpha(110), width: 1.0),
                ),
              ),
            ),
            Positioned(
              left: _thumbPosition.dx - 11.0,
              top: _thumbPosition.dy - 11.0,
              child: Container(
                width: 22.0,
                height: 22.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.selectedColor,
                  border: Border.all(color: Colors.white, width: 2.5),
                  boxShadow: [
                    const BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.65),
                      blurRadius: 8.0,
                      offset: Offset(0, 2),
                    ),
                    BoxShadow(
                      color: widget.selectedColor.withAlpha(150),
                      blurRadius: 10.0,
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
