import 'package:equatable/equatable.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../garage/domain/entities/voucher_entity.dart';

enum ProfileStatus { initial, loading, loaded, success, error }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final UserEntity user;
  final List<VoucherEntity> vouchers;
  final String? errorMessage;
  final String? successMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.user = const UserEntity(
      id: 1,
      name: 'Aditya Pratama',
      phone: '08123456789',
      email: 'aditya.pratama@gmail.com',
      referralCode: 'AP-NINE99',
      nineKoinBalance: 2450,
      isActive: true,
      isVerified: true,
    ),
    this.vouchers = const [],
    this.errorMessage,
    this.successMessage,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    UserEntity? user,
    List<VoucherEntity>? vouchers,
    String? errorMessage,
    String? successMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      vouchers: vouchers ?? this.vouchers,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        user,
        vouchers,
        errorMessage,
        successMessage,
      ];
}
