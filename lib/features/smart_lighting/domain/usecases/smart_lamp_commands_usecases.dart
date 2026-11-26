import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/led_device_entity.dart';
import '../entities/smart_lamp_state_entity.dart';
import '../repositories/i_smart_lighting_repository.dart';

class SendLampPowerParams {
  final LedDeviceEntity device;
  final bool isOn;
  const SendLampPowerParams(this.device, this.isOn);
}

class SendLampPowerUseCase implements UseCase<String, SendLampPowerParams> {
  final ISmartLightingRepository repository;
  const SendLampPowerUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(SendLampPowerParams params) {
    return repository.sendPower(params.device, params.isOn);
  }
}

class SendLampModeParams {
  final LedDeviceEntity device;
  final SmartLampMode mode;
  const SendLampModeParams(this.device, this.mode);
}

class SendLampModeUseCase implements UseCase<String, SendLampModeParams> {
  final ISmartLightingRepository repository;
  const SendLampModeUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(SendLampModeParams params) {
    return repository.sendMode(params.device, params.mode);
  }
}

class SendRunningTextParams {
  final LedDeviceEntity device;
  final String text;
  final int speedMs;
  const SendRunningTextParams(this.device, this.text, this.speedMs);
}

class SendRunningTextUseCase implements UseCase<String, SendRunningTextParams> {
  final ISmartLightingRepository repository;
  const SendRunningTextUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(SendRunningTextParams params) {
    if (params.text.trim().isEmpty) {
      return Future.value(Either.left(const ValidationFailure('Teks tampilan tidak boleh kosong.')));
    }
    return repository.sendRunningText(params.device, params.text, params.speedMs);
  }
}

class SendLampSettingParams {
  final LedDeviceEntity device;
  final int settingId;
  final int value;
  const SendLampSettingParams(this.device, this.settingId, this.value);
}

class SendLampSettingUseCase implements UseCase<String, SendLampSettingParams> {
  final ISmartLightingRepository repository;
  const SendLampSettingUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(SendLampSettingParams params) {
    return repository.sendSetting(params.device, params.settingId, params.value);
  }
}
