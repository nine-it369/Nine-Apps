import 'package:equatable/equatable.dart';

class MallCarouselEntity extends Equatable {
  final String batchName;
  final String imageUrl;

  const MallCarouselEntity({
    required this.batchName,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [batchName, imageUrl];
}

class MallCategoryEntity extends Equatable {
  final int id;
  final int? parentId;
  final String name;
  final String slug;

  const MallCategoryEntity({
    required this.id,
    this.parentId,
    required this.name,
    required this.slug,
  });

  @override
  List<Object?> get props => [id, parentId, name, slug];
}

class MallProductEntity extends Equatable {
  final int id;
  final int categoryId;
  final String productName;
  final String name;
  final String subtitle;
  final String sku;
  final int price;
  final int discPrice;
  final int installationPrice;
  final int installationPricePromo;
  final String? thumbnailId;
  final String? imageUrl;
  final bool isFlashSale;

  const MallProductEntity({
    required this.id,
    required this.categoryId,
    required this.productName,
    required this.name,
    required this.subtitle,
    required this.sku,
    required this.price,
    required this.discPrice,
    this.installationPrice = 0,
    this.installationPricePromo = 0,
    this.thumbnailId,
    this.imageUrl,
    this.isFlashSale = false,
  });

  String get resolvedImageUrl {
    if (imageUrl != null && imageUrl!.startsWith('http')) return imageUrl!;
    if (thumbnailId != null && thumbnailId!.isNotEmpty) {
      return 'https://directus.nine.co.id/assets/$thumbnailId?format=webp&quality=80';
    }
    return 'https://directus.nine.co.id/assets/e9ce0a22-ed0c-4f67-9a29-9698e7b9afcb';
  }

  @override
  List<Object?> get props => [
        id,
        categoryId,
        productName,
        name,
        subtitle,
        sku,
        price,
        discPrice,
        installationPrice,
        installationPricePromo,
        thumbnailId,
        imageUrl,
        isFlashSale,
      ];
}
