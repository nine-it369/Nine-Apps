import '../../domain/entities/workshop_entity.dart';

class WorkshopModel extends WorkshopEntity {
  const WorkshopModel({
    required super.id,
    required super.name,
    required super.code,
    required super.address,
    required super.city,
    super.phone,
    super.operatingHours,
    super.isActive = true,
  });

  factory WorkshopModel.fromJson(Map<String, dynamic> json) {
    return WorkshopModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      city: json['city']?.toString() ?? 'Tangerang',
      phone: json['phone']?.toString(),
      operatingHours: json['operating_hours']?.toString() ?? '09:00 - 18:00',
      isActive: json['is_active'] == true || json['is_active'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'address': address,
      'city': city,
      'phone': phone,
      'operating_hours': operatingHours,
      'is_active': isActive,
    };
  }
}
