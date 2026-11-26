import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/booking_entity.dart';
import '../repositories/i_garage_repository.dart';

class GetBookingByTicketUseCase implements UseCase<BookingEntity, String> {
  final IGarageRepository repository;
  GetBookingByTicketUseCase(this.repository);

  @override
  Future<Either<Failure, BookingEntity>> call(String ticket) {
    return repository.getBookingByTicket(ticket);
  }
}
