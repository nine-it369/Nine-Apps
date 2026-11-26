import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/lighting/nine_color_swatch_rail.dart';
import '../../../../shared/widgets/lighting/nine_color_wheel.dart';
import '../../../../shared/widgets/lighting/nine_led_matrix_banner.dart';
import '../../../../shared/widgets/lighting/nine_lighting_controls.dart';
import '../../../../shared/widgets/lighting/nine_vertical_dimmer.dart';
import '../../domain/entities/led_rgb_color.dart';
import '../../domain/entities/smart_lamp_state_entity.dart';
import '../blocs/smart_lighting_bloc.dart';
import '../blocs/smart_lighting_event.dart';
import '../blocs/smart_lighting_state.dart';
import '../widgets/smart_lamp_modals.dart';
import 'sensor_override_screen.dart';

/// SCR-21: Nine LED Matrix Detail / Smart Lamp Studio
/// Mirrors Q4 Planning Design (#screen-iot-led-detail) + pedoman_Apps BLE Protocols
class SmartLampStudioScreen extends StatefulWidget {
  const SmartLampStudioScreen({super.key});

  @override
  State<SmartLampStudioScreen> createState() => _SmartLampStudioScreenState();
}

class _SmartLampStudioScreenState extends State<SmartLampStudioScreen> {
  final PageController _pageController = PageController(viewportFraction: 1.0);
  late TextEditingController _textController;
  int _activeSlideIndex = 0;

  static const List<Color> _railColors = [
    Color(0xFFFFFFFF), // Putih 6000K
    Color(0xFFFFB800), // Amber Sein
    Color(0xFFED1C24), // Devil Red
    Color(0xFF8DC63F), // Cyber Green
  ];

  static const List<String> _railTooltips = [
    'Putih 6000K',
    'Amber Sein',
    'Devil Red',
    'Cyber Green',
  ];

  static const List<String> _textColorSwatches = [
    '#8DC63F',
    '#ED1C24',
    '#00AEEF',
    '#FFB800',
    '#FFFFFF',
  ];

  @override
  void initState() {
    super.initState();
    final initialText = context.read<SmartLightingBloc>().state.lampState.runningText;
    _textController = TextEditingController(text: initialText);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _goToSlide(int index) {
    HapticFeedback.lightImpact();
    setState(() => _activeSlideIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0E11),
      body: BlocConsumer<SmartLightingBloc, SmartLightingState>(
        listener: (context, state) {
          if (_textController.text != state.lampState.runningText) {
            _textController.text = state.lampState.runningText;
          }
          if (state.feedbackMessage != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.feedbackMessage!),
                  duration: const Duration(milliseconds: 1400),
                  behavior: SnackBarBehavior.floating,
                ),
              );
          } else if (state.errorMessage != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: AppColors.danger,
                  behavior: SnackBarBehavior.floating,
                ),
              );
          }
        },
        builder: (context, state) {
          final lamp = state.lampState;
          final activeColor = Color(lamp.color.toArgbInt());
          final brightnessFactor = lamp.isPowerOn ? (lamp.brightness / 255.0) : 0.0;
          final isSideMode = lamp.isPowerOn && lamp.activeMode == SmartLampMode.sideLed;

          return SafeArea(
            bottom: false,
            child: Column(
              children: [
                // 1. TOP DARK COCKPIT SIMULATOR STAGE (345px)
                SizedBox(
                  height: 345,
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Subtle Dot-Grid Background Pattern
                      Positioned.fill(
                        child: CustomPaint(painter: _DotGridPainter()),
                      ),

                      // Reactive Ambient Aura Center Glow
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 280),
                        width: 240,
                        height: 240,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: activeColor.withAlpha((100 * brightnessFactor).round()),
                              blurRadius: 95,
                              spreadRadius: 24,
                            ),
                          ],
                        ),
                      ),

                      // Side Aura Left & Right (active when Side LED mode is selected)
                      Positioned(
                        left: 0,
                        top: 40,
                        bottom: 48,
                        width: 56,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 280),
                          opacity: isSideMode ? 1.0 : 0.0,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                center: Alignment.centerLeft,
                                radius: 1.0,
                                colors: [
                                  activeColor.withAlpha(110),
                                  activeColor.withAlpha(0),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 40,
                        bottom: 48,
                        width: 56,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 280),
                          opacity: isSideMode ? 1.0 : 0.0,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                center: Alignment.centerRight,
                                radius: 1.0,
                                colors: [
                                  activeColor.withAlpha(110),
                                  activeColor.withAlpha(0),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Top Floating Header Bar
                      Positioned(
                        top: 10,
                        left: 16,
                        right: 16,
                        child: _buildTopHeader(context, state),
                      ),

                      // Center Triple Capsule Controller + Status Pill
                      Positioned(
                        top: 66,
                        left: 16,
                        right: 16,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                NineColorSwatchRail(
                                  colors: _railColors,
                                  tooltips: _railTooltips,
                                  selectedColor: activeColor,
                                  onSelect: (c) {
                                    HapticFeedback.lightImpact();
                                    final hex = '#${c.toARGB32().toRadixString(16).substring(2)}';
                                    context.read<SmartLightingBloc>().add(
                                          ChangeLampColorEvent(LedRgbColor.fromHex(hex)),
                                        );
                                  },
                                ),
                                const SizedBox(width: 14),
                                _buildCenterStageControl(context, lamp, activeColor),
                                const SizedBox(width: 14),
                                NineVerticalDimmer(
                                  value: lamp.brightness / 255.0,
                                  onChanged: (v) {
                                    context.read<SmartLightingBloc>().add(
                                          ChangeLampBrightnessEvent((v * 255).round()),
                                        );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            NineHudStatusPill(
                              hexCode: lamp.color.toHex(),
                              color: activeColor,
                              modeName: lamp.activeMode == SmartLampMode.runningText
                                  ? lamp.runningText
                                  : lamp.activeMode.label,
                              onTap: () {
                                HapticFeedback.lightImpact();
                                final bloc = context.read<SmartLightingBloc>();
                                if (lamp.activeMode == SmartLampMode.runningText) {
                                  showRunningTextEditorSheet(context, bloc);
                                } else {
                                  showColorPickerSheet(context, bloc);
                                }
                              },
                            ),
                          ],
                        ),
                      ),

                      // Bottom 2D Floating HUD Bar
                      Positioned(
                        bottom: 18,
                        left: 16,
                        right: 16,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                context.read<SmartLightingBloc>().add(const ToggleLampPowerEvent());
                              },
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(20, 21, 25, 0.72),
                                  borderRadius: AppRadius.squircleRadius,
                                  border: Border.all(
                                    color: lamp.isPowerOn
                                        ? AppColors.primary.withAlpha(160)
                                        : Colors.white.withAlpha(45),
                                  ),
                                ),
                                child: Icon(
                                  Icons.power_settings_new_rounded,
                                  size: 20,
                                  color: lamp.isPowerOn ? AppColors.primary : Colors.white54,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                showStoplampModeSheet(context, context.read<SmartLightingBloc>());
                              },
                              child: Container(
                                height: 44,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: AppRadius.squircleRadius,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color.fromRGBO(141, 198, 63, 0.35),
                                      blurRadius: 16,
                                      offset: Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.tune_rounded, size: 18, color: AppColors.textPrimary),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Mode: ${lamp.activeMode.label}',
                                      style: AppTextStyles.button.copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. BOTTOM CURVED SOLID WHITE SHEET (SLIDABLE 4-SLIDE CAROUSEL)
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: AppRadius.modalRadius,
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.08),
                          blurRadius: 20,
                          offset: Offset(0, -4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(4, (idx) {
                            final isActive = _activeSlideIndex == idx;
                            return GestureDetector(
                              onTap: () => _goToSlide(idx),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 220),
                                margin: const EdgeInsets.symmetric(horizontal: 3),
                                height: 6,
                                width: isActive ? 24 : 6,
                                decoration: BoxDecoration(
                                  color: isActive ? AppColors.primary : AppColors.border,
                                  borderRadius: AppRadius.pillRadius,
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: PageView(
                            controller: _pageController,
                            onPageChanged: (idx) => setState(() => _activeSlideIndex = idx),
                            children: [
                              _buildSlide0RunningText(context, lamp),
                              _buildSlide1SignAndBrake(context, lamp),
                              _buildSlide2WelcomeAndSide(context, lamp),
                              _buildSlide3BrightnessAndTransition(context, lamp),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopHeader(BuildContext context, SmartLightingState state) {
    final device = state.lampState.activeDevice;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).maybePop(),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(20, 21, 25, 0.68),
              borderRadius: AppRadius.squircleRadius,
              border: Border.all(color: Colors.white.withAlpha(48)),
            ),
            child: const Icon(Icons.chevron_left_rounded, color: Colors.white, size: 26),
          ),
        ),
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            showHardwareCalibrationSheet(context, context.read<SmartLightingBloc>());
          },
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(20, 21, 25, 0.68),
              borderRadius: AppRadius.squircleRadius,
              border: Border.all(color: Colors.white.withAlpha(48)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lightbulb_outline_rounded, size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      device.id,
                      style: AppTextStyles.h3.copyWith(fontSize: 11.5, color: Colors.white),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: device.isConnected ? AppColors.primary : AppColors.warning,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${device.isConnected ? "Online" : "Offline"} • BLE 5.2 • ${device.pinOrder.label}',
                          style: AppTextStyles.mono.copyWith(fontSize: 9.5, color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Center Stage: Color Wheel OR Interactive 2x2 Context-Aware Animation Preset Grid
  Widget _buildCenterStageControl(
    BuildContext context,
    SmartLampStateEntity lamp,
    Color activeColor,
  ) {
    final bloc = context.read<SmartLightingBloc>();
    if (lamp.activeMode == SmartLampMode.dynamicSign) {
      return _StagePresetGrid<SignLightStyle>(
        items: SignLightStyle.values,
        selectedItem: lamp.signStyle,
        labelOf: (s) => s.label,
        onSelect: (s) => bloc.add(SelectSignStyleEvent(s)),
      );
    }
    if (lamp.activeMode == SmartLampMode.brakeStrobe) {
      return _StagePresetGrid<BrakeLightStyle>(
        items: BrakeLightStyle.values,
        selectedItem: lamp.brakeStyle,
        labelOf: (b) => b.label,
        onSelect: (b) => bloc.add(SelectBrakeStyleEvent(b)),
      );
    }
    if (lamp.activeMode == SmartLampMode.welcomeLight) {
      return _StagePresetGrid<WelcomeLightStyle>(
        items: WelcomeLightStyle.values,
        selectedItem: lamp.welcomeStyle,
        labelOf: (w) => w.label.split('(').first.trim(),
        onSelect: (w) => bloc.add(SelectWelcomeStyleEvent(w)),
      );
    }

    return NineColorWheel(
      size: 162,
      selectedColor: activeColor,
      onColorChanged: (c) {
        final hex = '#${c.toARGB32().toRadixString(16).substring(2)}';
        bloc.add(ChangeLampColorEvent(LedRgbColor.fromHex(hex)));
      },
    );
  }

  /// SLIDE 0: TEKS BERJALAN
  Widget _buildSlide0RunningText(BuildContext context, SmartLampStateEntity lamp) {
    final bloc = context.read<SmartLightingBloc>();
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SlideHeader(
            icon: Icons.text_fields_rounded,
            title: 'TEKS BERJALAN',
            subtitle: 'Atur pesan yang tampil di panel LED',
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  maxLength: 32,
                  textCapitalization: TextCapitalization.characters,
                  style: AppTextStyles.mono.copyWith(fontSize: 12.5, fontWeight: FontWeight.w700),
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: 'Ketik teks berjalan...',
                    filled: true,
                    fillColor: AppColors.surfaceMuted,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: AppRadius.squircleRadius,
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    bloc.add(UpdateRunningTextEvent(_textController.text));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textPrimary,
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.squircleRadius),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.send_rounded, size: 16),
                  label: Text('Kirim', style: AppTextStyles.button.copyWith(fontSize: 12)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('Preset Cepat', style: AppTextStyles.bodySmall),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: ['NINE AUTOSERIES', 'JAGA JARAK AMAN', 'KEEP DISTANCE', 'HATI-HATI REM']
                .map((preset) => ActionChip(
                      label: Text(preset, style: AppTextStyles.mono.copyWith(fontSize: 10.5)),
                      backgroundColor: AppColors.surfaceMuted,
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        _textController.text = preset;
                        bloc.add(UpdateRunningTextEvent(preset));
                      },
                    ))
                .toList(),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: NineLabeledSlider(
                  label: 'Kecepatan',
                  value: lamp.textSpeedMs.toDouble(),
                  min: 10,
                  max: 255,
                  unit: 'ms',
                  minLabel: 'Santai',
                  maxLabel: 'Cepat',
                  onChanged: (v) => bloc.add(UpdateTextSpeedEvent(v.round())),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMuted,
                    borderRadius: AppRadius.squircleRadius,
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Warna Teks', style: AppTextStyles.h3.copyWith(fontSize: 12)),
                          Text(
                            lamp.color.toHex(),
                            style: AppTextStyles.mono.copyWith(fontSize: 11, color: AppColors.primaryDark),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: _textColorSwatches.map((hex) {
                          final c = Color(LedRgbColor.fromHex(hex).toArgbInt());
                          final isSel = lamp.color.toHex() == hex;
                          return GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              bloc.add(ChangeLampColorEvent(LedRgbColor.fromHex(hex)));
                            },
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: c,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSel ? AppColors.textPrimary : Colors.black26,
                                  width: isSel ? 2.0 : 1.0,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// SLIDE 1: LAMPU SEIN & REM
  Widget _buildSlide1SignAndBrake(BuildContext context, SmartLampStateEntity lamp) {
    final bloc = context.read<SmartLightingBloc>();
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SlideHeader(
            icon: Icons.compare_arrows_rounded,
            title: 'LAMPU SEIN & REM',
            subtitle: 'Pilih gaya sinyal berkendara Anda',
            trailing: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => BlocProvider.value(
                      value: bloc,
                      child: const SensorOverrideScreen(),
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: AppRadius.pillRadius,
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.verified_user_outlined, size: 14, color: AppColors.textPrimary),
                    const SizedBox(width: 4),
                    Text('Sensor Aman', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: AppRadius.squircleRadius,
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Gaya Lampu Sein', style: AppTextStyles.h3.copyWith(fontSize: 12)),
                const SizedBox(height: 8),
                _StyleOptionGrid<SignLightStyle>(
                  items: SignLightStyle.values,
                  selectedItem: lamp.signStyle,
                  labelOf: (s) => s.label,
                  onSelect: (s) => bloc.add(SelectSignStyleEvent(s)),
                ),
                const SizedBox(height: 10),
                NineLabeledSlider(
                  label: 'Kecepatan Gerak Sein',
                  value: lamp.signSpeedMs.toDouble(),
                  min: 30,
                  max: 255,
                  unit: 'ms',
                  onChanged: (v) => bloc.add(UpdateSignSpeedEvent(v.round())),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: AppRadius.squircleRadius,
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Gaya Lampu Rem', style: AppTextStyles.h3.copyWith(fontSize: 12)),
                const SizedBox(height: 8),
                _StyleOptionGrid<BrakeLightStyle>(
                  items: BrakeLightStyle.values,
                  selectedItem: lamp.brakeStyle,
                  labelOf: (b) => b.label,
                  onSelect: (b) => bloc.add(SelectBrakeStyleEvent(b)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// SLIDE 2: WELCOME & LAMPU SENJA
  Widget _buildSlide2WelcomeAndSide(BuildContext context, SmartLampStateEntity lamp) {
    final bloc = context.read<SmartLightingBloc>();
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SlideHeader(
            icon: Icons.auto_awesome_rounded,
            title: 'WELCOME & LAMPU SENJA',
            subtitle: 'Efek saat kontak ON dan lampu kota',
          ),
          const SizedBox(height: 12),
          _SettingDropdownCard<WelcomeLightStyle>(
            title: 'Animasi Welcome',
            subtitle: 'Saat Kontak ON',
            value: lamp.welcomeStyle,
            items: WelcomeLightStyle.values,
            labelOf: (w) => w.label,
            onChanged: (val) => bloc.add(SelectWelcomeStyleEvent(val)),
          ),
          const SizedBox(height: 12),
          _SettingDropdownCard<SideLightStyle>(
            title: 'Lampu Senja / DRL',
            subtitle: 'Lampu Kota',
            value: lamp.sideStyle,
            items: SideLightStyle.values,
            labelOf: (s) => s.label,
            onChanged: (val) => bloc.add(SelectSideStyleEvent(val)),
          ),
        ],
      ),
    );
  }

  /// SLIDE 3: KECERAHAN & TRANSISI
  Widget _buildSlide3BrightnessAndTransition(BuildContext context, SmartLampStateEntity lamp) {
    final bloc = context.read<SmartLightingBloc>();
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SlideHeader(
            icon: Icons.wb_sunny_outlined,
            title: 'KECERAHAN & TRANSISI',
            subtitle: 'Sesuaikan intensitas cahaya dan animasi',
          ),
          const SizedBox(height: 12),
          NineLabeledSlider(
            label: 'Kecerahan Lampu',
            value: lamp.brightnessPercent.toDouble(),
            min: 4,
            max: 100,
            unit: '%',
            onChanged: (v) => bloc.add(ChangeLampBrightnessEvent(((v / 100.0) * 255).round())),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _BrightnessPresetChip(
                icon: Icons.wb_sunny_outlined,
                label: 'Siang 100%',
                onTap: () {
                  HapticFeedback.lightImpact();
                  bloc.add(const ChangeLampBrightnessEvent(255));
                },
              ),
              const SizedBox(width: 6),
              _BrightnessPresetChip(
                icon: Icons.cloud_outlined,
                label: 'Senja 63%',
                onTap: () {
                  HapticFeedback.lightImpact();
                  bloc.add(const ChangeLampBrightnessEvent(160));
                },
              ),
              const SizedBox(width: 6),
              _BrightnessPresetChip(
                icon: Icons.nights_stay_outlined,
                label: 'Malam 35%',
                onTap: () {
                  HapticFeedback.lightImpact();
                  bloc.add(const ChangeLampBrightnessEvent(90));
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          NineLabeledSlider(
            label: 'Kecepatan Transisi',
            value: lamp.transitionSpeedMs.toDouble(),
            min: 10,
            max: 255,
            unit: 'ms',
            onChanged: (v) => bloc.add(UpdateTransitionSpeedEvent(v.round())),
          ),
        ],
      ),
    );
  }
}

class _StagePresetGrid<T> extends StatelessWidget {
  final List<T> items;
  final T selectedItem;
  final String Function(T) labelOf;
  final ValueChanged<T> onSelect;

  const _StagePresetGrid({
    required this.items,
    required this.selectedItem,
    required this.labelOf,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 172,
      height: 156,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1.15,
        ),
        itemCount: items.length,
        itemBuilder: (_, idx) {
          final item = items[idx];
          final isSel = item == selectedItem;
          return GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              onSelect(item);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSel ? AppColors.primary : const Color.fromRGBO(20, 21, 25, 0.85),
                borderRadius: AppRadius.squircleRadius,
                border: Border.all(
                  color: isSel ? AppColors.primary : Colors.white.withAlpha(42),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                labelOf(item),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySmall.copyWith(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  color: isSel ? AppColors.textPrimary : Colors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StyleOptionGrid<T> extends StatelessWidget {
  final List<T> items;
  final T selectedItem;
  final String Function(T) labelOf;
  final ValueChanged<T> onSelect;

  const _StyleOptionGrid({
    required this.items,
    required this.selectedItem,
    required this.labelOf,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: items.map((item) {
        final sel = item == selectedItem;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                onSelect(item);
              },
              child: Container(
                height: 36,
                decoration: BoxDecoration(
                  color: sel ? AppColors.textPrimary : AppColors.surface,
                  borderRadius: AppRadius.mdRadius,
                  border: Border.all(color: sel ? AppColors.textPrimary : AppColors.borderSubtle),
                ),
                alignment: Alignment.center,
                child: Text(
                  labelOf(item),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: sel ? AppColors.primary : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _SettingDropdownCard<T> extends StatelessWidget {
  final String title;
  final String subtitle;
  final T value;
  final List<T> items;
  final String Function(T) labelOf;
  final ValueChanged<T> onChanged;

  const _SettingDropdownCard({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.items,
    required this.labelOf,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: AppRadius.squircleRadius,
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTextStyles.h3.copyWith(fontSize: 12)),
              Text(subtitle, style: AppTextStyles.bodySmall),
            ],
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<T>(
            initialValue: value,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: AppRadius.mdRadius,
                borderSide: const BorderSide(color: AppColors.borderSubtle),
              ),
            ),
            items: items
                .map((item) => DropdownMenuItem<T>(
                      value: item,
                      child: Text(labelOf(item), style: AppTextStyles.bodyMedium.copyWith(fontSize: 12)),
                    ))
                .toList(),
            onChanged: (val) {
              if (val != null) {
                HapticFeedback.lightImpact();
                onChanged(val);
              }
            },
          ),
        ],
      ),
    );
  }
}

class _SlideHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;

  const _SlideHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 15, color: AppColors.textPrimary),
                    const SizedBox(width: 6),
                    Text(title, style: AppTextStyles.h3.copyWith(fontSize: 12, letterSpacing: 0.6)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

class _BrightnessPresetChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _BrightnessPresetChip({
    required this.icon,
    required this.label,
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
            color: AppColors.surface,
            borderRadius: AppRadius.mdRadius,
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 13, color: AppColors.textPrimary),
              const SizedBox(width: 4),
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFFFAFAFB).withAlpha(32);
    const step = 16.0;
    for (double x = 0; x < size.width; x += step) {
      for (double y = 0; y < size.height; y += step) {
        canvas.drawCircle(Offset(x, y), 1.0, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
