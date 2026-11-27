import '../../domain/entities/customer_address_entity.dart';

class CustomerAddressModel extends CustomerAddressEntity {
  const CustomerAddressModel({
    required super.id,
    required super.label,
    required super.recipientName,
    required super.phone,
    required super.fullAddress,
    super.city,
    super.province,
    super.postalCode,
    super.isPrimary,
  });

  factory CustomerAddressModel.fromJson(Map<String, dynamic> json) {
    return CustomerAddressModel(
      id: json['id'] as int? ?? 0,
      label: (json['label'] ?? json['address_label'] ?? 'Alamat Rumah').toString(),
      recipientName: (json['recipient_name'] ?? json['name'] ?? 'Penerima').toString(),
      phone: (json['phone'] ?? json['recipient_phone'] ?? '').toString(),
      fullAddress: (json['address_line'] ?? json['address'] ?? json['full_address'] ?? '').toString(),
      city: json['city']?.toString(),
      province: json['province']?.toString(),
      postalCode: json['postal_code']?.toString(),
      isPrimary: json['is_primary'] as bool? ?? json['is_default'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'recipient_name': recipientName,
      'phone': phone,
      'address_line': fullAddress,
      'city': city,
      'province': province,
      'postal_code': postalCode,
      'is_primary': isPrimary,
    };
  }
}
