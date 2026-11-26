import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/booking_entity.dart';
import '../repositories/i_garage_repository.dart';

class UpdateBookingParams {
  final String ticket;
  final BookingEntity booking;

  const UpdateBookingParams({
    required this.ticket,
    required this.booking,
  });
}

class UpdateBookingUseCase implements UseCase<BookingEntity, UpdateBookingParams> {
  final IGarageRepository repository;

  UpdateBookingUseCase(this.repository);

  @override
  Future<Either<Failure, BookingEntity>> call(UpdateBookingParams params) {
    return repository.updateBooking(params.ticket, params.booking);
  }
}
