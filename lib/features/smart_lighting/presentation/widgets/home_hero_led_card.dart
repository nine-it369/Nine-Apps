import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/lighting/nine_color_swatch_rail.dart';
import '../../../../shared/widgets/lighting/nine_color_wheel.dart';
import '../../../../shared/widgets/lighting/nine_led_matrix_banner.dart';
import '../../../../shared/widgets/lighting/nine_vertical_dimmer.dart';
import '../../domain/entities/led_device_entity.dart';
import '../../domain/entities/led_rgb_color.dart';
import '../../domain/entities/smart_lamp_state_entity.dart';
import '../blocs/smart_lighting_bloc.dart';
import '../blocs/smart_lighting_event.dart';
import '../blocs/smart_lighting_state.dart';
import 'smart_lamp_modals.dart';

/// SCR-21 Preview / Beranda Hero Card: Smart Lamp IoT Controller
/// Replicates the Q4 Planning design in D:\Q4 Planning\design\src\modules\home\home.component.js
/// (VIEW C: SMART LAMP #home-hero-led)
class HomeHeroLedCard extends StatelessWidget {
  const HomeHeroLedCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SmartLightingBloc, SmartLightingState>(
      builder: (context, state) {
        final bloc = context.read<SmartLightingBloc>();
        final lamp = state.lampState;
        final device = lamp.activeDevice;
        final activeColor = Color(lamp.color.toArgbInt());
        final isPowerOn = lamp.isPowerOn;
        final hexCode = lamp.color.toHex();
        final double brightnessNormalized = (lamp.brightness / 255.0).clamp(0.0, 1.0);

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF0D0E11),
            borderRadius: AppRadius.heroRadius,
            boxShadow: [
              BoxShadow(
                color: activeColor.withAlpha(isPowerOn ? 60 : 15),
                blurRadius: 36.0,
                spreadRadius: 2.0,
                offset: const Offset(0, 10),
              ),
              const BoxShadow(
                color: Color(0x33000000),
                blurRadius: 20.0,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Subtle Reactive Ambient Aura
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: AppRadius.heroRadius,
                  child: Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 240,
                      height: 240,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            activeColor.withAlpha(isPowerOn ? 65 : 0),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Main Card Content
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top Bar: Device Selector Pill + Studio Shortcut
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Clickable Device Pill -> Opens Device Manager Sheet (BLE Scanner / Switcher)
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            showDeviceManagerSheet(context, bloc);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFF141519).withAlpha(220),
                              borderRadius: BorderRadius.circular(14.0),
                              border: Border.all(color: Colors.white.withAlpha(35)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 7.0,
                                  height: 7.0,
                                  decoration: BoxDecoration(
                                    color: device.isConnected ? AppColors.primary : AppColors.warning,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6.0),
                                Text(
                                  device.id,
                                  style: AppTextStyles.mono.copyWith(
                                    fontSize: 11.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 5.0),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 1.5),
                                  decoration: BoxDecoration(
                                    color: device.isNineSpecific
                                        ? AppColors.primary.withAlpha(45)
                                        : const Color(0xFF00AEEF).withAlpha(40),
                                    borderRadius: BorderRadius.circular(5.0),
                                    border: Border.all(
                                      color: device.isNineSpecific
                                          ? AppColors.primary
                                          : const Color(0xFF00AEEF),
                                      width: 0.8,
                                    ),
                                  ),
                                  child: Text(
                                    device.isNineSpecific ? 'Khusus Nine' : 'Universal',
                                    style: TextStyle(
                                      fontSize: 9.0,
                                      fontWeight: FontWeight.bold,
                                      color: device.isNineSpecific
                                          ? AppColors.primary
                                          : const Color(0xFF38BDF8),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4.0),
                                const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  size: 16.0,
                                  color: Colors.white70,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // "Buka Studio" Button -> Opens Full Smart Lamp Studio (SCR-21)
                        GestureDetector(
                          onTap: () => context.push(RouteNames.smartLampStudio),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(20),
                              borderRadius: BorderRadius.circular(14.0),
                              border: Border.all(color: Colors.white.withAlpha(30)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Buka Studio',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(width: 4.0),
                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 10.0,
                                  color: Colors.white70,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10.0),

                    // Quick Segment Switcher: Khusus Nine (Matrix) vs Lampu Universal
                    Container(
                      height: 32.0,
                      padding: const EdgeInsets.all(2.5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF141519).withAlpha(220),
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(color: Colors.white.withAlpha(22)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (!device.isNineSpecific) {
                                  HapticFeedback.lightImpact();
                                  final nineDev = state.availableDevices.firstWhere(
                                    (d) => d.isNineSpecific,
                                    orElse: () => const LedDeviceEntity(
                                      id: 'NINE-LED-12093',
                                      name: 'Nine LED Matrix',
                                      protocolType: LedProtocolType.manoTechMatrix,
                                    ),
                                  );
                                  bloc.add(ConnectLedDeviceEvent(nineDev.id));
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: device.isNineSpecific ? AppColors.primary : Colors.transparent,
                                  borderRadius: BorderRadius.circular(13.0),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '⚡ Khusus Nine (Matrix)',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.bold,
                                    color: device.isNineSpecific ? AppColors.obsidian : Colors.white60,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (!device.isUniversal) {
                                  HapticFeedback.lightImpact();
                                  final univDev = state.availableDevices.firstWhere(
                                    (d) => d.isUniversal,
                                    orElse: () => const LedDeviceEntity(
                                      id: 'LEDCAR-02-8812',
                                      name: 'LEDCAR-02 BiLED Demon Eye',
                                      protocolType: LedProtocolType.ledLampCar02,
                                    ),
                                  );
                                  bloc.add(ConnectLedDeviceEvent(univDev.id));
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: device.isUniversal ? const Color(0xFF00AEEF) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(13.0),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '🌐 Lampu Universal',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.bold,
                                    color: device.isUniversal ? AppColors.obsidian : Colors.white60,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14.0),

                    // Center Stage: Swatches (Left) + HSV Color Wheel (Center) + Dimmer (Right)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Left: Tactile Quick Swatch Rail
                        NineColorSwatchRail(
                          colors: const [
                            Color(0xFFFFFFFF),
                            Color(0xFFFFB800),
                            Color(0xFF8DC63F),
                            Color(0xFFED1C24),
                          ],
                          tooltips: const [
                            'Putih 6000K',
                            'Amber Sein',
                            'Nine Lime',
                            'Merah Stop',
                          ],
                          selectedColor: activeColor,
                          onSelect: (c) {
                            HapticFeedback.lightImpact();
                            bloc.add(ChangeLampColorEvent(LedRgbColor(c.red, c.green, c.blue)));
                          },
                        ),

                        const SizedBox(width: 14.0),

                        // Center: Precision HSV Color Wheel Disc
                        Container(
                          width: 148.0,
                          height: 148.0,
                          padding: const EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF141519).withAlpha(200),
                            border: Border.all(color: Colors.white.withAlpha(45)),
                            boxShadow: [
                              BoxShadow(
                                color: activeColor.withAlpha(isPowerOn ? 65 : 10),
                                blurRadius: 24.0,
                              ),
                            ],
                          ),
                          child: NineColorWheel(
                            selectedColor: activeColor,
                            onColorChanged: (c) {
                              bloc.add(ChangeLampColorEvent(LedRgbColor(c.red, c.green, c.blue)));
                            },
                            size: 136.0,
                          ),
                        ),

                        const SizedBox(width: 14.0),

                        // Right: Vertical Glass Dimmer
                        NineVerticalDimmer(
                          value: brightnessNormalized,
                          onChanged: (val) {
                            final int pwm = (val * 255.0).round().clamp(0, 255);
                            bloc.add(ChangeLampBrightnessEvent(pwm));
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 12.0),

                    // Interactive Status Pill
                    Center(
                      child: NineHudStatusPill(
                        hexCode: hexCode,
                        color: activeColor,
                        modeName: lamp.activeMode == SmartLampMode.runningText
                            ? lamp.runningText
                            : lamp.activeMode.label,
                        onTap: () {
                          if (lamp.activeMode == SmartLampMode.runningText) {
                            showRunningTextEditorSheet(context, bloc);
                          } else {
                            showColorPickerSheet(context, bloc);
                          }
                        },
                      ),
                    ),

                    const SizedBox(height: 14.0),

                    // Bottom Floating HUD: Power Button (Left) & Mode Button (Right)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Power ON/OFF Toggle
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            bloc.add(const ToggleLampPowerEvent());
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            width: 44.0,
                            height: 44.0,
                            decoration: BoxDecoration(
                              color: isPowerOn
                                  ? AppColors.primary.withAlpha(40)
                                  : const Color(0xFF141519).withAlpha(210),
                              borderRadius: BorderRadius.circular(14.0),
                              border: Border.all(
                                color: isPowerOn
                                    ? AppColors.primary
                                    : Colors.white.withAlpha(30),
                                width: 1.5,
                              ),
                              boxShadow: isPowerOn
                                  ? [
                                      BoxShadow(
                                        color: AppColors.primary.withAlpha(80),
                                        blurRadius: 12.0,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Icon(
                              Icons.power_settings_new_rounded,
                              size: 22.0,
                              color: isPowerOn ? AppColors.primary : Colors.white54,
                            ),
                          ),
                        ),

                        // Mode Selector Button
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            if (device.isUniversal) {
                              showColorPickerSheet(context, bloc);
                            } else {
                              showStoplampModeSheet(context, bloc);
                            }
                          },
                          child: Container(
                            height: 44.0,
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            decoration: BoxDecoration(
                              color: device.isUniversal ? const Color(0xFF00AEEF) : AppColors.primary,
                              borderRadius: BorderRadius.circular(14.0),
                              boxShadow: [
                                BoxShadow(
                                  color: device.isUniversal
                                      ? const Color(0x4D00AEEF)
                                      : const Color(0x4D8DC63F),
                                  blurRadius: 16.0,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  device.isUniversal ? Icons.palette_rounded : Icons.tune_rounded,
                                  size: 18.0,
                                  color: AppColors.obsidian,
                                ),
                                const SizedBox(width: 8.0),
                                Text(
                                  device.isUniversal
                                      ? 'Mode: Universal RGB'
                                      : 'Mode: ${lamp.activeMode.label}',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.obsidian,
                                  ),
                                ),
                              ],
                            ),
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
}
