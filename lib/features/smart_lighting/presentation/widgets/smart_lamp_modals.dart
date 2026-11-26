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

IconData _getDeviceIcon(LedProtocolType type) {
  switch (type) {
    case LedProtocolType.manoTechMatrix:
      return Icons.grid_view_rounded;
    case LedProtocolType.ledLampCar02:
      return Icons.wb_iridescent_rounded;
    case LedProtocolType.happyLightingTriones:
      return Icons.light_mode_rounded;
  }
}

/// 5. Modal Sheet: Device Manager & BLE Discovery (SCR-21 Header Tap & Home Card Tap)
/// Helper to render device category badge (Khusus Nine vs Universal)
Widget _buildCategoryBadge(LedDeviceCategory category) {
  final isNine = category == LedDeviceCategory.nineSpecific;
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      color: isNine ? AppColors.primary.withAlpha(45) : const Color(0xFF00AEEF).withAlpha(35),
      borderRadius: BorderRadius.circular(6),
      border: Border.all(
        color: isNine ? AppColors.primary : const Color(0xFF00AEEF),
        width: 0.8,
      ),
    ),
    child: Text(
      isNine ? 'Khusus Nine (Matrix)' : 'Lampu Universal',
      style: TextStyle(
        fontSize: 9.5,
        fontWeight: FontWeight.bold,
        color: isNine ? AppColors.primaryDark : const Color(0xFF0284C7),
      ),
    ),
  );
}

/// 7. Modal Sheet: Kelola Perangkat Smart Lamp (BLE Scanner & Switcher)
void showDeviceManagerSheet(BuildContext context, SmartLightingBloc bloc) {
  var selectedCategoryFilter = 0; // 0: Semua, 1: Khusus Nine, 2: Universal

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider.value(
      value: bloc,
      child: StatefulBuilder(
        builder: (modalCtx, setModalState) {
          return BlocBuilder<SmartLightingBloc, SmartLightingState>(
            builder: (ctx, state) {
              final activeDevice = state.lampState.activeDevice;
              final isScanning = state.isConnecting;
              final nineCount = state.availableDevices.where((d) => d.isNineSpecific).length;
              final univCount = state.availableDevices.where((d) => d.isUniversal).length;

              final filteredDevices = state.availableDevices.where((d) {
                if (selectedCategoryFilter == 1) return d.isNineSpecific;
                if (selectedCategoryFilter == 2) return d.isUniversal;
                return true;
              }).toList();

              return _SheetShell(
                title: 'Kelola Perangkat Smart Lamp',
                subtitle: 'Pindai BLE 5.2, hubungkan, & tambah lampu custom',
                children: [
                  // Active Connected Lamp Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.obsidian,
                      borderRadius: AppRadius.mdRadius,
                      border: Border.all(color: AppColors.primary.withAlpha(160), width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'LAMPU AKTIF TERHUBUNG',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.white12,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'RSSI ${activeDevice.rssi} dBm',
                                style: AppTextStyles.mono.copyWith(fontSize: 10, color: Colors.white70),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(20),
                                borderRadius: AppRadius.smRadius,
                              ),
                              child: Icon(
                                _getDeviceIcon(activeDevice.protocolType),
                                color: AppColors.primary,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          activeDevice.name,
                                          style: AppTextStyles.h3.copyWith(color: Colors.white, fontSize: 13.5),
                                        ),
                                      ),
                                      _buildCategoryBadge(activeDevice.category),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    '${activeDevice.id} • ${activeDevice.protocolType.name} • ${activeDevice.pinOrder.label}',
                                    style: AppTextStyles.mono.copyWith(color: Colors.white60, fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Category Filter Chips (D:\Q4 Planning Style)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip(
                          label: 'Semua (${state.availableDevices.length})',
                          isSelected: selectedCategoryFilter == 0,
                          onTap: () => setModalState(() => selectedCategoryFilter = 0),
                        ),
                        const SizedBox(width: 6),
                        _buildFilterChip(
                          label: 'Khusus Nine ($nineCount)',
                          isSelected: selectedCategoryFilter == 1,
                          onTap: () => setModalState(() => selectedCategoryFilter = 1),
                        ),
                        const SizedBox(width: 6),
                        _buildFilterChip(
                          label: 'Universal ($univCount)',
                          isSelected: selectedCategoryFilter == 2,
                          onTap: () => setModalState(() => selectedCategoryFilter = 2),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Scanner Controls Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Daftar Perangkat Terdeteksi', style: AppTextStyles.h3.copyWith(fontSize: 13)),
                      TextButton.icon(
                        onPressed: isScanning
                            ? null
                            : () {
                                HapticFeedback.lightImpact();
                                bloc.add(const InitSmartLightingEvent());
                              },
                        icon: Icon(
                          isScanning ? Icons.sync_rounded : Icons.refresh_rounded,
                          size: 16,
                          color: AppColors.primaryDark,
                        ),
                        label: Text(
                          isScanning ? 'Memindai...' : 'Pindai Ulang',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Available devices list
                  ...filteredDevices.map((dev) {
                    final isActive = dev.id == activeDevice.id;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.primaryLight.withAlpha(120) : AppColors.surface,
                          borderRadius: AppRadius.mdRadius,
                          border: Border.all(
                            color: isActive ? AppColors.primary : AppColors.borderSubtle,
                            width: isActive ? 1.5 : 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: isActive ? AppColors.obsidian : AppColors.surfaceMuted,
                                borderRadius: AppRadius.smRadius,
                              ),
                              child: Icon(
                                _getDeviceIcon(dev.protocolType),
                                color: isActive ? AppColors.primary : AppColors.textPrimary,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          dev.name,
                                          style: AppTextStyles.h3.copyWith(fontSize: 12.5),
                                        ),
                                      ),
                                      _buildCategoryBadge(dev.category),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${dev.id} • ${dev.protocolType.name}',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      fontSize: 10.5,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (isActive)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.check_rounded, size: 14, color: AppColors.obsidian),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Aktif',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.obsidian,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.obsidian,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                onPressed: () {
                                  HapticFeedback.lightImpact();
                                  bloc.add(ConnectLedDeviceEvent(dev.id));
                                },
                                child: const Text('Hubungkan', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                              ),
                          ],
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 12),

                  // Button "+ Tambah Lampu Baru"
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: AppColors.primary, width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: AppRadius.buttonRadius),
                      ),
                      icon: const Icon(Icons.add_rounded, color: AppColors.primaryDark),
                      label: Text(
                        'Tambah Lampu BLE Baru (+ Pairing)',
                        style: AppTextStyles.h3.copyWith(fontSize: 13, color: AppColors.primaryDark),
                      ),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        _showAddDeviceDialog(context, bloc);
                      },
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Advanced Hardware Calibration Link
                  Center(
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        showHardwareCalibrationSheet(context, bloc);
                      },
                      icon: const Icon(Icons.tune_rounded, size: 15, color: AppColors.textSecondary),
                      label: Text(
                        'Kalibrasi Pin RGB & Tipe IC Driver',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    ),
  );
}

Widget _buildFilterChip({
  required String label,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: () {
      HapticFeedback.lightImpact();
      onTap();
    },
    child: Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF231F20) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: isSelected ? Colors.white : const Color(0xFF231F20),
        ),
      ),
    ),
  );
}

void _showAddDeviceDialog(BuildContext context, SmartLightingBloc bloc) {
  final nameController = TextEditingController(text: 'Nine Custom Demon Eye');
  var selectedCategory = LedDeviceCategory.nineSpecific;

  showDialog<void>(
    context: context,
    builder: (dialogCtx) => StatefulBuilder(
      builder: (dCtx, setDialogState) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: AppRadius.mdRadius),
          title: Row(
            children: [
              const Icon(Icons.bluetooth_searching_rounded, color: AppColors.primaryDark),
              const SizedBox(width: 8),
              Text('Pairing Lampu Baru', style: AppTextStyles.h3),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pilih jenis lampu yang akan dipasangkan ke aplikasi:',
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Khusus Nine (Matrix)', style: TextStyle(fontSize: 11)),
                      selected: selectedCategory == LedDeviceCategory.nineSpecific,
                      selectedColor: AppColors.primary,
                      onSelected: (val) {
                        if (val) setDialogState(() => selectedCategory = LedDeviceCategory.nineSpecific);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Universal (RGB)', style: TextStyle(fontSize: 11)),
                      selected: selectedCategory == LedDeviceCategory.universal,
                      selectedColor: AppColors.primary,
                      onSelected: (val) {
                        if (val) setDialogState(() => selectedCategory = LedDeviceCategory.universal);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Lampu / Posisi',
                  hintText: 'Misal: Lampu Kolong / Stoplamp Belakang',
                  filled: true,
                  fillColor: AppColors.surfaceMuted,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withAlpha(80),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, size: 18, color: AppColors.primaryDark),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        selectedCategory == LedDeviceCategory.nineSpecific
                            ? 'Ditemukan modul NINE Tail Light (Matrix LED BLE 5.2)'
                            : 'Ditemukan kontroler LED Universal (RGB Car02 / Triones)',
                        style: AppTextStyles.bodySmall.copyWith(fontSize: 10.5, color: AppColors.primaryDark),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.obsidian,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.of(dialogCtx).pop();
                HapticFeedback.mediumImpact();
                // Connect to appropriate device based on category
                final targetId = selectedCategory == LedDeviceCategory.nineSpecific
                    ? 'NINE-LED-12093'
                    : 'LEDCAR-02-8812';
                bloc.add(ConnectLedDeviceEvent(targetId));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Lampu "${nameController.text}" (${selectedCategory.label}) berhasil ditambahkan & terhubung!'),
                    backgroundColor: AppColors.primaryDark,
                  ),
                );
              },
              child: const Text('Tautkan Sekarang', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    ),
  );
}
