import 'package:equatable/equatable.dart';

class ServiceEntity extends Equatable {
  final int id;
  final String name;
  final String shortDesc;
  final String vehicleType;
  final bool isEv;
  final int estimatedMinutes;
  final int requiredTechnicians;
  final int warrantyMonths;
  final num price;
  final num nowPrice;
  final String? imageUrl;
  final bool isActive;

  const ServiceEntity({
    required this.id,
    required this.name,
    required this.shortDesc,
    required this.vehicleType,
    required this.isEv,
    required this.estimatedMinutes,
    required this.requiredTechnicians,
    required this.warrantyMonths,
    required this.price,
    required this.nowPrice,
    this.imageUrl,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        shortDesc,
        vehicleType,
        isEv,
        estimatedMinutes,
        requiredTechnicians,
        warrantyMonths,
        price,
        nowPrice,
        imageUrl,
        isActive,
      ];
}
