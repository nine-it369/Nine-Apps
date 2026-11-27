import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.phone,
    super.email,
    super.imageUrl,
    required super.referralCode,
    super.nineKoinBalance = 0,
    super.isActive = true,
    super.isVerified = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? json['customer_name'] as String? ?? 'Pelanggan Nine',
      phone: json['phone'] as String? ?? json['customer_phone'] as String? ?? '',
      email: json['email'] as String? ?? json['customer_email'] as String?,
      imageUrl: json['image_url'] as String?,
      referralCode: json['referral_code'] as String? ?? 'NINE-VIP',
      nineKoinBalance: (json['nine_koin_balance'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      isVerified: json['is_verified'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'image_url': imageUrl,
      'referral_code': referralCode,
      'nine_koin_balance': nineKoinBalance,
      'is_active': isActive,
      'is_verified': isVerified,
    };
  }
}
