import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/buttons/nine_primary_button.dart';
import '../../../../shared/widgets/lighting/nine_color_swatch_rail.dart';
import '../../../../shared/widgets/lighting/nine_color_wheel.dart';
import '../../../../shared/widgets/lighting/nine_led_matrix_banner.dart';
import '../../../../shared/widgets/lighting/nine_lighting_controls.dart';
import '../../domain/entities/led_device_entity.dart';
import '../../domain/entities/led_rgb_color.dart';
import '../../domain/entities/smart_lamp_state_entity.dart';
import '../blocs/smart_lighting_bloc.dart';
import '../blocs/smart_lighting_event.dart';
import '../blocs/smart_lighting_state.dart';

IconData _modeIcon(SmartLampMode mode) {
  switch (mode) {
    case SmartLampMode.runningText:
      return Icons.text_fields_rounded;
    case SmartLampMode.dynamicSign:
      return Icons.compare_arrows_rounded;
    case SmartLampMode.brakeStrobe:
      return Icons.adjust_rounded;
    case SmartLampMode.welcomeLight:
      return Icons.auto_awesome_rounded;
    case SmartLampMode.sideLed:
      return Icons.wb_sunny_outlined;
    case SmartLampMode.solidColor:
      return Icons.palette_outlined;
  }
}

class _SheetShell extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> children;

  const _SheetShell({
    required this.title,
    this.subtitle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.modalRadius,
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: AppRadius.pillRadius,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTextStyles.h3),
                      if (subtitle != null)
                        Text(subtitle!, style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, size: 20),
                ),
              ],
            ),
            const Divider(height: 16, color: AppColors.borderSubtle),
            ...children,
          ],
        ),
      ),
    );
  }
}

/// 1. Modal Sheet: Pilih Mode Smart Lamp (6 Modes)
void showStoplampModeSheet(BuildContext context, SmartLightingBloc bloc) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider.value(
      value: bloc,
      child: BlocBuilder<SmartLightingBloc, SmartLightingState>(
        builder: (ctx, state) {
          final currentMode = state.lampState.activeMode;
          return _SheetShell(
            title: 'Pilih Mode Smart Lamp',
            children: SmartLampMode.values.map((mode) {
              final subtitle = mode == SmartLampMode.runningText
                  ? 'Teks: ${state.lampState.runningText}'
                  : mode.description;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: NineLightingModeCard(
                  title: mode.label,
                  subtitle: subtitle,
                  icon: _modeIcon(mode),
                  isSelected: currentMode == mode,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    bloc.add(SelectLampModeEvent(mode));
                    Navigator.pop(ctx);
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
    ),
  );
}

/// 2. Modal Sheet: Running Text Quick Editor (ST,7 & ST,9)
void showRunningTextEditorSheet(BuildContext context, SmartLightingBloc bloc) {
  final current = bloc.state.lampState;
  final controller = TextEditingController(text: current.runningText);
  var selectedSpeed = current.textSpeedMs;

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setModalState) {
        final previewColor = Color(current.color.toArgbInt());
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: _SheetShell(
            title: 'Atur Running Text',
            subtitle: 'Teks yang tampil berjalan pada panel LED',
            children: [
              NineLedMatrixBanner(text: controller.text, color: previewColor),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Teks Tampilan', style: AppTextStyles.h3.copyWith(fontSize: 12)),
                  Text(
                    '${controller.text.length}/32',
                    style: AppTextStyles.mono.copyWith(fontSize: 11, color: AppColors.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              TextField(
                controller: controller,
                maxLength: 32,
                textCapitalization: TextCapitalization.characters,
                onChanged: (_) => setModalState(() {}),
                style: AppTextStyles.mono.copyWith(fontSize: 13, fontWeight: FontWeight.w700),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: 'Contoh: NINE AUTOSERIES',
                  filled: true,
                  fillColor: AppColors.surfaceMuted,
                  border: OutlineInputBorder(
                    borderRadius: AppRadius.squircleRadius,
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text('Pilihan Cepat', style: AppTextStyles.bodySmall),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: ['NINE AUTOSERIES', 'HONDA HR-V', 'JAGA JARAK AMAN', 'KEEP DISTANCE']
                    .map((preset) => ActionChip(
                          label: Text(preset, style: AppTextStyles.mono.copyWith(fontSize: 10.5)),
                          backgroundColor: AppColors.surfaceMuted,
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            controller.text = preset;
                            setModalState(() {});
                          },
                        ))
                    .toList(),
              ),
              const SizedBox(height: 14),
              Text('Kecepatan Gerak Teks', style: AppTextStyles.bodySmall),
              const SizedBox(height: 6),
              Row(
                children: [
                  _SpeedOptionButton(
                    label: 'Santai',
                    speedMs: 220,
                    selected: selectedSpeed >= 180,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setModalState(() => selectedSpeed = 220);
                    },
                  ),
                  const SizedBox(width: 8),
                  _SpeedOptionButton(
                    label: 'Normal',
                    speedMs: 140,
                    selected: selectedSpeed > 100 && selectedSpeed < 180,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setModalState(() => selectedSpeed = 140);
                    },
                  ),
                  const SizedBox(width: 8),
                  _SpeedOptionButton(
                    label: 'Cepat',
                    speedMs: 80,
                    selected: selectedSpeed <= 100,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setModalState(() => selectedSpeed = 80);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 18),
              NinePrimaryButton(
                label: 'Kirim Running Text ke Smart LED',
                icon: Icons.send_rounded,
                onPressed: () {
                  HapticFeedback.lightImpact();
                  bloc.add(UpdateRunningTextEvent(controller.text, speedMs: selectedSpeed));
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        );
      },
    ),
  );
}

class _SpeedOptionButton extends StatelessWidget {
  final String label;
  final int speedMs;
  final bool selected;
  final VoidCallback onTap;

  const _SpeedOptionButton({
    required this.label,
    required this.speedMs,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: selected ? AppColors.textPrimary : AppColors.surfaceMuted,
            borderRadius: AppRadius.mdRadius,
            border: Border.all(
              color: selected ? AppColors.textPrimary : AppColors.border,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            '$label ($speedMs ms)',
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w700,
              color: selected ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

/// 3. Modal Sheet: Color Wheel & 8 Automotive Quick Presets
void showColorPickerSheet(BuildContext context, SmartLightingBloc bloc) {
  final initialColor = Color(bloc.state.lampState.color.toArgbInt());
  Color tempColor = initialColor;

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setModalState) {
        final hex = '#${tempColor.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
        return _SheetShell(
          title: 'Color Wheel Picker',
          subtitle: 'Pilih spektrum warna custom Smart LED Demon Eye',
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: AppRadius.squircleRadius,
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: tempColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Spektrum Terpilih', style: AppTextStyles.h3.copyWith(fontSize: 12)),
                        Text(hex, style: AppTextStyles.mono.copyWith(fontSize: 11, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: AppRadius.pillRadius,
                    ),
                    child: Text('Preview', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: NineColorWheel(
                size: 152,
                selectedColor: tempColor,
                onColorChanged: (c) => setModalState(() => tempColor = c),
              ),
            ),
            const SizedBox(height: 12),
            Text('PRESET WARNA OTOMOTIF', style: AppTextStyles.bodySmall),
            const SizedBox(height: 6),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 2.6,
              ),
              itemCount: kAutomotiveColorPresets.length,
              itemBuilder: (_, idx) {
                final p = kAutomotiveColorPresets[idx];
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    setModalState(() => tempColor = p.color);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: p.color,
                      borderRadius: AppRadius.mdRadius,
                      border: Border.all(color: Colors.black.withAlpha(30)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      p.name.split(' ').first,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w800,
                        color: p.color.computeLuminance() > 0.5 ? AppColors.textPrimary : Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 14),
            NinePrimaryButton(
              label: 'Terapkan Warna ke Smart LED',
              icon: Icons.check_rounded,
              onPressed: () {
                HapticFeedback.lightImpact();
                final rgb = LedRgbColor.fromHex(hex);
                bloc.add(ChangeLampColorEvent(rgb));
                Navigator.pop(ctx);
              },
            ),
          ],
        );
      },
    ),
  );
}

/// 4. Modal Sheet: Hardware Calibration & Device Switcher (pedoman_Apps RgbSort + ChipSelect + GATT Log)
void showHardwareCalibrationSheet(BuildContext context, SmartLightingBloc bloc) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider.value(
      value: bloc,
      child: BlocBuilder<SmartLightingBloc, SmartLightingState>(
        builder: (ctx, state) {
          final activeDevice = state.lampState.activeDevice;
          return _SheetShell(
            title: 'Kalibrasi Hardware & BLE',
            subtitle: 'Protokol Triones, LEDCAR-02, RGB Sort & IC Chip',
            children: [
              Text('Perangkat Terdeteksi (BLE 5.2)', style: AppTextStyles.bodySmall),
              const SizedBox(height: 6),
              ...state.availableDevices.map((dev) {
                final isActive = dev.id == activeDevice.id;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: NineLightingModeCard(
                    title: dev.name,
                    subtitle: '${dev.protocolType.name} • Pin: ${dev.pinOrder.label} • ${dev.icChipType.label}',
                    icon: Icons.bluetooth_connected_rounded,
                    isSelected: isActive,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      bloc.add(ConnectLedDeviceEvent(dev.id));
                    },
                  ),
                );
              }),
              const SizedBox(height: 8),
              Text('Kalibrasi Urutan Pin Kabel (RGB Sort)', style: AppTextStyles.bodySmall),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: RgbPinOrder.values.map((order) {
                  final selected = activeDevice.pinOrder == order;
                  return ChoiceChip(
                    label: Text(order.label, style: AppTextStyles.mono.copyWith(fontSize: 11)),
                    selected: selected,
                    selectedColor: AppColors.primary,
                    onSelected: (_) {
                      HapticFeedback.lightImpact();
                      bloc.add(UpdateRgbPinOrderEvent(order));
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              Text('Tipe IC Driver & Jumlah Piksel LED', style: AppTextStyles.bodySmall),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: LedIcChipType.values.map((chip) {
                  final selected = activeDevice.icChipType == chip;
                  return ChoiceChip(
                    label: Text(chip.label, style: AppTextStyles.mono.copyWith(fontSize: 11)),
                    selected: selected,
                    selectedColor: AppColors.primary,
                    onSelected: (_) {
                      HapticFeedback.lightImpact();
                      bloc.add(UpdateIcChipConfigEvent(chip, activeDevice.pixelCount));
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                children: [16, 32, 60, 120].map((px) {
                  final selected = activeDevice.pixelCount == px;
                  return ChoiceChip(
                    label: Text('$px LED', style: AppTextStyles.mono.copyWith(fontSize: 11)),
                    selected: selected,
                    selectedColor: AppColors.primaryLight,
                    onSelected: (_) {
                      HapticFeedback.lightImpact();
                      bloc.add(UpdateIcChipConfigEvent(activeDevice.icChipType, px));
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.obsidian,
                  borderRadius: AppRadius.squircleRadius,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TELEMETRI HEX GATT TERAKHIR',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      state.lampState.lastHexFrameSent,
                      style: AppTextStyles.mono.copyWith(color: Colors.white, fontSize: 11.5),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    ),
  );
}
