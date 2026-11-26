import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/led_device_entity.dart';
import '../entities/led_rgb_color.dart';
import '../repositories/i_smart_lighting_repository.dart';

class SendLedColorParams {
  final LedDeviceEntity device;
  final LedRgbColor color;
  final int brightness;

  const SendLedColorParams({
    required this.device,
    required this.color,
    required this.brightness,
  });
}

class SendLedColorUseCase implements UseCase<String, SendLedColorParams> {
  final ISmartLightingRepository repository;
  const SendLedColorUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(SendLedColorParams params) {
    return repository.sendColor(params.device, params.color, params.brightness);
  }
}
