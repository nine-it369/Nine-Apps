import 'package:flutter_test/flutter_test.dart';
import 'package:nine_apps/core/errors/failures.dart';
import 'package:nine_apps/core/usecase/usecase.dart';
import 'package:nine_apps/features/garage/domain/entities/booking_availability_entity.dart';
import 'package:nine_apps/features/garage/domain/entities/booking_entity.dart';
import 'package:nine_apps/features/garage/domain/entities/package_entity.dart';
import 'package:nine_apps/features/garage/domain/entities/regency_entity.dart';
import 'package:nine_apps/features/garage/domain/entities/service_entity.dart';
import 'package:nine_apps/features/garage/domain/entities/voucher_entity.dart';
import 'package:nine_apps/features/garage/domain/entities/workshop_entity.dart';
import 'package:nine_apps/features/garage/domain/repositories/i_garage_repository.dart';
import 'package:nine_apps/features/garage/domain/usecases/cancel_preview_booking_usecase.dart';
import 'package:nine_apps/features/garage/domain/usecases/get_availability_usecase.dart';
import 'package:nine_apps/features/garage/domain/usecases/get_packages_usecase.dart';
import 'package:nine_apps/features/garage/domain/usecases/get_services_usecase.dart';
import 'package:nine_apps/features/garage/domain/usecases/get_vouchers_usecase.dart';
import 'package:nine_apps/features/garage/domain/usecases/get_workshops_usecase.dart';
import 'package:nine_apps/features/garage/domain/usecases/preview_booking_usecase.dart';
import 'package:nine_apps/features/garage/domain/usecases/search_regencies_usecase.dart';
import 'package:nine_apps/features/garage/domain/usecases/submit_booking_usecase.dart';
import 'package:nine_apps/features/garage/domain/usecases/validate_voucher_usecase.dart';
import 'package:nine_apps/features/garage/presentation/blocs/booking_bloc.dart';
import 'package:nine_apps/features/garage/presentation/blocs/booking_event.dart';
import 'package:nine_apps/features/garage/presentation/blocs/booking_state.dart';

class FakeGarageRepository implements IGarageRepository {
  bool previewCalled = false;
  bool submitCalled = false;

  @override
  Future<Either<Failure, List<WorkshopEntity>>> getWorkshops() async {
    return Either.right(const [
      WorkshopEntity(
        id: 1,
        name: 'Arcadia Daan Mogot',
        code: 'TGR',
        address: 'Ruko Jl. Arcadia',
        city: 'Tangerang',
      ),
    ]);
  }

  @override
  Future<Either<Failure, List<ServiceEntity>>> getServices({String? vehicleType}) async {
    return Either.right(const [
      ServiceEntity(
        id: 1,
        name: 'Jasa Single Biled',
        shortDesc: 'Pemasangan Biled',
        vehicleType: 'car',
        isEv: false,
        estimatedMinutes: 120,
        requiredTechnicians: 1,
        warrantyMonths: 3,
        price: 1200000,
        nowPrice: 600000,
      ),
    ]);
  }

  @override
  Future<Either<Failure, List<PackageEntity>>> getPackages() async {
    return Either.right(const [
      PackageEntity(
        id: 1,
        name: 'Q2 PRO - SET',
        description: 'Paket Lampu',
        price: 950000,
        nowPrice: 620000,
      ),
    ]);
  }

  @override
  Future<Either<Failure, List<RegencyEntity>>> searchRegencies(String query) async {
    return Either.right(const [
      RegencyEntity(id: 156, name: 'KOTA ADM. JAKARTA PUSAT', provinceId: 11),
    ]);
  }

  @override
  Future<Either<Failure, List<BookingAvailabilityEntity>>> getAvailability({
    required int workshopId,
    required String bookingDate,
  }) async {
    return Either.right(const [
      BookingAvailabilityEntity(hour: '13:00', status: 'available', remainingCapacity: 2),
      BookingAvailabilityEntity(hour: '14:00', status: 'full', remainingCapacity: 0),
    ]);
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
    previewCalled = true;
    return Either.right(null);
  }

  @override
  Future<Either<Failure, void>> cancelPreviewBooking({
    required int workshopId,
    required String bookingDate,
    required String hour,
    required String customerPhone,
    String? customerEmail,
  }) async {
    return Either.right(null);
  }

  @override
  Future<Either<Failure, List<VoucherEntity>>> getAvailableVouchers({
    int? workshopId,
    String? date,
    String? time,
  }) async {
    return Either.right(const [
      VoucherEntity(
        id: 1,
        code: 'GOLDENHOUR_OCT_2026',
        name: 'Golden Hour',
        discountCar: 250000,
      ),
    ]);
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
    return Either.right(const VoucherValidationResultEntity(
      valid: true,
      discountAmount: 250000,
    ));
  }

  @override
  Future<Either<Failure, BookingEntity>> submitBooking(BookingEntity booking) async {
    submitCalled = true;
    return Either.right(BookingEntity(
      id: 999,
      bookingTicket: 'TGR-20261126-TEST',
      customerName: booking.customerName,
      customerPhone: booking.customerPhone,
      custAddress: booking.custAddress,
      cityId: booking.cityId,
      vehicleType: booking.vehicleType,
      vehicleModel: booking.vehicleModel,
      vehiclePlat: booking.vehiclePlat,
      vehicleColor: booking.vehicleColor,
      workshopId: booking.workshopId,
      bookingDate: booking.bookingDate,
      hour: booking.hour,
      referralSource: booking.referralSource,
      serviceIds: booking.serviceIds,
      itemNames: const ['Jasa Single Biled'],
      subTotal: booking.subTotal,
      discountAmount: booking.discountAmount,
      totalAmount: booking.totalAmount,
      status: 'pending',
    ));
  }

  @override
  Future<Either<Failure, BookingEntity>> getBookingByTicket(String ticket) async {
    return Either.left(const ServerFailure('Not found'));
  }
}

void main() {
  test('BookingBloc full 5-step Garage module integration flow', () async {
    final repo = FakeGarageRepository();
    final bloc = BookingBloc(
      getWorkshopsUseCase: GetWorkshopsUseCase(repo),
      getServicesUseCase: GetServicesUseCase(repo),
      getPackagesUseCase: GetPackagesUseCase(repo),
      searchRegenciesUseCase: SearchRegenciesUseCase(repo),
      getAvailabilityUseCase: GetAvailabilityUseCase(repo),
      previewBookingUseCase: PreviewBookingUseCase(repo),
      cancelPreviewBookingUseCase: CancelPreviewBookingUseCase(repo),
      getVouchersUseCase: GetVouchersUseCase(repo),
      validateVoucherUseCase: ValidateVoucherUseCase(repo),
      submitBookingUseCase: SubmitBookingUseCase(repo),
    );

    bloc.add(InitBookingEvent());
    await Future.delayed(const Duration(milliseconds: 50));

    expect(bloc.state.workshops.length, 1);
    expect(bloc.state.availableServices.length, 1);
    expect(bloc.state.timeSlots.length, 2);
    expect(bloc.state.selectedHour, '13:00');

    // Step 1: Contact & Regency
    bloc.add(const UpdateContactEvent(
      name: 'Budi Santoso',
      phone: '081234567890',
      address: 'Jl. Kebon Jeruk No 12',
    ));
    bloc.add(const SearchRegencyEvent('Jakarta'));
    await Future.delayed(const Duration(milliseconds: 20));
    expect(bloc.state.regencyResults.length, 1);
    bloc.add(SelectRegencyEvent(bloc.state.regencyResults.first));
    await Future.delayed(const Duration(milliseconds: 20));
    expect(bloc.state.isStep1Valid, isTrue);
    bloc.add(NextStepEvent());
    await Future.delayed(const Duration(milliseconds: 20));
    expect(bloc.state.currentStep, 2);

    // Step 2: Vehicle
    bloc.add(const UpdateVehicleEvent(
      vehicleType: 'car',
      model: 'Toyota Innova Zenix',
      plat: 'B 1234 NNE',
      color: 'Hitam',
    ));
    await Future.delayed(const Duration(milliseconds: 20));
    expect(bloc.state.isStep2Valid, isTrue);
    bloc.add(NextStepEvent());
    await Future.delayed(const Duration(milliseconds: 20));
    expect(bloc.state.currentStep, 3);

    // Step 3: Service Selection
    bloc.add(ToggleServiceSelectionEvent(bloc.state.availableServices.first));
    await Future.delayed(const Duration(milliseconds: 20));
    expect(bloc.state.isStep3Valid, isTrue);
    expect(bloc.state.subTotal, 600000);
    bloc.add(NextStepEvent());
    await Future.delayed(const Duration(milliseconds: 20));
    expect(bloc.state.currentStep, 4);

    // Step 4 -> Step 5 (triggers preview lock & vouchers load)
    bloc.add(NextStepEvent());
    await Future.delayed(const Duration(milliseconds: 50));
    expect(repo.previewCalled, isTrue);
    expect(bloc.state.currentStep, 5);
    expect(bloc.state.availableVouchers.length, 1);

    // Step 5: Apply voucher & Submit
    bloc.add(ApplyVoucherEvent(bloc.state.availableVouchers.first));
    await Future.delayed(const Duration(milliseconds: 30));
    expect(bloc.state.voucherDiscount, 250000);
    expect(bloc.state.totalAmount, 350000);

    bloc.add(SubmitBookingEvent());
    await Future.delayed(const Duration(milliseconds: 30));
    expect(repo.submitCalled, isTrue);
    expect(bloc.state.submissionStatus, BookingSubmissionStatus.success);
    expect(bloc.state.submittedBooking?.bookingTicket, 'TGR-20261126-TEST');

    await bloc.close();
  });
}
