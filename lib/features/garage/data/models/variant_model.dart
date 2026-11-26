import '../../domain/entities/variant_entity.dart';

class VariantRequiredServiceModel extends VariantRequiredServiceEntity {
  const VariantRequiredServiceModel({
    required super.serviceId,
    required super.serviceName,
    required super.servicePrice,
    required super.serviceDiscPrice,
    required super.estimatedMinutes,
    required super.requiredTechnicians,
    required super.vehicleType,
    required super.isEv,
    required super.isMandatory,
  });

  factory VariantRequiredServiceModel.fromJson(Map<String, dynamic> json) {
    return VariantRequiredServiceModel(
      serviceId: json['service_id'] is int
          ? json['service_id'] as int
          : int.tryParse(json['service_id']?.toString() ?? '0') ?? 0,
      serviceName: json['service_name']?.toString() ?? '',
      servicePrice: json['service_price'] is num
          ? json['service_price'] as num
          : num.tryParse(json['service_price']?.toString() ?? '0') ?? 0,
      serviceDiscPrice: json['service_disc_price'] is num
          ? json['service_disc_price'] as num
          : num.tryParse(json['service_disc_price']?.toString() ?? '0') ?? 0,
      estimatedMinutes: json['estimated_minutes'] is int
          ? json['estimated_minutes'] as int
          : int.tryParse(json['estimated_minutes']?.toString() ?? '30') ?? 30,
      requiredTechnicians: json['required_technicians'] is int
          ? json['required_technicians'] as int
          : int.tryParse(json['required_technicians']?.toString() ?? '1') ?? 1,
      vehicleType: json['vehicle_type']?.toString() ?? 'motorcycle',
      isEv: json['is_ev'] == true,
      isMandatory: json['is_mandatory'] != false,
    );
  }
}

class VariantModel extends VariantEntity {
  const VariantModel({
    required super.id,
    super.productId,
    super.categoryId,
    super.productName,
    required super.name,
    super.subtitle,
    super.sku,
    required super.price,
    super.discPrice = 0,
    required super.nowPrice,
    super.installationPrice = 0,
    super.installationPricePromo = 0,
    super.estimatedMinutes = 0,
    super.requiredTechnicians = 1,
    super.isActive = true,
    super.isAvailable = true,
    super.stock,
    super.parentId,
    super.thumbnailId,
    super.images = const [],
    super.children = const [],
    super.requiredServices = const [],
  });

  factory VariantModel.fromJson(Map<String, dynamic> json) {
    final rawPrice = json['price'] is num
        ? json['price'] as num
        : num.tryParse(json['price']?.toString() ?? '0') ?? 0;
    final rawDisc = json['disc_price'] is num
        ? json['disc_price'] as num
        : num.tryParse(json['disc_price']?.toString() ?? '0') ?? 0;
    final rawInstallPrice = json['installation_price'] is num
        ? json['installation_price'] as num
        : num.tryParse(json['installation_price']?.toString() ?? '0') ?? 0;
    final rawInstallPromo = json['installation_price_promo'] is num
        ? json['installation_price_promo'] as num
        : num.tryParse(json['installation_price_promo']?.toString() ?? '0') ?? rawInstallPrice;

    final effectiveNowPrice = rawDisc > 0 ? rawDisc : rawPrice;

    final parsedImages = <String>[];
    if (json['images'] is List) {
      for (final img in json['images'] as List) {
        if (img is String) {
          parsedImages.add(img);
        } else if (img is Map) {
          final id = img['directus_files_id'] ?? img['id'] ?? img['file_id'];
          if (id != null) parsedImages.add(id.toString());
        }
      }
    }

    final parsedChildren = <VariantEntity>[];
    if (json['children'] is List) {
      for (final c in json['children'] as List) {
        if (c is Map<String, dynamic>) {
          parsedChildren.add(VariantModel.fromJson(c));
        } else if (c is Map) {
          parsedChildren.add(VariantModel.fromJson(Map<String, dynamic>.from(c)));
        }
      }
    }

    final parsedRequiredServices = <VariantRequiredServiceEntity>[];
    if (json['required_services'] is List) {
      for (final rs in json['required_services'] as List) {
        if (rs is Map<String, dynamic>) {
          parsedRequiredServices.add(VariantRequiredServiceModel.fromJson(rs));
        } else if (rs is Map) {
          parsedRequiredServices.add(VariantRequiredServiceModel.fromJson(Map<String, dynamic>.from(rs)));
        }
      }
    }

    return VariantModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      productId: json['product_id'] is int
          ? json['product_id'] as int
          : int.tryParse(json['product_id']?.toString() ?? ''),
      categoryId: json['category_id'] is int
          ? json['category_id'] as int
          : int.tryParse(json['category_id']?.toString() ?? ''),
      productName: json['product_name']?.toString(),
      name: json['name']?.toString() ?? '',
      subtitle: json['subtitle']?.toString(),
      sku: json['sku']?.toString(),
      price: rawPrice,
      discPrice: rawDisc,
      nowPrice: effectiveNowPrice,
      installationPrice: rawInstallPrice,
      installationPricePromo: rawInstallPromo,
      estimatedMinutes: json['estimated_minutes'] is int
          ? json['estimated_minutes'] as int
          : int.tryParse(json['estimated_minutes']?.toString() ?? '0') ?? 0,
      requiredTechnicians: json['required_technicians'] is int
          ? json['required_technicians'] as int
          : int.tryParse(json['required_technicians']?.toString() ?? '1') ?? 1,
      isActive: json['is_active'] != false,
      isAvailable: json['is_available'] != false,
      stock: json['stock'] is int
          ? json['stock'] as int
          : int.tryParse(json['stock']?.toString() ?? ''),
      parentId: json['parent_id'] is int
          ? json['parent_id'] as int
          : int.tryParse(json['parent_id']?.toString() ?? ''),
      thumbnailId: json['thumbnail_id']?.toString() ?? (parsedImages.isNotEmpty ? parsedImages.first : null),
      images: parsedImages,
      children: parsedChildren,
      requiredServices: parsedRequiredServices,
    );
  }
}
