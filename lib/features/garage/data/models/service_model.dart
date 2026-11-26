import '../../domain/entities/service_entity.dart';

class ServiceModel extends ServiceEntity {
  const ServiceModel({
    required super.id,
    required super.name,
    required super.shortDesc,
    required super.vehicleType,
    required super.isEv,
    required super.estimatedMinutes,
    required super.requiredTechnicians,
    required super.warrantyMonths,
    required super.price,
    required super.nowPrice,
    super.imageUrl,
    super.isActive = true,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name']?.toString() ?? '',
      shortDesc: json['short_desc']?.toString() ?? '',
      vehicleType: json['vehicle_type']?.toString() ?? 'all',
      isEv: json['is_ev'] == true || json['is_ev'] == 1,
      estimatedMinutes: json['estimated_minutes'] is int
          ? json['estimated_minutes'] as int
          : int.tryParse(json['estimated_minutes']?.toString() ?? '60') ?? 60,
      requiredTechnicians: json['required_technicians'] is int
          ? json['required_technicians'] as int
          : int.tryParse(json['required_technicians']?.toString() ?? '1') ?? 1,
      warrantyMonths: json['warranty_months'] is int
          ? json['warranty_months'] as int
          : int.tryParse(json['warranty_months']?.toString() ?? '3') ?? 3,
      price: json['price'] is num ? json['price'] as num : num.tryParse(json['price']?.toString() ?? '0') ?? 0,
      nowPrice: json['now_price'] is num
          ? json['now_price'] as num
          : num.tryParse(json['now_price']?.toString() ?? '0') ?? 0,
      imageUrl: json['image_url']?.toString(),
      isActive: json['is_active'] != false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'short_desc': shortDesc,
      'vehicle_type': vehicleType,
      'is_ev': isEv,
      'estimated_minutes': estimatedMinutes,
      'required_technicians': requiredTechnicians,
      'warranty_months': warrantyMonths,
      'price': price,
      'now_price': nowPrice,
      'image_url': imageUrl,
      'is_active': isActive,
    };
  }
}
