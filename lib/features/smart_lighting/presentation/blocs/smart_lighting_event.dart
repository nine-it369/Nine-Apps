import 'package:equatable/equatable.dart';
import '../../domain/entities/led_device_entity.dart';
import '../../domain/entities/led_rgb_color.dart';
import '../../domain/entities/smart_lamp_state_entity.dart';

abstract class SmartLightingEvent extends Equatable {
  const SmartLightingEvent();
  @override
  List<Object?> get props => [];
}

class InitSmartLightingEvent extends SmartLightingEvent {
  const InitSmartLightingEvent();
}

class ConnectLedDeviceEvent extends SmartLightingEvent {
  final String deviceId;
  const ConnectLedDeviceEvent(this.deviceId);
  @override
  List<Object?> get props => [deviceId];
}

class ToggleLampPowerEvent extends SmartLightingEvent {
  const ToggleLampPowerEvent();
}

class ChangeLampColorEvent extends SmartLightingEvent {
  final LedRgbColor color;
  const ChangeLampColorEvent(this.color);
  @override
  List<Object?> get props => [color];
}

class ChangeLampBrightnessEvent extends SmartLightingEvent {
  final int brightness; // 0..255
  const ChangeLampBrightnessEvent(this.brightness);
  @override
  List<Object?> get props => [brightness];
}

class SelectLampModeEvent extends SmartLightingEvent {
  final SmartLampMode mode;
  const SelectLampModeEvent(this.mode);
  @override
  List<Object?> get props => [mode];
}

class UpdateRunningTextEvent extends SmartLightingEvent {
  final String text;
  final int? speedMs;
  const UpdateRunningTextEvent(this.text, {this.speedMs});
  @override
  List<Object?> get props => [text, speedMs];
}

class UpdateTextSpeedEvent extends SmartLightingEvent {
  final int speedMs;
  const UpdateTextSpeedEvent(this.speedMs);
  @override
  List<Object?> get props => [speedMs];
}

class SelectSignStyleEvent extends SmartLightingEvent {
  final SignLightStyle style;
  const SelectSignStyleEvent(this.style);
  @override
  List<Object?> get props => [style];
}

class UpdateSignSpeedEvent extends SmartLightingEvent {
  final int speedMs;
  const UpdateSignSpeedEvent(this.speedMs);
  @override
  List<Object?> get props => [speedMs];
}

class SelectBrakeStyleEvent extends SmartLightingEvent {
  final BrakeLightStyle style;
  const SelectBrakeStyleEvent(this.style);
  @override
  List<Object?> get props => [style];
}

class SelectWelcomeStyleEvent extends SmartLightingEvent {
  final WelcomeLightStyle style;
  const SelectWelcomeStyleEvent(this.style);
  @override
  List<Object?> get props => [style];
}

class SelectSideStyleEvent extends SmartLightingEvent {
  final SideLightStyle style;
  const SelectSideStyleEvent(this.style);
  @override
  List<Object?> get props => [style];
}

class UpdateTransitionSpeedEvent extends SmartLightingEvent {
  final int speedMs;
  const UpdateTransitionSpeedEvent(this.speedMs);
  @override
  List<Object?> get props => [speedMs];
}

class UpdateRgbPinOrderEvent extends SmartLightingEvent {
  final RgbPinOrder pinOrder;
  const UpdateRgbPinOrderEvent(this.pinOrder);
  @override
  List<Object?> get props => [pinOrder];
}

class ToggleTurnSafetyOverrideEvent extends SmartLightingEvent {
  final bool enabled;
  const ToggleTurnSafetyOverrideEvent(this.enabled);
  @override
  List<Object?> get props => [enabled];
}

class UpdateIcChipConfigEvent extends SmartLightingEvent {
  final LedIcChipType chipType;
  final int pixelCount;
  const UpdateIcChipConfigEvent(this.chipType, this.pixelCount);
  @override
  List<Object?> get props => [chipType, pixelCount];
}
