import 'dart:convert';
import '../../domain/entities/led_device_entity.dart';
import '../../domain/entities/led_rgb_color.dart';
import '../../domain/entities/smart_lamp_state_entity.dart';

/// Binary BLE GATT Packet Encoder & Decoder derived from pedoman_Apps
/// Supports:
/// 1. HappyLighting (Triones / QingHang 0x56 / 0x78 / 0xCC)
/// 2. LED LAMP Car02 (0x7E..0xEF & 0x7B..0xBF)
/// 3. Nine LED Matrix / ManoTech (ST,x & SET,id,val)
class LedBleProtocolEncoder {
  LedBleProtocolEncoder._();

  // Official GATT UUIDs extracted from pedoman_Apps
  static const String trionesWriteServiceUuid = '0000ffd5-0000-1000-8000-00805f9b34fb';
  static const String trionesWriteCharUuid = '0000ffd9-0000-1000-8000-00805f9b34fb';
  static const String trionesNotifyServiceUuid = '0000ffd0-0000-1000-8000-00805f9b34fb';
  static const String trionesNotifyCharUuid = '0000ffd4-0000-1000-8000-00805f9b34fb';

  static const String ledLampServiceUuid = '0000ffe0-0000-1000-8000-00805f9b34fb';
  static const String ledLampCharUuid = '0000ffe1-0000-1000-8000-00805f9b34fb';

  /// Remap RGB color channels based on hardware pin sort calibration (RgbSortActivity)
  static List<int> applyPinOrder(LedRgbColor color, RgbPinOrder order) {
    final r = color.r.clamp(0, 255);
    final g = color.g.clamp(0, 255);
    final b = color.b.clamp(0, 255);

    switch (order) {
      case RgbPinOrder.rgb:
        return [r, g, b];
      case RgbPinOrder.rbg:
        return [r, b, g];
      case RgbPinOrder.grb:
        return [g, r, b];
      case RgbPinOrder.gbr:
        return [g, b, r];
      case RgbPinOrder.brg:
        return [b, r, g];
      case RgbPinOrder.bgr:
        return [b, g, r];
    }
  }

  /// Power command packet
  static List<int> encodePower(LedDeviceEntity device, bool isOn) {
    switch (device.protocolType) {
      case LedProtocolType.happyLightingTriones:
        return [0xCC, isOn ? 0x23 : 0x24, 0x33];
      case LedProtocolType.ledLampCar02:
        return [0x7E, 0xFF, 0x04, isOn ? 0x01 : 0x00, 0x00, 0xFF, 0xFF, 0x00, 0xEF];
      case LedProtocolType.manoTechMatrix:
        return utf8.encode(isOn ? 'ST,PWR,1' : 'ST,PWR,0');
    }
  }

  /// Color & Brightness command packet
  static List<int> encodeColor(
    LedDeviceEntity device,
    LedRgbColor color,
    int brightness,
  ) {
    final mapped = applyPinOrder(color, device.pinOrder);
    final c1 = mapped[0];
    final c2 = mapped[1];
    final c3 = mapped[2];
    final brightScaled = ((brightness.clamp(0, 255) / 255.0) * 19).round();

    switch (device.protocolType) {
      case LedProtocolType.happyLightingTriones:
        // If full brightness or default, send standard 0x56 Triones frame; otherwise 0x78 frame
        if (brightness >= 250) {
          return [0x56, c1, c2, c3, 0x00, 0xF0, 0xAA];
        }
        return [0x78, c1, c2, c3, brightScaled | 0x80, 0xF0, 0xEE];
      case LedProtocolType.ledLampCar02:
        // Standard LEDBLE / LEDCAR 0x7E..0xEF frame
        return [0x7E, 0xFF, 0x05, 0x03, c1, c2, c3, 0xFF, 0xEF];
      case LedProtocolType.manoTechMatrix:
        // Combine 0x7E..0xEF RGB + brightness scaling
        final factor = brightness.clamp(0, 255) / 255.0;
        return [
          0x7E,
          0xFF,
          0x05,
          0x03,
          (c1 * factor).round(),
          (c2 * factor).round(),
          (c3 * factor).round(),
          0xFF,
          0xEF,
        ];
    }
  }

  /// Mode command packet (ST,1..7 or LEDCAR mode frame)
  static List<int> encodeMode(LedDeviceEntity device, SmartLampMode mode) {
    switch (device.protocolType) {
      case LedProtocolType.manoTechMatrix:
        return utf8.encode(mode.protocolCode);
      case LedProtocolType.ledLampCar02:
        final modeByte = mode.index + 0x25;
        return [0x7E, 0xFF, 0x03, modeByte, 0x03, 0xFF, 0xFF, 0x00, 0xEF];
      case LedProtocolType.happyLightingTriones:
        final modeByte = 0x25 + mode.index;
        return [0xBB, modeByte, 0x10, 0x44];
    }
  }

  /// Setting packet (e.g. settingId: 1=Sign, 2=Brake, 3=Welcome, 4=Side, 8=Duration, 9=TextSpeed, 10=SignSpeed, 11=Brightness)
  static List<int> encodeSetting(LedDeviceEntity device, int settingId, int value) {
    final clampedVal = value.clamp(0, 255);
    switch (device.protocolType) {
      case LedProtocolType.manoTechMatrix:
        return utf8.encode('SET,$settingId,$clampedVal');
      case LedProtocolType.ledLampCar02:
        return [0x7E, 0xFF, 0x04, settingId & 0xFF, clampedVal, 0xFF, 0xFF, 0x00, 0xEF];
      case LedProtocolType.happyLightingTriones:
        return [0xBB, settingId & 0xFF, clampedVal, 0x44];
    }
  }

  /// Running text packet (max 32 chars)
  static List<int> encodeRunningText(String text, int speedMs) {
    final clean = text.trim().toUpperCase();
    final truncated = clean.length > 32 ? clean.substring(0, 32) : clean;
    return utf8.encode('TXT,$truncated,${speedMs.clamp(10, 255)}');
  }

  /// Encode 7x4 (28-pixel) DIY Matrix grid state from pedoman_Apps NINE_TL (CB1..CB28 checkboxes)
  static List<int> encodeNineMatrixGrid(List<bool> pixels28) {
    final safePixels = List<bool>.from(pixels28);
    while (safePixels.length < 28) {
      safePixels.add(false);
    }
    final bitString = safePixels.take(28).map((p) => p ? '1' : '0').join();
    return utf8.encode('GRID,$bitString');
  }

  /// IC Chip driver & pixel count configuration packet (ChipSelectActivity)
  static List<int> encodeIcChipConfig(
    LedDeviceEntity device,
    LedIcChipType chipType,
    int pixelCount,
  ) {
    final safePixels = pixelCount.clamp(8, 300);
    switch (device.protocolType) {
      case LedProtocolType.manoTechMatrix:
        return utf8.encode('CHIP,${chipType.label},$safePixels');
      case LedProtocolType.ledLampCar02:
      case LedProtocolType.happyLightingTriones:
        return [
          0x7E,
          0xFF,
          0x06,
          chipType.index & 0xFF,
          (safePixels >> 8) & 0xFF,
          safePixels & 0xFF,
          0xFF,
          0x00,
          0xEF,
        ];
    }
  }

  /// Convert byte frame to formatted uppercase HEX telemetry string (e.g. "7E FF 05 03 8D C6 3F FF EF")
  static String toHexString(List<int> bytes) {
    return bytes.map((b) => (b & 0xFF).toRadixString(16).padLeft(2, '0').toUpperCase()).join(' ');
  }

  /// Parse HEX string back into raw bytes (for Unit Testing SOP 3.1)
  static List<int> parseHexTelemetry(String hexString) {
    final tokens = hexString.trim().split(RegExp(r'\s+')).where((t) => t.isNotEmpty);
    return tokens.map((token) {
      final parsed = int.tryParse(token, radix: 16);
      if (parsed == null || parsed < 0 || parsed > 255) {
        throw FormatException('Invalid HEX telemetry byte: $token');
      }
      return parsed;
    }).toList();
  }
}
