import 'package:equatable/equatable.dart';
import 'led_device_entity.dart';
import 'led_rgb_color.dart';

enum SmartLampMode {
  runningText('Running Text', 'ST,7', 'Teks berjalan pada panel LED'),
  dynamicSign('Sein Dinamis', 'ST,1', 'Cahaya mengalir saat berbelok'),
  brakeStrobe('Rem Strobo', 'ST,2', 'Kedipan cepat saat pedal rem'),
  welcomeLight('Welcome Light', 'ST,3', 'Efek sambutan saat kontak ON'),
  sideLed('Side LED', 'ST,4', 'Lampu aksen tepi senja & malam'),
  solidColor('Warna Solid', 'ST,5', 'Satu warna menyala stabil');

  final String label;
  final String protocolCode;
  final String description;
  const SmartLampMode(this.label, this.protocolCode, this.description);
}

enum SignLightStyle {
  arrow(1, '1. Panah'),
  block(2, '2. Balok'),
  blink(3, '3. Kedip'),
  wave(4, '4. Wave');

  final int id;
  final String label;
  const SignLightStyle(this.id, this.label);
}

enum BrakeLightStyle {
  f1Strobe(1, '1. F1 Strobo'),
  tripleBlink(2, '2. Kedip 3x'),
  pulsing(3, '3. Pulsing'),
  solid(4, '4. Solid');

  final int id;
  final String label;
  const BrakeLightStyle(this.id, this.label);
}

enum WelcomeLightStyle {
  knightRider(1, '1. Knight Rider (Scanning Aura)'),
  centerSplit(2, '2. Center Split (Mekar Tengah)'),
  cyberRainbow(3, '3. Cyber Rainbow (Spectrum Warna)'),
  sunriseFade(4, '4. Sunrise Fade (Denyut Halus)');

  final int id;
  final String label;
  const WelcomeLightStyle(this.id, this.label);
}

enum SideLightStyle {
  deepRed(1, '1. Merah Pekat Standar'),
  softPulse(2, '2. Denyut Halus'),
  smoothGradient(3, '3. Gradasi Halus'),
  brightWhiteDrl(4, '4. Putih Terang DRL');

  final int id;
  final String label;
  const SideLightStyle(this.id, this.label);
}

class SmartLampStateEntity extends Equatable {
  final LedDeviceEntity activeDevice;
  final bool isPowerOn;
  final SmartLampMode activeMode;
  final LedRgbColor color;
  final int brightness; // 0..255
  final String runningText;
  final int textSpeedMs; // 10..255
  final SignLightStyle signStyle;
  final int signSpeedMs; // 30..255
  final BrakeLightStyle brakeStyle;
  final WelcomeLightStyle welcomeStyle;
  final SideLightStyle sideStyle;
  final int transitionSpeedMs; // 10..255
  final bool brakeOverrideLocked;
  final bool turnOverrideEnabled;
  final String lastHexFrameSent;

  const SmartLampStateEntity({
    required this.activeDevice,
    this.isPowerOn = true,
    this.activeMode = SmartLampMode.runningText,
    this.color = const LedRgbColor(0x8D, 0xC6, 0x3F),
    this.brightness = 217, // ~85%
    this.runningText = 'NINE AUTOSERIES',
    this.textSpeedMs = 140,
    this.signStyle = SignLightStyle.arrow,
    this.signSpeedMs = 120,
    this.brakeStyle = BrakeLightStyle.f1Strobe,
    this.welcomeStyle = WelcomeLightStyle.knightRider,
    this.sideStyle = SideLightStyle.deepRed,
    this.transitionSpeedMs = 120,
    this.brakeOverrideLocked = true,
    this.turnOverrideEnabled = true,
    this.lastHexFrameSent = '7E FF 04 01 00 FF FF 00 EF',
  });

  int get brightnessPercent => ((brightness / 255.0) * 100).round().clamp(0, 100);

  SmartLampStateEntity copyWith({
    LedDeviceEntity? activeDevice,
    bool? isPowerOn,
    SmartLampMode? activeMode,
    LedRgbColor? color,
    int? brightness,
    String? runningText,
    int? textSpeedMs,
    SignLightStyle? signStyle,
    int? signSpeedMs,
    BrakeLightStyle? brakeStyle,
    WelcomeLightStyle? welcomeStyle,
    SideLightStyle? sideStyle,
    int? transitionSpeedMs,
    bool? brakeOverrideLocked,
    bool? turnOverrideEnabled,
    String? lastHexFrameSent,
  }) {
    return SmartLampStateEntity(
      activeDevice: activeDevice ?? this.activeDevice,
      isPowerOn: isPowerOn ?? this.isPowerOn,
      activeMode: activeMode ?? this.activeMode,
      color: color ?? this.color,
      brightness: brightness ?? this.brightness,
      runningText: runningText ?? this.runningText,
      textSpeedMs: textSpeedMs ?? this.textSpeedMs,
      signStyle: signStyle ?? this.signStyle,
      signSpeedMs: signSpeedMs ?? this.signSpeedMs,
      brakeStyle: brakeStyle ?? this.brakeStyle,
      welcomeStyle: welcomeStyle ?? this.welcomeStyle,
      sideStyle: sideStyle ?? this.sideStyle,
      transitionSpeedMs: transitionSpeedMs ?? this.transitionSpeedMs,
      brakeOverrideLocked: brakeOverrideLocked ?? this.brakeOverrideLocked,
      turnOverrideEnabled: turnOverrideEnabled ?? this.turnOverrideEnabled,
      lastHexFrameSent: lastHexFrameSent ?? this.lastHexFrameSent,
    );
  }

  @override
  List<Object?> get props => [
        activeDevice,
        isPowerOn,
        activeMode,
        color,
        brightness,
        runningText,
        textSpeedMs,
        signStyle,
        signSpeedMs,
        brakeStyle,
        welcomeStyle,
        sideStyle,
        transitionSpeedMs,
        brakeOverrideLocked,
        turnOverrideEnabled,
        lastHexFrameSent,
      ];
}
