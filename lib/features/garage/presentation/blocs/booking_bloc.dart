import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/date_time_utils.dart';
import '../../../../core/utils/input_validators.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/entities/voucher_entity.dart';
import '../../domain/usecases/cancel_preview_booking_usecase.dart';
import '../../domain/usecases/get_availability_usecase.dart';
import '../../domain/usecases/get_packages_usecase.dart';
import '../../domain/usecases/get_services_usecase.dart';
import '../../domain/usecases/get_vouchers_usecase.dart';
import '../../domain/usecases/get_workshops_usecase.dart';
import '../../domain/usecases/preview_booking_usecase.dart';
import '../../domain/usecases/search_regencies_usecase.dart';
import '../../domain/usecases/submit_booking_usecase.dart';
import '../../domain/usecases/validate_voucher_usecase.dart';
import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final GetWorkshopsUseCase getWorkshopsUseCase;
  final GetServicesUseCase getServicesUseCase;
  final GetPackagesUseCase getPackagesUseCase;
  final SearchRegenciesUseCase searchRegenciesUseCase;
  final GetAvailabilityUseCase getAvailabilityUseCase;
  final PreviewBookingUseCase previewBookingUseCase;
  final CancelPreviewBookingUseCase cancelPreviewBookingUseCase;
  final GetVouchersUseCase getVouchersUseCase;
  final ValidateVoucherUseCase validateVoucherUseCase;
  final SubmitBookingUseCase submitBookingUseCase;

  Timer? _reviewTimer;

  BookingBloc({
    required this.getWorkshopsUseCase,
    required this.getServicesUseCase,
    required this.getPackagesUseCase,
    required this.searchRegenciesUseCase,
    required this.getAvailabilityUseCase,
    required this.previewBookingUseCase,
    required this.cancelPreviewBookingUseCase,
    required this.getVouchersUseCase,
    required this.validateVoucherUseCase,
    required this.submitBookingUseCase,
  }) : super(const BookingState()) {
    on<InitBookingEvent>(_onInit);
    on<GoToStepEvent>(_onGoToStep);
    on<NextStepEvent>(_onNextStep);
    on<PrevStepEvent>(_onPrevStep);
    on<UpdateContactEvent>(_onUpdateContact);
    on<SearchRegencyEvent>(_onSearchRegency);
    on<SelectRegencyEvent>(_onSelectRegency);
    on<UpdateVehicleEvent>(_onUpdateVehicle);
    on<ToggleServiceSelectionEvent>(_onToggleService);
    on<TogglePackageSelectionEvent>(_onTogglePackage);
    on<SelectWorkshopEvent>(_onSelectWorkshop);
    on<SelectDateEvent>(_onSelectDate);
    on<SelectTimeSlotEvent>(_onSelectTimeSlot);
    on<ApplyVoucherEvent>(_onApplyVoucher);
    on<ApplyVoucherCodeEvent>(_onApplyVoucherCode);
    on<RemoveVoucherEvent>(_onRemoveVoucher);
    on<TickReviewTimerEvent>(_onTickReviewTimer);
    on<SubmitBookingEvent>(_onSubmitBooking);
  }

  @override
  Future<void> close() {
    _reviewTimer?.cancel();
    return super.close();
  }

  void _startReviewTimer() {
    _reviewTimer?.cancel();
    _reviewTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!isClosed) {
        add(TickReviewTimerEvent());
      }
    });
  }

  void _stopReviewTimer() {
    _reviewTimer?.cancel();
    _reviewTimer = null;
  }

  Future<void> _onInit(InitBookingEvent event, Emitter<BookingState> emit) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    final workshopsResult = await getWorkshopsUseCase(const NoParams());
    final servicesResult = await getServicesUseCase(
      GetServicesParams(vehicleType: state.vehicleType),
    );
    final packagesResult = await getPackagesUseCase(const NoParams());

    workshopsResult.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      )),
      (workshops) {
        final services = servicesResult.fold((_) => state.availableServices, (s) => s);
        final packages = packagesResult.fold((_) => state.availablePackages, (p) => p);

        final defaultWorkshop = workshops.isNotEmpty ? workshops.first : null;
        final defaultDate = DateTime.now().add(const Duration(days: 1));

        emit(state.copyWith(
          isLoading: false,
          workshops: workshops,
          availableServices: services,
          availablePackages: packages,
          selectedWorkshop: defaultWorkshop,
          selectedDate: defaultDate,
        ));

        if (defaultWorkshop != null) {
          add(SelectDateEvent(defaultDate));
        }
      },
    );
  }

  Future<void> _onGoToStep(GoToStepEvent event, Emitter<BookingState> emit) async {
    if (event.step >= 1 && event.step <= 5) {
      if (state.currentStep == 5 && event.step < 5) {
        await _releaseCurrentPreviewLock();
      }
      emit(state.copyWith(currentStep: event.step, clearError: true));
    }
  }

  Future<void> _onNextStep(NextStepEvent event, Emitter<BookingState> emit) async {
    if (state.currentStep >= 5 || !state.canProceed(state.currentStep)) {
      return;
    }

    // Moving from Step 4 (Schedule) -> Step 5 (Review) triggers 3-min slot preview lock + vouchers load
    if (state.currentStep == 4 &&
        state.selectedWorkshop != null &&
        state.selectedDate != null &&
        state.selectedHour != null) {
      emit(state.copyWith(isLockingSlot: true, clearError: true));

      final dateStr = DateTimeUtils.formatForApi(state.selectedDate!);
      final phone = InputValidators.normalizePhoneForBackend(state.customerPhone);

      final lockResult = await previewBookingUseCase(PreviewBookingParams(
        workshopId: state.selectedWorkshop!.id,
        bookingDate: dateStr,
        hour: state.selectedHour!,
        customerPhone: phone,
        customerEmail: state.customerEmail.trim().isNotEmpty ? state.customerEmail.trim() : null,
        serviceIds: state.selectedServices.map((s) => s.id).toList(),
        packageIds: state.selectedPackages.map((p) => p.id).toList(),
        isEv: state.isEv,
      ));

      final vouchersResult = await getVouchersUseCase(GetVouchersParams(
        workshopId: state.selectedWorkshop!.id,
        date: dateStr,
        time: state.selectedHour,
      ));
      final vouchers = vouchersResult.fold((_) => <VoucherEntity>[], (v) => v);

      lockResult.fold(
        (failure) {
          emit(state.copyWith(
            isLockingSlot: false,
            errorMessage: failure.message,
          ));
        },
        (_) {
          emit(state.copyWith(
            isLockingSlot: false,
            currentStep: 5,
            reviewSecondsRemaining: 180,
            availableVouchers: vouchers,
            clearError: true,
          ));
          _startReviewTimer();
        },
      );
      return;
    }

    emit(state.copyWith(currentStep: state.currentStep + 1, clearError: true));
  }

  Future<void> _onPrevStep(PrevStepEvent event, Emitter<BookingState> emit) async {
    if (state.currentStep > 1) {
      if (state.currentStep == 5) {
        await _releaseCurrentPreviewLock();
      }
      emit(state.copyWith(currentStep: state.currentStep - 1, clearError: true));
    }
  }

  Future<void> _releaseCurrentPreviewLock() async {
    _stopReviewTimer();
    if (state.selectedWorkshop != null &&
        state.selectedDate != null &&
        state.selectedHour != null) {
      await cancelPreviewBookingUseCase(CancelPreviewParams(
        workshopId: state.selectedWorkshop!.id,
        bookingDate: DateTimeUtils.formatForApi(state.selectedDate!),
        hour: state.selectedHour!,
        customerPhone: InputValidators.normalizePhoneForBackend(state.customerPhone),
        customerEmail: state.customerEmail.trim().isNotEmpty ? state.customerEmail.trim() : null,
      ));
    }
  }

  void _onTickReviewTimer(TickReviewTimerEvent event, Emitter<BookingState> emit) {
    if (state.currentStep != 5) {
      _stopReviewTimer();
      return;
    }
    if (state.reviewSecondsRemaining <= 1) {
      _stopReviewTimer();
      emit(state.copyWith(
        currentStep: 4,
        reviewSecondsRemaining: 0,
        clearSelectedHour: true,
        errorMessage: 'Waktu penahanan slot (3 menit) telah habis. Silakan pilih kembali jam kedatangan Anda.',
      ));
      if (state.selectedDate != null) {
        add(SelectDateEvent(state.selectedDate!));
      }
    } else {
      emit(state.copyWith(reviewSecondsRemaining: state.reviewSecondsRemaining - 1));
    }
  }

  void _onUpdateContact(UpdateContactEvent event, Emitter<BookingState> emit) {
    emit(state.copyWith(
      customerName: event.name ?? state.customerName,
      customerPhone: event.phone ?? state.customerPhone,
      customerEmail: event.email ?? state.customerEmail,
      custAddress: event.address ?? state.custAddress,
      referralSource: event.referralSource ?? state.referralSource,
      hasVisited: event.hasVisited ?? state.hasVisited,
      notes: event.notes ?? state.notes,
      clearError: true,
    ));
  }

  Future<void> _onSearchRegency(SearchRegencyEvent event, Emitter<BookingState> emit) async {
    if (event.query.trim().length < 2) {
      emit(state.copyWith(regencyResults: const []));
      return;
    }
    final result = await searchRegenciesUseCase(event.query);
    result.fold(
      (_) => emit(state.copyWith(regencyResults: const [])),
      (list) => emit(state.copyWith(regencyResults: list)),
    );
  }

  void _onSelectRegency(SelectRegencyEvent event, Emitter<BookingState> emit) {
    emit(state.copyWith(
      cityId: event.regency.id,
      cityName: event.regency.name,
      regencyResults: const [],
      clearError: true,
    ));
  }

  Future<void> _onUpdateVehicle(UpdateVehicleEvent event, Emitter<BookingState> emit) async {
    final typeChanged = event.vehicleType != null && event.vehicleType != state.vehicleType;
    emit(state.copyWith(
      vehicleType: event.vehicleType ?? state.vehicleType,
      isEv: event.isEv ?? state.isEv,
      vehicleModel: event.model ?? state.vehicleModel,
      vehiclePlat: event.plat ?? state.vehiclePlat,
      vehicleColor: event.color ?? state.vehicleColor,
      clearError: true,
    ));

    if (typeChanged) {
      final servicesResult = await getServicesUseCase(
        GetServicesParams(vehicleType: event.vehicleType),
      );
      servicesResult.fold(
        (_) => null,
        (services) => emit(state.copyWith(
          availableServices: services,
          selectedServices: const [],
        )),
      );
    }
  }

  void _onToggleService(ToggleServiceSelectionEvent event, Emitter<BookingState> emit) {
    final current = List.of(state.selectedServices);
    if (current.any((s) => s.id == event.service.id)) {
      current.removeWhere((s) => s.id == event.service.id);
    } else {
      current.add(event.service);
    }
    emit(state.copyWith(selectedServices: current, clearVoucher: true, clearError: true));
  }

  void _onTogglePackage(TogglePackageSelectionEvent event, Emitter<BookingState> emit) {
    final current = List.of(state.selectedPackages);
    if (current.any((p) => p.id == event.package.id)) {
      current.removeWhere((p) => p.id == event.package.id);
    } else {
      current.add(event.package);
    }
    emit(state.copyWith(selectedPackages: current, clearVoucher: true, clearError: true));
  }

  Future<void> _onSelectWorkshop(SelectWorkshopEvent event, Emitter<BookingState> emit) async {
    emit(state.copyWith(
      selectedWorkshop: event.workshop,
      clearSelectedHour: true,
      clearError: true,
    ));
    if (state.selectedDate != null) {
      await _fetchAvailability(event.workshop.id, state.selectedDate!, emit);
    }
  }

  Future<void> _onSelectDate(SelectDateEvent event, Emitter<BookingState> emit) async {
    emit(state.copyWith(
      selectedDate: event.date,
      clearSelectedHour: true,
      clearError: true,
    ));
    if (state.selectedWorkshop != null) {
      await _fetchAvailability(state.selectedWorkshop!.id, event.date, emit);
    }
  }

  Future<void> _fetchAvailability(
    int workshopId,
    DateTime date,
    Emitter<BookingState> emit,
  ) async {
    final formattedDate = DateTimeUtils.formatForApi(date);
    final result = await getAvailabilityUseCase(GetAvailabilityParams(
      workshopId: workshopId,
      bookingDate: formattedDate,
    ));

    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (slots) {
        final firstAvailable = slots.where((s) => s.isAvailable).firstOrNull?.hour;
        emit(state.copyWith(
          timeSlots: slots,
          selectedHour: firstAvailable,
        ));
      },
    );
  }

  void _onSelectTimeSlot(SelectTimeSlotEvent event, Emitter<BookingState> emit) {
    emit(state.copyWith(selectedHour: event.hour, clearError: true));
  }

  Future<void> _onApplyVoucher(ApplyVoucherEvent event, Emitter<BookingState> emit) async {
    if (state.selectedWorkshop == null ||
        state.selectedDate == null ||
        state.selectedHour == null) {
      return;
    }

    emit(state.copyWith(isValidatingVoucher: true, clearError: true));
    final result = await validateVoucherUseCase(ValidateVoucherParams(
      voucherId: event.voucher.id,
      vehicleType: state.vehicleType,
      bookingDate: DateTimeUtils.formatForApi(state.selectedDate!),
      hour: state.selectedHour!,
      isEv: state.isEv,
      workshopId: state.selectedWorkshop!.id,
      serviceIds: state.selectedServices.map((s) => s.id).toList(),
      packageIds: state.selectedPackages.map((p) => p.id).toList(),
    ));

    result.fold(
      (failure) => emit(state.copyWith(
        isValidatingVoucher: false,
        errorMessage: failure.message,
      )),
      (validation) {
        if (validation.valid) {
          emit(state.copyWith(
            isValidatingVoucher: false,
            appliedVoucher: event.voucher,
            voucherDiscount: validation.discountAmount,
          ));
        } else {
          emit(state.copyWith(
            isValidatingVoucher: false,
            errorMessage: validation.reason?.isNotEmpty == true
                ? validation.reason
                : 'Voucher "${event.voucher.code}" tidak memenuhi syarat untuk layanan yang dipilih.',
          ));
        }
      },
    );
  }

  Future<void> _onApplyVoucherCode(ApplyVoucherCodeEvent event, Emitter<BookingState> emit) async {
    final code = event.code.trim().toUpperCase();
    final matched = state.availableVouchers
        .where((v) => v.code.toUpperCase() == code)
        .firstOrNull;
    if (matched == null) {
      emit(state.copyWith(
        errorMessage: 'Kode voucher "$code" tidak ditemukan atau belum tersedia untuk jadwal ini.',
      ));
      return;
    }
    add(ApplyVoucherEvent(matched));
  }

  void _onRemoveVoucher(RemoveVoucherEvent event, Emitter<BookingState> emit) {
    emit(state.copyWith(clearVoucher: true, clearError: true));
  }

  Future<void> _onSubmitBooking(SubmitBookingEvent event, Emitter<BookingState> emit) async {
    if (!state.canProceed(5)) {
      emit(state.copyWith(
        errorMessage: 'Mohon lengkapi seluruh data reservasi sebelum konfirmasi.',
      ));
      return;
    }

    emit(state.copyWith(
      submissionStatus: BookingSubmissionStatus.submitting,
      clearError: true,
    ));

    final bookingDateStr = DateTimeUtils.formatForApi(state.selectedDate!);
    final normalizedPhone = InputValidators.normalizePhoneForBackend(state.customerPhone);

    final bookingPayload = BookingEntity(
      customerName: state.customerName.trim(),
      customerPhone: normalizedPhone,
      customerEmail: state.customerEmail.trim(),
      custAddress: state.custAddress.trim(),
      cityId: state.cityId,
      cityName: state.cityName,
      vehicleType: state.vehicleType,
      vehicleModel: state.vehicleModel.trim(),
      vehiclePlat: state.vehiclePlat.trim().toUpperCase(),
      vehicleColor: state.vehicleColor.trim(),
      isEv: state.isEv,
      workshopId: state.selectedWorkshop!.id,
      workshopName: state.selectedWorkshop!.name,
      bookingDate: bookingDateStr,
      endDate: bookingDateStr,
      isMultiDay: false,
      hour: state.selectedHour!,
      hasVisited: state.hasVisited,
      referralSource: state.referralSource,
      purchaseSource: 'online',
      serviceIds: state.selectedServices.map((s) => s.id).toList(),
      packageIds: state.selectedPackages.map((p) => p.id).toList(),
      voucherId: state.appliedVoucher?.id,
      voucherCode: state.appliedVoucher?.code,
      subTotal: state.subTotal,
      discountAmount: state.voucherDiscount,
      totalAmount: state.totalAmount,
      estimatedMinutes: state.estimatedMinutes,
      notes: state.notes.trim().isNotEmpty ? state.notes.trim() : null,
    );

    final result = await submitBookingUseCase(bookingPayload);

    result.fold(
      (failure) {
        emit(state.copyWith(
          submissionStatus: BookingSubmissionStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (submitted) {
        _stopReviewTimer();
        emit(state.copyWith(
          submissionStatus: BookingSubmissionStatus.success,
          submittedBooking: submitted,
        ));
      },
    );
  }
}
