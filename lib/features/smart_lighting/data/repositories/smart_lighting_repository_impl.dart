import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/led_device_entity.dart';
import '../../domain/entities/led_rgb_color.dart';
import '../../domain/entities/smart_lamp_state_entity.dart';
import '../../domain/repositories/i_smart_lighting_repository.dart';
import '../datasources/led_ble_datasource.dart';
import '../protocols/led_ble_protocol_encoder.dart';

class SmartLightingRepositoryImpl implements ISmartLightingRepository {
  final ILedBleDataSource bleDataSource;

  const SmartLightingRepositoryImpl(this.bleDataSource);

  @override
  Future<Either<Failure, List<LedDeviceEntity>>> scanDevices() async {
    try {
      final devices = await bleDataSource.scanDevices();
      return Either.right(devices);
    } catch (e) {
      return Either.left(
        const NetworkFailure('Gagal memindai perangkat Bluetooth LED. Pastikan Bluetooth aktif.'),
      );
    }
  }

  @override
  Future<Either<Failure, LedDeviceEntity>> connectDevice(String deviceId) async {
    try {
      final device = await bleDataSource.connectDevice(deviceId);
      return Either.right(device);
    } catch (e) {
      return Either.left(
        const ServerFailure('Perangkat Smart LED gagal tersambung. Dekatkan ponsel ke modul lampu.'),
      );
    }
  }

  @override
  Future<Either<Failure, String>> sendPower(LedDeviceEntity device, bool isOn) async {
    try {
      final packet = LedBleProtocolEncoder.encodePower(device, isOn);
      await bleDataSource.writePacket(device, packet);
      return Either.right(LedBleProtocolEncoder.toHexString(packet));
    } catch (_) {
      return Either.left(const ServerFailure('Gagal mengirim perintah daya ke Smart LED.'));
    }
  }

  @override
  Future<Either<Failure, String>> sendColor(
    LedDeviceEntity device,
    LedRgbColor color,
    int brightness,
  ) async {
    try {
      final packet = LedBleProtocolEncoder.encodeColor(device, color, brightness);
      await bleDataSource.writePacket(device, packet);
      return Either.right(LedBleProtocolEncoder.toHexString(packet));
    } catch (_) {
      return Either.left(const ServerFailure('Gagal mengubah warna pada modul Smart LED.'));
    }
  }

  @override
  Future<Either<Failure, String>> sendMode(
    LedDeviceEntity device,
    SmartLampMode mode,
  ) async {
    try {
      final packet = LedBleProtocolEncoder.encodeMode(device, mode);
      await bleDataSource.writePacket(device, packet);
      return Either.right(LedBleProtocolEncoder.toHexString(packet));
    } catch (_) {
      return Either.left(const ServerFailure('Gagal mengganti mode pencahayaan.'));
    }
  }

  @override
  Future<Either<Failure, String>> sendRunningText(
    LedDeviceEntity device,
    String text,
    int speedMs,
  ) async {
    try {
      final packet = LedBleProtocolEncoder.encodeRunningText(text, speedMs);
      await bleDataSource.writePacket(device, packet);
      return Either.right(LedBleProtocolEncoder.toHexString(packet));
    } catch (_) {
      return Either.left(const ServerFailure('Gagal mengirim teks berjalan ke panel LED.'));
    }
  }

  @override
  Future<Either<Failure, String>> sendSetting(
    LedDeviceEntity device,
    int settingId,
    int value,
  ) async {
    try {
      final packet = LedBleProtocolEncoder.encodeSetting(device, settingId, value);
      await bleDataSource.writePacket(device, packet);
      return Either.right(LedBleProtocolEncoder.toHexString(packet));
    } catch (_) {
      return Either.left(const ServerFailure('Gagal menyimpan pengaturan ke kontroler LED.'));
    }
  }

  @override
  Future<Either<Failure, String>> sendPinOrderCalibration(
    LedDeviceEntity device,
    RgbPinOrder pinOrder,
  ) async {
    try {
      // Send test RGB confirmation packet using newly calibrated pin order
      final calibratedDevice = device.copyWith(pinOrder: pinOrder);
      final packet = LedBleProtocolEncoder.encodeColor(
        calibratedDevice,
        const LedRgbColor(0x8D, 0xC6, 0x3F),
        255,
      );
      await bleDataSource.writePacket(calibratedDevice, packet);
      return Either.right(LedBleProtocolEncoder.toHexString(packet));
    } catch (_) {
      return Either.left(const ServerFailure('Gagal mengkalibrasi urutan kabel RGB.'));
    }
  }

  @override
  Future<Either<Failure, String>> sendIcChipConfig(
    LedDeviceEntity device,
    LedIcChipType chipType,
    int pixelCount,
  ) async {
    try {
      final packet = LedBleProtocolEncoder.encodeIcChipConfig(device, chipType, pixelCount);
      await bleDataSource.writePacket(device, packet);
      return Either.right(LedBleProtocolEncoder.toHexString(packet));
    } catch (_) {
      return Either.left(const ServerFailure('Gagal menyimpan konfigurasi IC Driver LED.'));
    }
  }
}
