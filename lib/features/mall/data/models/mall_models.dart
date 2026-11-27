import '../../domain/entities/mall_entities.dart';

class MallCarouselModel extends MallCarouselEntity {
  const MallCarouselModel({
    required super.batchName,
    required super.imageUrl,
  });

  factory MallCarouselModel.fromJson(Map<String, dynamic> json) {
    return MallCarouselModel(
      batchName: json['batch_name'] as String? ?? 'banner',
      imageUrl: json['urls'] as String? ?? json['image_url'] as String? ?? '',
    );
  }
}

class MallCategoryModel extends MallCategoryEntity {
  const MallCategoryModel({
    required super.id,
    super.parentId,
    required super.name,
    required super.slug,
  });

  factory MallCategoryModel.fromJson(Map<String, dynamic> json) {
    return MallCategoryModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      parentId: (json['parent_id'] as num?)?.toInt(),
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
    );
  }
}

class MallProductModel extends MallProductEntity {
  const MallProductModel({
    required super.id,
    required super.categoryId,
    required super.productName,
    required super.name,
    required super.subtitle,
    required super.sku,
    required super.price,
    required super.discPrice,
    super.installationPrice = 0,
    super.installationPricePromo = 0,
    super.thumbnailId,
    super.imageUrl,
    super.isFlashSale = false,
  });

  factory MallProductModel.fromJson(Map<String, dynamic> json) {
    final price = (json['price'] as num?)?.toInt() ?? 0;
    final discPrice = (json['disc_price'] as num?)?.toInt() ?? price;

    return MallProductModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      categoryId: (json['category_id'] as num?)?.toInt() ?? 0,
      productName: json['product_name'] as String? ?? 'Nine Autoseries',
      name: json['name'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      sku: json['sku'] as String? ?? '',
      price: price,
      discPrice: discPrice > 0 ? discPrice : price,
      installationPrice: (json['installation_price'] as num?)?.toInt() ?? 0,
      installationPricePromo: (json['installation_price_promo'] as num?)?.toInt() ?? 0,
      thumbnailId: json['thumbnail_id'] as String?,
      imageUrl: json['image_url'] as String?,
      isFlashSale: discPrice > 0 && discPrice < price,
    );
  }
}
