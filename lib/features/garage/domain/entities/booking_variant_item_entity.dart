import 'package:equatable/equatable.dart';

class BookingVariantItemEntity extends Equatable {
  final int variantId;
  final int qty;
  final int? packageId;
  final bool withInstallation;
  final int? serviceId;
  final num? servicePrice;
  final num? serviceDiscPrice;
  final String? serviceName;
  final String? variantName;
  final num? price;
  final num? discPrice;

  const BookingVariantItemEntity({
    required this.variantId,
    this.qty = 1,
    this.packageId,
    this.withInstallation = false,
    this.serviceId,
    this.servicePrice,
    this.serviceDiscPrice,
    this.serviceName,
    this.variantName,
    this.price,
    this.discPrice,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'variant_id': variantId,
      'qty': qty,
    };
    if (packageId != null) {
      map['package_id'] = packageId;
    }
    if (withInstallation) {
      map['with_installation'] = true;
      if (serviceId != null) map['service_id'] = serviceId;
    } else {
      map['with_installation'] = false;
    }
    return map;
  }

  factory BookingVariantItemEntity.fromJson(Map<String, dynamic> json) {
    return BookingVariantItemEntity(
      variantId: json['variant_id'] ?? json['id'] ?? 0,
      qty: json['qty'] ?? 1,
      packageId: json['package_id'],
      withInstallation: json['with_installation'] == true,
      serviceId: json['service_id'],
      servicePrice: json['service_price'],
      serviceDiscPrice: json['service_disc_price'],
      serviceName: json['service_name'],
      variantName: json['variant_name'] ?? json['name'],
      price: json['price'],
      discPrice: json['disc_price'],
    );
  }

  @override
  List<Object?> get props => [
        variantId,
        qty,
        packageId,
        withInstallation,
        serviceId,
        servicePrice,
        serviceDiscPrice,
        serviceName,
        variantName,
        price,
        discPrice,
      ];
}
