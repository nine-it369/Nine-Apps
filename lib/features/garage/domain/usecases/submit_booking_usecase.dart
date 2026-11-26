import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/booking_entity.dart';
import '../repositories/i_garage_repository.dart';

class SubmitBookingUseCase implements UseCase<BookingEntity, BookingEntity> {
  final IGarageRepository repository;

  SubmitBookingUseCase(this.repository);

  @override
  Future<Either<Failure, BookingEntity>> call(BookingEntity booking) {
    return repository.submitBooking(booking);
  }
}
