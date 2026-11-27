import 'package:equatable/equatable.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../garage/domain/entities/voucher_entity.dart';
import '../../domain/entities/customer_address_entity.dart';
import '../../domain/entities/customer_order_summary_entity.dart';

enum ProfileStatus { initial, loading, loaded, success, error }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final UserEntity user;
  final List<VoucherEntity> vouchers;
  final List<CustomerAddressEntity> addresses;
  final List<CustomerOrderSummaryEntity> orders;
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
    this.addresses = const [],
    this.orders = const [],
    this.errorMessage,
    this.successMessage,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    UserEntity? user,
    List<VoucherEntity>? vouchers,
    List<CustomerAddressEntity>? addresses,
    List<CustomerOrderSummaryEntity>? orders,
    String? errorMessage,
    String? successMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      vouchers: vouchers ?? this.vouchers,
      addresses: addresses ?? this.addresses,
      orders: orders ?? this.orders,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        user,
        vouchers,
        addresses,
        orders,
        errorMessage,
        successMessage,
      ];
}
