import 'package:equatable/equatable.dart';

class PackageEntity extends Equatable {
  final int id;
  final String name;
  final String description;
  final num price;
  final num nowPrice;
  final num evPrice;
  final num evDiscPrice;
  final List<String> benefits;
  final bool isActive;

  const PackageEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.nowPrice,
    this.evPrice = 0,
    this.evDiscPrice = 0,
    this.benefits = const [],
    this.isActive = true,
  });

  num effectivePrice(bool isEv) {
    if (isEv && evDiscPrice > 0) return evDiscPrice;
    if (isEv && evPrice > 0) return evPrice;
    return nowPrice > 0 ? nowPrice : price;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        nowPrice,
        evPrice,
        evDiscPrice,
        benefits,
        isActive,
      ];
}
