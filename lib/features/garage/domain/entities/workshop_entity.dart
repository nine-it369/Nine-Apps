import 'package:equatable/equatable.dart';

class WorkshopEntity extends Equatable {
  final int id;
  final String name;
  final String code;
  final String address;
  final String city;
  final String? phone;
  final String? operatingHours;
  final bool isActive;

  const WorkshopEntity({
    required this.id,
    required this.name,
    required this.code,
    required this.address,
    required this.city,
    this.phone,
    this.operatingHours,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [id, name, code, address, city, phone, operatingHours, isActive];
}
