import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/booking_availability_entity.dart';
import '../entities/booking_entity.dart';
import '../entities/package_entity.dart';
import '../entities/regency_entity.dart';
import '../entities/service_entity.dart';
import '../entities/voucher_entity.dart';
import '../entities/workshop_entity.dart';

abstract class IGarageRepository {
  Future<Either<Failure, List<WorkshopEntity>>> getWorkshops();
  Future<Either<Failure, List<ServiceEntity>>> getServices({String? vehicleType});
  Future<Either<Failure, List<PackageEntity>>> getPackages();
  Future<Either<Failure, List<RegencyEntity>>> searchRegencies(String query);
  Future<Either<Failure, List<BookingAvailabilityEntity>>> getAvailability({
    required int workshopId,
    required String bookingDate,
  });
  Future<Either<Failure, void>> previewBooking({
    required int workshopId,
    required String bookingDate,
    required String hour,
    required String customerPhone,
    String? customerEmail,
    required List<int> serviceIds,
    required List<int> packageIds,
    required bool isEv,
  });
  Future<Either<Failure, void>> cancelPreviewBooking({
    required int workshopId,
    required String bookingDate,
    required String hour,
    required String customerPhone,
    String? customerEmail,
  });
  Future<Either<Failure, List<VoucherEntity>>> getAvailableVouchers({
    int? workshopId,
    String? date,
    String? time,
  });
  Future<Either<Failure, VoucherValidationResultEntity>> validateVoucher({
    required int voucherId,
    required String vehicleType,
    required String bookingDate,
    required String hour,
    required bool isEv,
    required int workshopId,
    required List<int> serviceIds,
    required List<int> packageIds,
  });
  Future<Either<Failure, BookingEntity>> submitBooking(BookingEntity booking);
  Future<Either<Failure, BookingEntity>> getBookingByTicket(String ticket);
}
