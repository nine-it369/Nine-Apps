import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/booking_availability_entity.dart';
import '../entities/booking_entity.dart';
import '../entities/service_entity.dart';
import '../entities/workshop_entity.dart';

abstract class IGarageRepository {
  Future<Either<Failure, List<WorkshopEntity>>> getWorkshops();
  Future<Either<Failure, List<ServiceEntity>>> getServices({String? vehicleType});
  Future<Either<Failure, List<BookingAvailabilityEntity>>> getAvailability({
    required int workshopId,
    required String bookingDate,
  });
  Future<Either<Failure, BookingEntity>> submitBooking(BookingEntity booking);
  Future<Either<Failure, BookingEntity>> getBookingByTicket(String ticket);
}
