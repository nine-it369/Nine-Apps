import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/i_garage_repository.dart';

class CancelPreviewParams {
  final int workshopId;
  final String bookingDate;
  final String hour;
  final String customerPhone;
  final String? customerEmail;

  const CancelPreviewParams({
    required this.workshopId,
    required this.bookingDate,
    required this.hour,
    required this.customerPhone,
    this.customerEmail,
  });
}

class CancelPreviewBookingUseCase implements UseCase<void, CancelPreviewParams> {
  final IGarageRepository repository;
  CancelPreviewBookingUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(CancelPreviewParams params) {
    return repository.cancelPreviewBooking(
      workshopId: params.workshopId,
      bookingDate: params.bookingDate,
      hour: params.hour,
      customerPhone: params.customerPhone,
      customerEmail: params.customerEmail,
    );
  }
}
