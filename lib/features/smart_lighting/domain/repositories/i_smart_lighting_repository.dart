import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/led_device_entity.dart';
import '../entities/led_rgb_color.dart';
import '../entities/smart_lamp_state_entity.dart';

abstract class ISmartLightingRepository {
  Future<Either<Failure, List<LedDeviceEntity>>> scanDevices();
  Future<Either<Failure, LedDeviceEntity>> connectDevice(String deviceId);
  Future<Either<Failure, String>> sendPower(LedDeviceEntity device, bool isOn);
  Future<Either<Failure, String>> sendColor(
    LedDeviceEntity device,
    LedRgbColor color,
    int brightness,
  );
  Future<Either<Failure, String>> sendMode(
    LedDeviceEntity device,
    SmartLampMode mode,
  );
  Future<Either<Failure, String>> sendRunningText(
    LedDeviceEntity device,
    String text,
    int speedMs,
  );
  Future<Either<Failure, String>> sendSetting(
    LedDeviceEntity device,
    int settingId,
    int value,
  );
  Future<Either<Failure, String>> sendPinOrderCalibration(
    LedDeviceEntity device,
    RgbPinOrder pinOrder,
  );
  Future<Either<Failure, String>> sendIcChipConfig(
    LedDeviceEntity device,
    LedIcChipType chipType,
    int pixelCount,
  );
}
