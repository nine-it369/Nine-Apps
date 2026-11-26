import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/booking_availability_entity.dart';
import '../repositories/i_garage_repository.dart';

class GetAvailabilityParams {
  final int workshopId;
  final String bookingDate;
  final String? excludeTicket;

  const GetAvailabilityParams({
    required this.workshopId,
    required this.bookingDate,
    this.excludeTicket,
  });
}

class GetAvailabilityUseCase implements UseCase<List<BookingAvailabilityEntity>, GetAvailabilityParams> {
  final IGarageRepository repository;

  GetAvailabilityUseCase(this.repository);

  @override
  Future<Either<Failure, List<BookingAvailabilityEntity>>> call(GetAvailabilityParams params) {
    return repository.getAvailability(
      workshopId: params.workshopId,
      bookingDate: params.bookingDate,
      excludeTicket: params.excludeTicket,
    );
  }
}
