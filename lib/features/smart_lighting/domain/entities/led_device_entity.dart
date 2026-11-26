import 'package:equatable/equatable.dart';

/// Supported Bluetooth Low Energy lighting protocols extracted from pedoman_Apps
enum LedProtocolType {
  happyLightingTriones,
  ledLampCar02,
  manoTechMatrix,
}

/// Category classifying lights into Nine-proprietary Matrix Tail Light vs Universal RGB BLE lights
enum LedDeviceCategory {
  nineSpecific('Khusus Nine'),
  universal('Lampu Universal');

  final String label;
  const LedDeviceCategory(this.label);
}

/// Hardware wire RGB pin order calibration from LED LAMP (RgbSortActivity)
enum RgbPinOrder {
  rgb('RGB'),
  rbg('RBG'),
  grb('GRB'),
  gbr('GBR'),
  brg('BRG'),
  bgr('BGR');

  final String label;
  const RgbPinOrder(this.label);
}

/// Digital LED IC Driver Chip options from LED LAMP (ChipSelectActivity)
enum LedIcChipType {
  ws2811('WS2811'),
  ucs1903('UCS1903'),
  sm16703('SM16703'),
  ws2812b('WS2812B');

  final String label;
  const LedIcChipType(this.label);
}

class LedDeviceEntity extends Equatable {
  final String id;
  final String name;
  final LedProtocolType protocolType;
  final RgbPinOrder pinOrder;
  final LedIcChipType icChipType;
  final int pixelCount;
  final bool isConnected;
  final int rssi;

  const LedDeviceEntity({
    required this.id,
    required this.name,
    required this.protocolType,
    this.pinOrder = RgbPinOrder.rgb,
    this.icChipType = LedIcChipType.ws2812b,
    this.pixelCount = 32,
    this.isConnected = false,
    this.rssi = -52,
  });

  /// Automatically categorizes device based on protocol type
  LedDeviceCategory get category =>
      protocolType == LedProtocolType.manoTechMatrix
          ? LedDeviceCategory.nineSpecific
          : LedDeviceCategory.universal;

  bool get isNineSpecific => category == LedDeviceCategory.nineSpecific;
  bool get isUniversal => category == LedDeviceCategory.universal;

  LedDeviceEntity copyWith({
    String? id,
    String? name,
    LedProtocolType? protocolType,
    RgbPinOrder? pinOrder,
    LedIcChipType? icChipType,
    int? pixelCount,
    bool? isConnected,
    int? rssi,
  }) {
    return LedDeviceEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      protocolType: protocolType ?? this.protocolType,
      pinOrder: pinOrder ?? this.pinOrder,
      icChipType: icChipType ?? this.icChipType,
      pixelCount: pixelCount ?? this.pixelCount,
      isConnected: isConnected ?? this.isConnected,
      rssi: rssi ?? this.rssi,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        protocolType,
        pinOrder,
        icChipType,
        pixelCount,
        isConnected,
        rssi,
      ];
}
