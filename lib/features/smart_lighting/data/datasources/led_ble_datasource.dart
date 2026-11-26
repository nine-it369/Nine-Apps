import '../../domain/entities/led_device_entity.dart';

abstract class ILedBleDataSource {
  Future<List<LedDeviceEntity>> scanDevices();
  Future<LedDeviceEntity> connectDevice(String deviceId);
  Future<void> writePacket(LedDeviceEntity device, List<int> packet);
}

class SimulatedLedBleDataSourceImpl implements ILedBleDataSource {
  final List<LedDeviceEntity> _devices = [
    const LedDeviceEntity(
      id: 'NINE-LED-12093',
      name: 'Nine LED Matrix (NINE-LED-12093)',
      protocolType: LedProtocolType.manoTechMatrix,
      pinOrder: RgbPinOrder.rgb,
      isConnected: true,
      rssi: -46,
    ),
    const LedDeviceEntity(
      id: 'LEDCAR-02-8812',
      name: 'LEDCAR-02 BiLED Demon Eye',
      protocolType: LedProtocolType.ledLampCar02,
      pinOrder: RgbPinOrder.grb,
      isConnected: false,
      rssi: -58,
    ),
    const LedDeviceEntity(
      id: 'Triones-Biled-01',
      name: 'HappyLighting Ambient Cabin',
      protocolType: LedProtocolType.happyLightingTriones,
      pinOrder: RgbPinOrder.rgb,
      isConnected: false,
      rssi: -64,
    ),
  ];

  final List<List<int>> sentHistory = [];

  @override
  Future<List<LedDeviceEntity>> scanDevices() async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return List.unmodifiable(_devices);
  }

  @override
  Future<LedDeviceEntity> connectDevice(String deviceId) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    final idx = _devices.indexWhere((d) => d.id == deviceId);
    if (idx == -1) {
      throw StateError('Perangkat Bluetooth LED ($deviceId) tidak ditemukan.');
    }
    for (var i = 0; i < _devices.length; i++) {
      _devices[i] = _devices[i].copyWith(isConnected: i == idx);
    }
    return _devices[idx];
  }

  @override
  Future<void> writePacket(LedDeviceEntity device, List<int> packet) async {
    // Micro-delay simulating GATT writeCharacteristic without blocking UI
    sentHistory.add(packet);
  }
}
