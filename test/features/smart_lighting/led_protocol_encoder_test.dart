import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:nine_apps/features/smart_lighting/data/datasources/led_ble_datasource.dart';
import 'package:nine_apps/features/smart_lighting/data/protocols/led_ble_protocol_encoder.dart';
import 'package:nine_apps/features/smart_lighting/data/repositories/smart_lighting_repository_impl.dart';
import 'package:nine_apps/features/smart_lighting/domain/entities/led_device_entity.dart';
import 'package:nine_apps/features/smart_lighting/domain/entities/led_rgb_color.dart';
import 'package:nine_apps/features/smart_lighting/domain/entities/smart_lamp_state_entity.dart';

class _FailingBleDataSource implements ILedBleDataSource {
  @override
  Future<LedDeviceEntity> connectDevice(String deviceId) => throw Exception('GATT timeout');

  @override
  Future<List<LedDeviceEntity>> scanDevices() => throw Exception('Bluetooth off');

  @override
  Future<void> writePacket(LedDeviceEntity device, List<int> packet) =>
      throw Exception('Write characteristic failed');
}

void main() {
  group('LedBleProtocolEncoder - pedoman_Apps GATT Binary Tests', () {
    const trionesDevice = LedDeviceEntity(
      id: 'Triones-01',
      name: 'HappyLighting Ambient',
      protocolType: LedProtocolType.happyLightingTriones,
      pinOrder: RgbPinOrder.rgb,
    );

    const ledCarDevice = LedDeviceEntity(
      id: 'LEDCAR-02-8812',
      name: 'LEDCAR-02 Demon Eye',
      protocolType: LedProtocolType.ledLampCar02,
      pinOrder: RgbPinOrder.rgb,
    );

    const matrixDevice = LedDeviceEntity(
      id: 'NINE-LED-12093',
      name: 'Nine LED Matrix',
      protocolType: LedProtocolType.manoTechMatrix,
      pinOrder: RgbPinOrder.rgb,
    );

    test('HappyLighting Triones RGB encodes 0x56 at max brightness and 0x78 when dimmed', () {
      const cyberGreen = LedRgbColor(0x8D, 0xC6, 0x3F);
      final full = LedBleProtocolEncoder.encodeColor(trionesDevice, cyberGreen, 255);
      expect(full, [0x56, 0x8D, 0xC6, 0x3F, 0x00, 0xF0, 0xAA]);
      expect(LedBleProtocolEncoder.toHexString(full), '56 8D C6 3F 00 F0 AA');

      final dimmed = LedBleProtocolEncoder.encodeColor(trionesDevice, cyberGreen, 128);
      expect(dimmed.first, 0x78);
      expect(dimmed.last, 0xEE);
      expect(dimmed.length, 7);
    });

    test('HappyLighting Triones Power & Mode encode accurately', () {
      expect(LedBleProtocolEncoder.encodePower(trionesDevice, true), [0xCC, 0x23, 0x33]);
      expect(LedBleProtocolEncoder.encodePower(trionesDevice, false), [0xCC, 0x24, 0x33]);
      expect(LedBleProtocolEncoder.encodeMode(trionesDevice, SmartLampMode.dynamicSign), [0xBB, 0x26, 0x10, 0x44]);
      expect(LedBleProtocolEncoder.encodeSetting(trionesDevice, 9, 140), [0xBB, 0x09, 140, 0x44]);
    });

    test('LED LAMP Car02 encodes 0x7E..0xEF frames for RGB, Power, Mode & IC Chip', () {
      const devilRed = LedRgbColor(0xED, 0x1C, 0x24);
      expect(
        LedBleProtocolEncoder.encodeColor(ledCarDevice, devilRed, 255),
        [0x7E, 0xFF, 0x05, 0x03, 0xED, 0x1C, 0x24, 0xFF, 0xEF],
      );
      expect(
        LedBleProtocolEncoder.encodePower(ledCarDevice, true),
        [0x7E, 0xFF, 0x04, 0x01, 0x00, 0xFF, 0xFF, 0x00, 0xEF],
      );
      expect(
        LedBleProtocolEncoder.encodePower(ledCarDevice, false),
        [0x7E, 0xFF, 0x04, 0x00, 0x00, 0xFF, 0xFF, 0x00, 0xEF],
      );
      expect(
        LedBleProtocolEncoder.encodeIcChipConfig(ledCarDevice, LedIcChipType.ws2811, 60),
        [0x7E, 0xFF, 0x06, 0x00, 0x00, 60, 0xFF, 0x00, 0xEF],
      );
    });

    test('RGB Pin Sort Calibration remaps channels accurately', () {
      const sample = LedRgbColor(10, 20, 30);
      expect(LedBleProtocolEncoder.applyPinOrder(sample, RgbPinOrder.rgb), [10, 20, 30]);
      expect(LedBleProtocolEncoder.applyPinOrder(sample, RgbPinOrder.rbg), [10, 30, 20]);
      expect(LedBleProtocolEncoder.applyPinOrder(sample, RgbPinOrder.grb), [20, 10, 30]);
      expect(LedBleProtocolEncoder.applyPinOrder(sample, RgbPinOrder.gbr), [20, 30, 10]);
      expect(LedBleProtocolEncoder.applyPinOrder(sample, RgbPinOrder.brg), [30, 10, 20]);
      expect(LedBleProtocolEncoder.applyPinOrder(sample, RgbPinOrder.bgr), [30, 20, 10]);
    });

    test('ManoTech Matrix encodes ST,x modes, TXT running text, and CHIP commands', () {
      expect(utf8.decode(LedBleProtocolEncoder.encodeMode(matrixDevice, SmartLampMode.runningText)), 'ST,7');
      expect(utf8.decode(LedBleProtocolEncoder.encodeMode(matrixDevice, SmartLampMode.dynamicSign)), 'ST,1');
      expect(utf8.decode(LedBleProtocolEncoder.encodeSetting(matrixDevice, 9, 140)), 'SET,9,140');
      expect(
        utf8.decode(LedBleProtocolEncoder.encodeRunningText('nine autoseries', 140)),
        'TXT,NINE AUTOSERIES,140',
      );
      expect(
        utf8.decode(LedBleProtocolEncoder.encodeIcChipConfig(matrixDevice, LedIcChipType.ucs1903, 120)),
        'CHIP,UCS1903,120',
      );
    });

    test('ManoTech Matrix encodes 28-pixel DIY grid (CB1..CB28 NINE TL parity)', () {
      final pixels = List<bool>.filled(28, false);
      pixels[0] = true;
      pixels[27] = true;
      final encoded = LedBleProtocolEncoder.encodeNineMatrixGrid(pixels);
      final decoded = utf8.decode(encoded);
      expect(decoded.startsWith('GRID,100'), isTrue);
      expect(decoded.endsWith('001'), isTrue);
      expect(decoded.length, 5 + 28); // "GRID," + 28 chars
    });

    test('HEX telemetry parser converts valid hex string and throws on invalid byte', () {
      final bytes = LedBleProtocolEncoder.parseHexTelemetry('7E FF 05 03 8D C6 3F FF EF');
      expect(bytes, [0x7E, 0xFF, 0x05, 0x03, 0x8D, 0xC6, 0x3F, 0xFF, 0xEF]);
      expect(() => LedBleProtocolEncoder.parseHexTelemetry('7E ZZ 05'), throwsFormatException);
    });

    test('Repository normalizes BLE failures into non-technical Indonesian messages (SOP 3.8)', () async {
      final repo = SmartLightingRepositoryImpl(_FailingBleDataSource());
      final scanRes = await repo.scanDevices();
      expect(scanRes.isLeft, isTrue);
      scanRes.fold(
        (f) => expect(f.message, isNot(contains('Exception'))),
        (_) => fail('Expected failure'),
      );

      final connRes = await repo.connectDevice('NONE');
      expect(connRes.isLeft, isTrue);

      final pwrRes = await repo.sendPower(matrixDevice, true);
      expect(pwrRes.isLeft, isTrue);

      final chipRes = await repo.sendIcChipConfig(matrixDevice, LedIcChipType.ws2812b, 32);
      expect(chipRes.isLeft, isTrue);
    });
  });
}
