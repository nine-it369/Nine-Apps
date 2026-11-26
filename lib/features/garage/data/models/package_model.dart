import '../../domain/entities/package_entity.dart';

class PackageModel extends PackageEntity {
  const PackageModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.nowPrice,
    super.evPrice = 0,
    super.evDiscPrice = 0,
    super.benefits = const [],
    super.isActive = true,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    final rawBenefits = json['benefits'] as List<dynamic>? ?? [];
    final parsedBenefits = rawBenefits
        .map((item) {
          if (item is Map) {
            return item['value']?.toString() ?? item['label']?.toString() ?? '';
          }
          return item.toString();
        })
        .where((s) => s.trim().isNotEmpty)
        .toList();

    return PackageModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: json['price'] is num ? json['price'] as num : num.tryParse(json['price']?.toString() ?? '0') ?? 0,
      nowPrice: json['now_price'] is num
          ? json['now_price'] as num
          : num.tryParse(json['now_price']?.toString() ?? '0') ?? 0,
      evPrice: json['ev_price'] is num
          ? json['ev_price'] as num
          : num.tryParse(json['ev_price']?.toString() ?? '0') ?? 0,
      evDiscPrice: json['ev_disc_price'] is num
          ? json['ev_disc_price'] as num
          : num.tryParse(json['ev_disc_price']?.toString() ?? '0') ?? 0,
      benefits: parsedBenefits,
      isActive: json['is_active'] != false,
    );
  }
}
