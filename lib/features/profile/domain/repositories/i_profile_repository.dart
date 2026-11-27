import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../garage/domain/entities/voucher_entity.dart';
import '../entities/customer_address_entity.dart';
import '../entities/customer_order_summary_entity.dart';

abstract class IProfileRepository {
  Future<Either<Failure, UserEntity>> getProfile();
  Future<Either<Failure, UserEntity>> updateProfile({
    required String name,
    String? email,
  });
  Future<Either<Failure, void>> changePassword({
    required String oldPassword,
    required String newPassword,
  });
  Future<Either<Failure, List<VoucherEntity>>> getCustomerVouchers();
  Future<Either<Failure, List<CustomerAddressEntity>>> getAddresses();
  Future<Either<Failure, List<CustomerOrderSummaryEntity>>> getOrders();
}
