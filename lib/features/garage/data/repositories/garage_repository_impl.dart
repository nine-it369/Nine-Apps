import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/booking_availability_entity.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/entities/service_entity.dart';
import '../../domain/entities/workshop_entity.dart';
import '../../domain/repositories/i_garage_repository.dart';
import '../datasources/garage_remote_datasource.dart';
import '../models/booking_model.dart';

class GarageRepositoryImpl implements IGarageRepository {
  final IGarageRemoteDataSource remoteDataSource;

  GarageRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<WorkshopEntity>>> getWorkshops() async {
    try {
      final result = await remoteDataSource.getWorkshops();
      return Either.right(result);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message, e.statusCode));
    } on NetworkException catch (e) {
      return Either.left(NetworkFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ServiceEntity>>> getServices({String? vehicleType}) async {
    try {
      final result = await remoteDataSource.getServices(vehicleType: vehicleType);
      return Either.right(result);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message, e.statusCode));
    } on NetworkException catch (e) {
      return Either.left(NetworkFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BookingAvailabilityEntity>>> getAvailability({
    required int workshopId,
    required String bookingDate,
  }) async {
    try {
      final result = await remoteDataSource.getAvailability(
        workshopId: workshopId,
        bookingDate: bookingDate,
      );
      return Either.right(result);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message, e.statusCode));
    } on NetworkException catch (e) {
      return Either.left(NetworkFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> submitBooking(BookingEntity booking) async {
    try {
      final model = BookingModel(
        customerName: booking.customerName,
        customerPhone: booking.customerPhone,
        customerEmail: booking.customerEmail,
        address: booking.address,
        vehicleCategory: booking.vehicleCategory,
        vehicleBrand: booking.vehicleBrand,
        vehicleModel: booking.vehicleModel,
        vehicleYear: booking.vehicleYear,
        licensePlate: booking.licensePlate,
        transmissionType: booking.transmissionType,
        workshopId: booking.workshopId,
        bookingDate: booking.bookingDate,
        timeSlot: booking.timeSlot,
        serviceIds: booking.serviceIds,
        voucherCode: booking.voucherCode,
        subtotalPrice: booking.subtotalPrice,
        discountAmount: booking.discountAmount,
        totalPrice: booking.totalPrice,
        estimatedDurationMinutes: booking.estimatedDurationMinutes,
        notes: booking.notes,
      );
      final result = await remoteDataSource.submitBooking(model);
      return Either.right(result);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message, e.statusCode));
    } on NetworkException catch (e) {
      return Either.left(NetworkFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> getBookingByTicket(String ticket) async {
    try {
      final result = await remoteDataSource.getBookingByTicket(ticket);
      return Either.right(result);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message, e.statusCode));
    } on NetworkException catch (e) {
      return Either.left(NetworkFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }
}
