import '../../domain/entities/regency_entity.dart';

class RegencyModel extends RegencyEntity {
  const RegencyModel({
    required super.id,
    required super.name,
    super.provinceId,
  });

  factory RegencyModel.fromJson(Map<String, dynamic> json) {
    return RegencyModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      provinceId: json['province_id'] is int
          ? json['province_id'] as int
          : int.tryParse(json['province_id']?.toString() ?? ''),
    );
  }
}
