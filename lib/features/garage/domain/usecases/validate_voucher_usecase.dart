import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/voucher_entity.dart';
import '../repositories/i_garage_repository.dart';

class ValidateVoucherParams {
  final int voucherId;
  final String vehicleType;
  final String bookingDate;
  final String hour;
  final bool isEv;
  final int workshopId;
  final List<int> serviceIds;
  final List<int> packageIds;

  const ValidateVoucherParams({
    required this.voucherId,
    required this.vehicleType,
    required this.bookingDate,
    required this.hour,
    required this.isEv,
    required this.workshopId,
    this.serviceIds = const [],
    this.packageIds = const [],
  });
}

class ValidateVoucherUseCase implements UseCase<VoucherValidationResultEntity, ValidateVoucherParams> {
  final IGarageRepository repository;
  ValidateVoucherUseCase(this.repository);

  @override
  Future<Either<Failure, VoucherValidationResultEntity>> call(ValidateVoucherParams params) {
    return repository.validateVoucher(
      voucherId: params.voucherId,
      vehicleType: params.vehicleType,
      bookingDate: params.bookingDate,
      hour: params.hour,
      isEv: params.isEv,
      workshopId: params.workshopId,
      serviceIds: params.serviceIds,
      packageIds: params.packageIds,
    );
  }
}
