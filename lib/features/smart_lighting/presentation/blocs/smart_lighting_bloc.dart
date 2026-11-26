import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/repositories/i_smart_lighting_repository.dart';
import '../../domain/usecases/connect_led_device_usecase.dart';
import '../../domain/usecases/send_led_color_usecase.dart';
import '../../domain/usecases/smart_lamp_commands_usecases.dart';
import 'smart_lighting_event.dart';
import 'smart_lighting_state.dart';

class SmartLightingBloc extends Bloc<SmartLightingEvent, SmartLightingState> {
  final ScanLedDevicesUseCase scanDevicesUseCase;
  final ConnectLedDeviceUseCase connectDeviceUseCase;
  final SendLampPowerUseCase sendPowerUseCase;
  final SendLedColorUseCase sendColorUseCase;
  final SendLampModeUseCase sendModeUseCase;
  final SendRunningTextUseCase sendRunningTextUseCase;
  final SendLampSettingUseCase sendSettingUseCase;
  final ISmartLightingRepository repository;

  SmartLightingBloc({
    required this.scanDevicesUseCase,
    required this.connectDeviceUseCase,
    required this.sendPowerUseCase,
    required this.sendColorUseCase,
    required this.sendModeUseCase,
    required this.sendRunningTextUseCase,
    required this.sendSettingUseCase,
    required this.repository,
  }) : super(SmartLightingState.initial()) {
    on<InitSmartLightingEvent>(_onInit);
    on<ConnectLedDeviceEvent>(_onConnectDevice);
    on<ToggleLampPowerEvent>(_onTogglePower);
    on<ChangeLampColorEvent>(_onChangeColor);
    on<ChangeLampBrightnessEvent>(_onChangeBrightness);
    on<SelectLampModeEvent>(_onSelectMode);
    on<UpdateRunningTextEvent>(_onUpdateRunningText);
    on<UpdateTextSpeedEvent>(_onUpdateTextSpeed);
    on<SelectSignStyleEvent>(_onSelectSignStyle);
    on<UpdateSignSpeedEvent>(_onUpdateSignSpeed);
    on<SelectBrakeStyleEvent>(_onSelectBrakeStyle);
    on<SelectWelcomeStyleEvent>(_onSelectWelcomeStyle);
    on<SelectSideStyleEvent>(_onSelectSideStyle);
    on<UpdateTransitionSpeedEvent>(_onUpdateTransitionSpeed);
    on<UpdateRgbPinOrderEvent>(_onUpdatePinOrder);
    on<ToggleTurnSafetyOverrideEvent>(_onToggleTurnSafety);
    on<UpdateIcChipConfigEvent>(_onUpdateIcChipConfig);
  }

  Future<void> _onInit(InitSmartLightingEvent event, Emitter<SmartLightingState> emit) async {
    emit(state.copyWith(isConnecting: true, clearError: true, clearFeedback: true));
    final result = await scanDevicesUseCase(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(isConnecting: false, errorMessage: failure.message)),
      (devices) {
        final active = devices.firstWhere(
          (d) => d.isConnected,
          orElse: () => devices.first,
        );
        emit(state.copyWith(
          isConnecting: false,
          availableDevices: devices,
          lampState: state.lampState.copyWith(activeDevice: active),
        ));
      },
    );
  }

  Future<void> _onConnectDevice(
    ConnectLedDeviceEvent event,
    Emitter<SmartLightingState> emit,
  ) async {
    emit(state.copyWith(isConnecting: true, clearError: true, clearFeedback: true));
    final result = await connectDeviceUseCase(event.deviceId);
    result.fold(
      (failure) => emit(state.copyWith(isConnecting: false, errorMessage: failure.message)),
      (device) => emit(state.copyWith(
        isConnecting: false,
        lampState: state.lampState.copyWith(activeDevice: device),
        feedbackMessage: 'Terhubung ke ${device.name}',
      )),
    );
  }

  Future<void> _onTogglePower(
    ToggleLampPowerEvent event,
    Emitter<SmartLightingState> emit,
  ) async {
    final nextPower = !state.lampState.isPowerOn;
    final res = await sendPowerUseCase(
      SendLampPowerParams(state.lampState.activeDevice, nextPower),
    );
    res.fold(
      (f) => emit(state.copyWith(errorMessage: f.message)),
      (hex) => emit(state.copyWith(
        lampState: state.lampState.copyWith(isPowerOn: nextPower, lastHexFrameSent: hex),
        feedbackMessage: nextPower ? 'Smart Lamp dinyalakan' : 'Smart Lamp dimatikan',
      )),
    );
  }

  Future<void> _onChangeColor(
    ChangeLampColorEvent event,
    Emitter<SmartLightingState> emit,
  ) async {
    final res = await sendColorUseCase(
      SendLedColorParams(
        device: state.lampState.activeDevice,
        color: event.color,
        brightness: state.lampState.brightness,
      ),
    );
    res.fold(
      (f) => emit(state.copyWith(errorMessage: f.message)),
      (hex) => emit(state.copyWith(
        lampState: state.lampState.copyWith(color: event.color, lastHexFrameSent: hex),
        clearFeedback: true,
      )),
    );
  }

  Future<void> _onChangeBrightness(
    ChangeLampBrightnessEvent event,
    Emitter<SmartLightingState> emit,
  ) async {
    final clamped = event.brightness.clamp(10, 255);
    final res = await sendSettingUseCase(
      SendLampSettingParams(state.lampState.activeDevice, 11, clamped),
    );
    res.fold(
      (f) => emit(state.copyWith(errorMessage: f.message)),
      (hex) => emit(state.copyWith(
        lampState: state.lampState.copyWith(brightness: clamped, lastHexFrameSent: hex),
        clearFeedback: true,
      )),
    );
  }

  Future<void> _onSelectMode(
    SelectLampModeEvent event,
    Emitter<SmartLightingState> emit,
  ) async {
    final res = await sendModeUseCase(
      SendLampModeParams(state.lampState.activeDevice, event.mode),
    );
    res.fold(
      (f) => emit(state.copyWith(errorMessage: f.message)),
      (hex) => emit(state.copyWith(
        lampState: state.lampState.copyWith(activeMode: event.mode, lastHexFrameSent: hex),
        feedbackMessage: 'Mode Lampu: ${event.mode.label}',
      )),
    );
  }

  Future<void> _onUpdateRunningText(
    UpdateRunningTextEvent event,
    Emitter<SmartLightingState> emit,
  ) async {
    final clean = event.text.trim().toUpperCase();
    final speed = event.speedMs ?? state.lampState.textSpeedMs;
    final res = await sendRunningTextUseCase(
      SendRunningTextParams(state.lampState.activeDevice, clean, speed),
    );
    res.fold(
      (f) => emit(state.copyWith(errorMessage: f.message)),
      (hex) => emit(state.copyWith(
        lampState: state.lampState.copyWith(
          runningText: clean.length > 32 ? clean.substring(0, 32) : clean,
          textSpeedMs: speed,
          lastHexFrameSent: hex,
        ),
        feedbackMessage: 'Teks dikirim: $clean',
      )),
    );
  }

  Future<void> _onUpdateTextSpeed(
    UpdateTextSpeedEvent event,
    Emitter<SmartLightingState> emit,
  ) async {
    final clamped = event.speedMs.clamp(10, 255);
    final res = await sendSettingUseCase(
      SendLampSettingParams(state.lampState.activeDevice, 9, clamped),
    );
    res.fold(
      (f) => emit(state.copyWith(errorMessage: f.message)),
      (hex) => emit(state.copyWith(
        lampState: state.lampState.copyWith(textSpeedMs: clamped, lastHexFrameSent: hex),
        clearFeedback: true,
      )),
    );
  }

  Future<void> _onSelectSignStyle(
    SelectSignStyleEvent event,
    Emitter<SmartLightingState> emit,
  ) async {
    final res = await sendSettingUseCase(
      SendLampSettingParams(state.lampState.activeDevice, 1, event.style.id),
    );
    res.fold(
      (f) => emit(state.copyWith(errorMessage: f.message)),
      (hex) => emit(state.copyWith(
        lampState: state.lampState.copyWith(signStyle: event.style, lastHexFrameSent: hex),
        feedbackMessage: 'Gaya Sein: ${event.style.label}',
      )),
    );
  }

  Future<void> _onUpdateSignSpeed(
    UpdateSignSpeedEvent event,
    Emitter<SmartLightingState> emit,
  ) async {
    final clamped = event.speedMs.clamp(30, 255);
    final res = await sendSettingUseCase(
      SendLampSettingParams(state.lampState.activeDevice, 10, clamped),
    );
    res.fold(
      (f) => emit(state.copyWith(errorMessage: f.message)),
      (hex) => emit(state.copyWith(
        lampState: state.lampState.copyWith(signSpeedMs: clamped, lastHexFrameSent: hex),
        clearFeedback: true,
      )),
    );
  }

  Future<void> _onSelectBrakeStyle(
    SelectBrakeStyleEvent event,
    Emitter<SmartLightingState> emit,
  ) async {
    final res = await sendSettingUseCase(
      SendLampSettingParams(state.lampState.activeDevice, 2, event.style.id),
    );
    res.fold(
      (f) => emit(state.copyWith(errorMessage: f.message)),
      (hex) => emit(state.copyWith(
        lampState: state.lampState.copyWith(brakeStyle: event.style, lastHexFrameSent: hex),
        feedbackMessage: 'Gaya Rem: ${event.style.label}',
      )),
    );
  }

  Future<void> _onSelectWelcomeStyle(
    SelectWelcomeStyleEvent event,
    Emitter<SmartLightingState> emit,
  ) async {
    final res = await sendSettingUseCase(
      SendLampSettingParams(state.lampState.activeDevice, 3, event.style.id),
    );
    res.fold(
      (f) => emit(state.copyWith(errorMessage: f.message)),
      (hex) => emit(state.copyWith(
        lampState: state.lampState.copyWith(welcomeStyle: event.style, lastHexFrameSent: hex),
        feedbackMessage: 'Animasi Welcome: ${event.style.label}',
      )),
    );
  }

  Future<void> _onSelectSideStyle(
    SelectSideStyleEvent event,
    Emitter<SmartLightingState> emit,
  ) async {
    final res = await sendSettingUseCase(
      SendLampSettingParams(state.lampState.activeDevice, 4, event.style.id),
    );
    res.fold(
      (f) => emit(state.copyWith(errorMessage: f.message)),
      (hex) => emit(state.copyWith(
        lampState: state.lampState.copyWith(sideStyle: event.style, lastHexFrameSent: hex),
        feedbackMessage: 'Lampu Senja: ${event.style.label}',
      )),
    );
  }

  Future<void> _onUpdateTransitionSpeed(
    UpdateTransitionSpeedEvent event,
    Emitter<SmartLightingState> emit,
  ) async {
    final clamped = event.speedMs.clamp(10, 255);
    final res = await sendSettingUseCase(
      SendLampSettingParams(state.lampState.activeDevice, 8, clamped),
    );
    res.fold(
      (f) => emit(state.copyWith(errorMessage: f.message)),
      (hex) => emit(state.copyWith(
        lampState: state.lampState.copyWith(transitionSpeedMs: clamped, lastHexFrameSent: hex),
        clearFeedback: true,
      )),
    );
  }

  Future<void> _onUpdatePinOrder(
    UpdateRgbPinOrderEvent event,
    Emitter<SmartLightingState> emit,
  ) async {
    final res = await repository.sendPinOrderCalibration(
      state.lampState.activeDevice,
      event.pinOrder,
    );
    res.fold(
      (f) => emit(state.copyWith(errorMessage: f.message)),
      (hex) {
        final updatedDevice = state.lampState.activeDevice.copyWith(pinOrder: event.pinOrder);
        emit(state.copyWith(
          lampState: state.lampState.copyWith(
            activeDevice: updatedDevice,
            lastHexFrameSent: hex,
          ),
          feedbackMessage: 'Kalibrasi Pin Kabel: ${event.pinOrder.label}',
        ));
      },
    );
  }

  Future<void> _onToggleTurnSafety(
    ToggleTurnSafetyOverrideEvent event,
    Emitter<SmartLightingState> emit,
  ) async {
    emit(state.copyWith(
      lampState: state.lampState.copyWith(turnOverrideEnabled: event.enabled),
      feedbackMessage: 'Konfigurasi Sensor Override Terverifikasi!',
    ));
  }

  Future<void> _onUpdateIcChipConfig(
    UpdateIcChipConfigEvent event,
    Emitter<SmartLightingState> emit,
  ) async {
    final res = await repository.sendIcChipConfig(
      state.lampState.activeDevice,
      event.chipType,
      event.pixelCount,
    );
    res.fold(
      (f) => emit(state.copyWith(errorMessage: f.message)),
      (hex) {
        final updatedDevice = state.lampState.activeDevice.copyWith(
          icChipType: event.chipType,
          pixelCount: event.pixelCount.clamp(8, 300),
        );
        emit(state.copyWith(
          lampState: state.lampState.copyWith(
            activeDevice: updatedDevice,
            lastHexFrameSent: hex,
          ),
          feedbackMessage: 'IC Chip: ${event.chipType.label} (${updatedDevice.pixelCount} piksel)',
        ));
      },
    );
  }
}
