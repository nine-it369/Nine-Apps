import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String name;
  final String phone;
  final String? email;
  final String? imageUrl;
  final String referralCode;
  final int nineKoinBalance;
  final bool isActive;
  final bool isVerified;

  const UserEntity({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.imageUrl,
    required this.referralCode,
    this.nineKoinBalance = 0,
    this.isActive = true,
    this.isVerified = false,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        phone,
        email,
        imageUrl,
        referralCode,
        nineKoinBalance,
        isActive,
        isVerified,
      ];
}
