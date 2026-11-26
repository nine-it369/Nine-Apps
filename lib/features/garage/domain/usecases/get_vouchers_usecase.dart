import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/voucher_entity.dart';
import '../repositories/i_garage_repository.dart';

class GetVouchersParams {
  final int? workshopId;
  final String? date;
  final String? time;

  const GetVouchersParams({this.workshopId, this.date, this.time});
}

class GetVouchersUseCase implements UseCase<List<VoucherEntity>, GetVouchersParams> {
  final IGarageRepository repository;
  GetVouchersUseCase(this.repository);

  @override
  Future<Either<Failure, List<VoucherEntity>>> call(GetVouchersParams params) {
    return repository.getAvailableVouchers(
      workshopId: params.workshopId,
      date: params.date,
      time: params.time,
    );
  }
}
