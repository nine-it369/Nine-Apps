import '../../domain/entities/voucher_entity.dart';

class VoucherModel extends VoucherEntity {
  const VoucherModel({
    required super.id,
    required super.code,
    required super.name,
    super.description = '',
    super.targetType = 'all',
    super.discountType = 'fixed',
    super.discountMotorcycle = 0,
    super.discountCar = 0,
    super.minPurchase = 0,
    super.maxDiscount,
    super.isActive = true,
  });

  factory VoucherModel.fromJson(Map<String, dynamic> json) {
    return VoucherModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      targetType: json['target_type']?.toString() ?? 'all',
      discountType: json['discount_type']?.toString() ?? 'fixed',
      discountMotorcycle: json['discount_motorcycle'] is num
          ? json['discount_motorcycle'] as num
          : num.tryParse(json['discount_motorcycle']?.toString() ?? '0') ?? 0,
      discountCar: json['discount_car'] is num
          ? json['discount_car'] as num
          : num.tryParse(json['discount_car']?.toString() ?? '0') ?? 0,
      minPurchase: json['min_purchase'] is num
          ? json['min_purchase'] as num
          : num.tryParse(json['min_purchase']?.toString() ?? '0') ?? 0,
      maxDiscount: json['max_discount'] is num ? json['max_discount'] as num : null,
      isActive: json['is_active'] != false,
    );
  }
}

class VoucherValidationResultModel extends VoucherValidationResultEntity {
  const VoucherValidationResultModel({
    required super.valid,
    required super.discountAmount,
    super.reason,
  });

  factory VoucherValidationResultModel.fromJson(Map<String, dynamic> json) {
    return VoucherValidationResultModel(
      valid: json['valid'] == true,
      discountAmount: json['discount_amount'] is num
          ? json['discount_amount'] as num
          : num.tryParse(json['discount_amount']?.toString() ?? '0') ?? 0,
      reason: json['reason']?.toString(),
    );
  }
}
