import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/led_device_entity.dart';
import '../repositories/i_smart_lighting_repository.dart';

class ConnectLedDeviceUseCase implements UseCase<LedDeviceEntity, String> {
  final ISmartLightingRepository repository;
  const ConnectLedDeviceUseCase(this.repository);

  @override
  Future<Either<Failure, LedDeviceEntity>> call(String deviceId) {
    return repository.connectDevice(deviceId);
  }
}

class ScanLedDevicesUseCase implements UseCase<List<LedDeviceEntity>, NoParams> {
  final ISmartLightingRepository repository;
  const ScanLedDevicesUseCase(this.repository);

  @override
  Future<Either<Failure, List<LedDeviceEntity>>> call(NoParams params) {
    return repository.scanDevices();
  }
}
