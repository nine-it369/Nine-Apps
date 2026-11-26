import 'package:equatable/equatable.dart';

class VoucherEntity extends Equatable {
  final int id;
  final String code;
  final String name;
  final String description;
  final String targetType;
  final String discountType; // fixed | percentage
  final num discountMotorcycle;
  final num discountCar;
  final num minPurchase;
  final num? maxDiscount;
  final bool isActive;

  const VoucherEntity({
    required this.id,
    required this.code,
    required this.name,
    this.description = '',
    this.targetType = 'all',
    this.discountType = 'fixed',
    this.discountMotorcycle = 0,
    this.discountCar = 0,
    this.minPurchase = 0,
    this.maxDiscount,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [
        id,
        code,
        name,
        description,
        targetType,
        discountType,
        discountMotorcycle,
        discountCar,
        minPurchase,
        maxDiscount,
        isActive,
      ];
}

class VoucherValidationResultEntity extends Equatable {
  final bool valid;
  final num discountAmount;
  final String? reason;

  const VoucherValidationResultEntity({
    required this.valid,
    required this.discountAmount,
    this.reason,
  });

  @override
  List<Object?> get props => [valid, discountAmount, reason];
}
