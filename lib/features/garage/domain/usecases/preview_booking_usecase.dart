import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/i_garage_repository.dart';

class PreviewBookingParams {
  final int workshopId;
  final String bookingDate;
  final String hour;
  final String customerPhone;
  final String? customerEmail;
  final List<int> serviceIds;
  final List<int> packageIds;
  final bool isEv;

  const PreviewBookingParams({
    required this.workshopId,
    required this.bookingDate,
    required this.hour,
    required this.customerPhone,
    this.customerEmail,
    this.serviceIds = const [],
    this.packageIds = const [],
    this.isEv = false,
  });
}

class PreviewBookingUseCase implements UseCase<void, PreviewBookingParams> {
  final IGarageRepository repository;
  PreviewBookingUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(PreviewBookingParams params) {
    return repository.previewBooking(
      workshopId: params.workshopId,
      bookingDate: params.bookingDate,
      hour: params.hour,
      customerPhone: params.customerPhone,
      customerEmail: params.customerEmail,
      serviceIds: params.serviceIds,
      packageIds: params.packageIds,
      isEv: params.isEv,
    );
  }
}
