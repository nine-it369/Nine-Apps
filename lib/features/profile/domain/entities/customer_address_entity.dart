import 'package:equatable/equatable.dart';

class CustomerAddressEntity extends Equatable {
  final int id;
  final String label;
  final String recipientName;
  final String phone;
  final String fullAddress;
  final String? city;
  final String? province;
  final String? postalCode;
  final bool isPrimary;

  const CustomerAddressEntity({
    required this.id,
    required this.label,
    required this.recipientName,
    required this.phone,
    required this.fullAddress,
    this.city,
    this.province,
    this.postalCode,
    this.isPrimary = false,
  });

  @override
  List<Object?> get props => [
        id,
        label,
        recipientName,
        phone,
        fullAddress,
        city,
        province,
        postalCode,
        isPrimary,
      ];
}
