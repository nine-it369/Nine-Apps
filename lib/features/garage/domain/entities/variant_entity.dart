import 'package:equatable/equatable.dart';

class VariantRequiredServiceEntity extends Equatable {
  final int serviceId;
  final String serviceName;
  final num servicePrice;
  final num serviceDiscPrice;
  final int estimatedMinutes;
  final int requiredTechnicians;
  final String vehicleType;
  final bool isEv;
  final bool isMandatory;

  const VariantRequiredServiceEntity({
    required this.serviceId,
    required this.serviceName,
    required this.servicePrice,
    required this.serviceDiscPrice,
    required this.estimatedMinutes,
    required this.requiredTechnicians,
    required this.vehicleType,
    required this.isEv,
    required this.isMandatory,
  });

  @override
  List<Object?> get props => [
        serviceId,
        serviceName,
        servicePrice,
        serviceDiscPrice,
        estimatedMinutes,
        requiredTechnicians,
        vehicleType,
        isEv,
        isMandatory,
      ];
}

class VariantEntity extends Equatable {
  final int id;
  final int? productId;
  final int? categoryId;
  final String? productName;
  final String name;
  final String? subtitle;
  final String? sku;
  final num price;
  final num discPrice;
  final num nowPrice;
  final num installationPrice;
  final num installationPricePromo;
  final int estimatedMinutes;
  final int requiredTechnicians;
  final bool isActive;
  final bool isAvailable;
  final int? stock;
  final int? parentId;
  final String? thumbnailId;
  final List<String> images;
  final List<VariantEntity> children;
  final List<VariantRequiredServiceEntity> requiredServices;

  const VariantEntity({
    required this.id,
    this.productId,
    this.categoryId,
    this.productName,
    required this.name,
    this.subtitle,
    this.sku,
    required this.price,
    this.discPrice = 0,
    required this.nowPrice,
    this.installationPrice = 0,
    this.installationPricePromo = 0,
    this.estimatedMinutes = 0,
    this.requiredTechnicians = 1,
    this.isActive = true,
    this.isAvailable = true,
    this.stock,
    this.parentId,
    this.thumbnailId,
    this.images = const [],
    this.children = const [],
    this.requiredServices = const [],
  });

  bool get isInStock {
    if (!isAvailable || !isActive) return false;
    if (children.isNotEmpty) {
      return children.any((c) => c.isAvailable && c.isActive && (c.stock == null || c.stock! > 0));
    }
    if (stock != null && stock! <= 0) return false;
    return true;
  }

  String get displayName {
    if (parentId != null && productName != null && name.toLowerCase().startsWith(productName!.toLowerCase())) {
      var cleaned = name.substring(productName!.length).trim();
      while (cleaned.startsWith('-') || cleaned.startsWith(':') || cleaned.startsWith('/') || cleaned.startsWith(' ')) {
        cleaned = cleaned.substring(1).trim();
      }
      if (cleaned.startsWith('(') && cleaned.endsWith(')')) {
        cleaned = cleaned.substring(1, cleaned.length - 1).trim();
      }
      if (cleaned.isNotEmpty) return cleaned;
    }
    return name;
  }

  @override
  List<Object?> get props => [
        id,
        productId,
        categoryId,
        productName,
        name,
        subtitle,
        sku,
        price,
        discPrice,
        nowPrice,
        installationPrice,
        installationPricePromo,
        estimatedMinutes,
        requiredTechnicians,
        isActive,
        isAvailable,
        stock,
        parentId,
        thumbnailId,
        images,
        children,
        requiredServices,
      ];
}
