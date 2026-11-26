import 'package:equatable/equatable.dart';
import '../../domain/entities/led_device_entity.dart';
import '../../domain/entities/smart_lamp_state_entity.dart';

class SmartLightingState extends Equatable {
  final SmartLampStateEntity lampState;
  final List<LedDeviceEntity> availableDevices;
  final bool isConnecting;
  final String? feedbackMessage;
  final String? errorMessage;

  const SmartLightingState({
    required this.lampState,
    this.availableDevices = const [],
    this.isConnecting = false,
    this.feedbackMessage,
    this.errorMessage,
  });

  factory SmartLightingState.initial() {
    const defaultDevice = LedDeviceEntity(
      id: 'NINE-LED-12093',
      name: 'Nine LED Matrix (NINE-LED-12093)',
      protocolType: LedProtocolType.manoTechMatrix,
      pinOrder: RgbPinOrder.rgb,
      isConnected: true,
      rssi: -46,
    );

    return const SmartLightingState(
      lampState: SmartLampStateEntity(activeDevice: defaultDevice),
      availableDevices: [defaultDevice],
    );
  }

  SmartLightingState copyWith({
    SmartLampStateEntity? lampState,
    List<LedDeviceEntity>? availableDevices,
    bool? isConnecting,
    String? feedbackMessage,
    bool clearFeedback = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SmartLightingState(
      lampState: lampState ?? this.lampState,
      availableDevices: availableDevices ?? this.availableDevices,
      isConnecting: isConnecting ?? this.isConnecting,
      feedbackMessage: clearFeedback ? null : (feedbackMessage ?? this.feedbackMessage),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        lampState,
        availableDevices,
        isConnecting,
        feedbackMessage,
        errorMessage,
      ];
}
