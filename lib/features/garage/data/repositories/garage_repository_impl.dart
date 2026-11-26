import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/error_sanitizer.dart';
import '../../domain/entities/booking_availability_entity.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/entities/package_entity.dart';
import '../../domain/entities/regency_entity.dart';
import '../../domain/entities/service_entity.dart';
import '../../domain/entities/voucher_entity.dart';
import '../../domain/entities/workshop_entity.dart';
import '../../domain/repositories/i_garage_repository.dart';
import '../datasources/garage_remote_datasource.dart';
import '../models/booking_model.dart';

class GarageRepositoryImpl implements IGarageRepository {
  final IGarageRemoteDataSource remoteDataSource;

  GarageRepositoryImpl(this.remoteDataSource);

  Failure _mapExceptionToFailure(Object error) {
    if (error is DioException) {
      final inner = error.error;
      if (inner is NetworkException) {
        return NetworkFailure(inner.message);
      }
      if (inner is ServerException) {
        return ServerFailure(inner.message, inner.statusCode);
      }
      return ServerFailure(ErrorSanitizer.sanitize(error.message));
    }
    if (error is NetworkException) {
      return NetworkFailure(error.message);
    }
    if (error is ServerException) {
      return ServerFailure(error.message, error.statusCode);
    }
    return ServerFailure(ErrorSanitizer.sanitize(error));
  }

  @override
  Future<Either<Failure, List<WorkshopEntity>>> getWorkshops() async {
    try {
      final result = await remoteDataSource.getWorkshops();
      return Either.right(result);
    } catch (e) {
      return Either.left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<ServiceEntity>>> getServices({String? vehicleType}) async {
    try {
      final result = await remoteDataSource.getServices(vehicleType: vehicleType);
      return Either.right(result);
    } catch (e) {
      return Either.left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<PackageEntity>>> getPackages() async {
    try {
      final result = await remoteDataSource.getPackages();
      return Either.right(result);
    } catch (e) {
      return Either.left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<RegencyEntity>>> searchRegencies(String query) async {
    try {
      final result = await remoteDataSource.searchRegencies(query);
      return Either.right(result);
    } catch (e) {
      return Either.left(_mapExceptionToFailure(e));
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
    } catch (e) {
      return Either.left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> previewBooking({
    required int workshopId,
    required String bookingDate,
    required String hour,
    required String customerPhone,
    String? customerEmail,
    required List<int> serviceIds,
    required List<int> packageIds,
    required bool isEv,
  }) async {
    try {
      await remoteDataSource.previewBooking(
        workshopId: workshopId,
        bookingDate: bookingDate,
        hour: hour,
        customerPhone: customerPhone,
        customerEmail: customerEmail,
        serviceIds: serviceIds,
        packageIds: packageIds,
        isEv: isEv,
      );
      return Either.right(null);
    } catch (e) {
      return Either.left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> cancelPreviewBooking({
    required int workshopId,
    required String bookingDate,
    required String hour,
    required String customerPhone,
    String? customerEmail,
  }) async {
    try {
      await remoteDataSource.cancelPreviewBooking(
        workshopId: workshopId,
        bookingDate: bookingDate,
        hour: hour,
        customerPhone: customerPhone,
        customerEmail: customerEmail,
      );
      return Either.right(null);
    } catch (e) {
      return Either.left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<VoucherEntity>>> getAvailableVouchers({
    int? workshopId,
    String? date,
    String? time,
  }) async {
    try {
      final result = await remoteDataSource.getAvailableVouchers(
        workshopId: workshopId,
        date: date,
        time: time,
      );
      return Either.right(result);
    } catch (e) {
      return Either.left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, VoucherValidationResultEntity>> validateVoucher({
    required int voucherId,
    required String vehicleType,
    required String bookingDate,
    required String hour,
    required bool isEv,
    required int workshopId,
    required List<int> serviceIds,
    required List<int> packageIds,
  }) async {
    try {
      final result = await remoteDataSource.validateVoucher(
        voucherId: voucherId,
        vehicleType: vehicleType,
        bookingDate: bookingDate,
        hour: hour,
        isEv: isEv,
        workshopId: workshopId,
        serviceIds: serviceIds,
        packageIds: packageIds,
      );
      return Either.right(result);
    } catch (e) {
      return Either.left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> submitBooking(BookingEntity booking) async {
    try {
      final model = BookingModel.fromEntity(booking);
      final result = await remoteDataSource.submitBooking(model);
      return Either.right(result);
    } catch (e) {
      return Either.left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> getBookingByTicket(String ticket) async {
    try {
      final result = await remoteDataSource.getBookingByTicket(ticket);
      return Either.right(result);
    } catch (e) {
      return Either.left(_mapExceptionToFailure(e));
    }
  }
}
