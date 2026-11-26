import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/date_time_utils.dart';
import '../../../../core/utils/input_validators.dart';
import '../../data/datasources/garage_sse_datasource.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/entities/booking_variant_item_entity.dart';
import '../../domain/entities/voucher_entity.dart';
import '../../domain/usecases/cancel_preview_booking_usecase.dart';
import '../../domain/usecases/get_availability_usecase.dart';
import '../../domain/usecases/get_booking_by_ticket_usecase.dart';
import '../../domain/usecases/get_packages_usecase.dart';
import '../../domain/usecases/get_services_usecase.dart';
import '../../domain/usecases/get_variants_usecase.dart';
import '../../domain/usecases/get_vouchers_usecase.dart';
import '../../domain/usecases/get_workshops_usecase.dart';
import '../../domain/usecases/preview_booking_usecase.dart';
import '../../domain/usecases/search_regencies_usecase.dart';
import '../../domain/usecases/submit_booking_usecase.dart';
import '../../domain/usecases/update_booking_usecase.dart';
import '../../domain/usecases/validate_voucher_usecase.dart';
import '../../domain/utils/duration_calculator.dart';
import '../../domain/utils/package_notes_builder.dart';
import '../../domain/utils/slot_calculator.dart';
import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final GetWorkshopsUseCase getWorkshopsUseCase;
  final GetServicesUseCase getServicesUseCase;
  final GetPackagesUseCase getPackagesUseCase;
  final GetVariantsUseCase getVariantsUseCase;
  final SearchRegenciesUseCase searchRegenciesUseCase;
  final GetAvailabilityUseCase getAvailabilityUseCase;
  final PreviewBookingUseCase previewBookingUseCase;
  final CancelPreviewBookingUseCase cancelPreviewBookingUseCase;
  final GetVouchersUseCase getVouchersUseCase;
  final ValidateVoucherUseCase validateVoucherUseCase;
  final SubmitBookingUseCase submitBookingUseCase;
  final UpdateBookingUseCase updateBookingUseCase;
  final GetBookingByTicketUseCase getBookingByTicketUseCase;
  final IGarageSseDataSource sseDataSource;

  Timer? _reviewTimer;
  StreamSubscription<BookingSseEvent>? _sseSubscription;

  BookingBloc({
    required this.getWorkshopsUseCase,
    required this.getServicesUseCase,
    required this.getPackagesUseCase,
    required this.getVariantsUseCase,
    required this.searchRegenciesUseCase,
    required this.getAvailabilityUseCase,
    required this.previewBookingUseCase,
    required this.cancelPreviewBookingUseCase,
    required this.getVouchersUseCase,
    required this.validateVoucherUseCase,
    required this.submitBookingUseCase,
    required this.updateBookingUseCase,
    required this.getBookingByTicketUseCase,
    required this.sseDataSource,
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
    on<ToggleVariantSelectionEvent>(_onToggleVariant);
    on<SelectPackageChildEvent>(_onSelectPackageChild);
    on<ToggleApplyDiscountEvent>(_onToggleApplyDiscount);
    on<SelectWorkshopEvent>(_onSelectWorkshop);
    on<SelectDateEvent>(_onSelectDate);
    on<SelectTimeSlotEvent>(_onSelectTimeSlot);
    on<ApplyVoucherEvent>(_onApplyVoucher);
    on<ApplyVoucherCodeEvent>(_onApplyVoucherCode);
    on<RemoveVoucherEvent>(_onRemoveVoucher);
    on<TickReviewTimerEvent>(_onTickReviewTimer);
    on<SubmitBookingEvent>(_onSubmitBooking);
    on<LoadBookingForEditEvent>(_onLoadBookingForEdit);
    on<BookingSseUpdateReceivedEvent>(_onSseUpdateReceived);
  }

  @override
  Future<void> close() {
    _reviewTimer?.cancel();
    _sseSubscription?.cancel();
    sseDataSource.unsubscribe();
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
    final variantsResult = await getVariantsUseCase(
      GetVariantsParams(
        vehicleType: state.vehicleType,
        isEv: state.isEv,
      ),
    );

    workshopsResult.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      )),
      (workshops) {
        final services = servicesResult.fold((_) => state.availableServices, (s) => s);
        final packages = packagesResult.fold((_) => state.availablePackages, (p) => p);
        final variants = variantsResult.fold((_) => state.availableVariants, (v) => v);

        final defaultWorkshop = workshops.isNotEmpty ? workshops.first : null;
        final defaultDate = DateTime.now().add(const Duration(days: 1));

        emit(state.copyWith(
          isLoading: false,
          workshops: workshops,
          availableServices: services,
          availablePackages: packages,
          availableVariants: variants,
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
    final evChanged = event.isEv != null && event.isEv != state.isEv;

    emit(state.copyWith(
      vehicleType: event.vehicleType ?? state.vehicleType,
      isEv: event.isEv ?? state.isEv,
      vehicleModel: event.model ?? state.vehicleModel,
      vehiclePlat: event.plat ?? state.vehiclePlat,
      vehicleColor: event.color ?? state.vehicleColor,
      clearError: true,
    ));

    if (typeChanged || evChanged) {
      final servicesResult = await getServicesUseCase(
        GetServicesParams(vehicleType: event.vehicleType ?? state.vehicleType),
      );
      final variantsResult = await getVariantsUseCase(
        GetVariantsParams(
          vehicleType: event.vehicleType ?? state.vehicleType,
          isEv: event.isEv ?? state.isEv,
          workshopId: state.selectedWorkshop?.id,
        ),
      );

      final services = servicesResult.fold((_) => state.availableServices, (s) => s);
      final variants = variantsResult.fold((_) => state.availableVariants, (v) => v);

      emit(state.copyWith(
        availableServices: services,
        availableVariants: variants,
        selectedServices: const [],
        selectedVariants: const [],
        selectedPackageChildren: const {},
      ));
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
    final currentChildren = Map<int, Map<int, int>>.from(state.selectedPackageChildren);

    if (current.any((p) => p.id == event.package.id)) {
      current.removeWhere((p) => p.id == event.package.id);
      currentChildren.remove(event.package.id);
    } else {
      current.add(event.package);
    }
    emit(state.copyWith(
      selectedPackages: current,
      selectedPackageChildren: currentChildren,
      clearVoucher: true,
      clearError: true,
    ));
  }

  void _onToggleVariant(ToggleVariantSelectionEvent event, Emitter<BookingState> emit) {
    final current = List<BookingVariantItemEntity>.from(state.selectedVariants);
    final exists = current.indexWhere((v) => v.variantId == event.variant.id && v.packageId == null);

    if (exists != -1) {
      current.removeAt(exists);
    } else {
      final reqService = event.variant.requiredServices.firstOrNull;
      current.add(BookingVariantItemEntity(
        variantId: event.variant.id,
        qty: 1,
        withInstallation: event.withInstallation,
        serviceId: event.withInstallation ? reqService?.serviceId : null,
        servicePrice: event.withInstallation ? (reqService?.servicePrice ?? event.variant.installationPrice) : 0,
        serviceDiscPrice: event.withInstallation ? (reqService?.serviceDiscPrice ?? event.variant.installationPricePromo) : 0,
        serviceName: event.withInstallation ? reqService?.serviceName : null,
        variantName: event.variant.name,
        price: event.variant.price,
        discPrice: event.variant.discPrice,
      ));
    }

    emit(state.copyWith(selectedVariants: current, clearVoucher: true, clearError: true));
  }

  void _onSelectPackageChild(SelectPackageChildEvent event, Emitter<BookingState> emit) {
    final currentChildren = Map<int, Map<int, int>>.from(state.selectedPackageChildren);
    currentChildren[event.packageId] ??= {};
    currentChildren[event.packageId]![event.parentVariantId] = event.childVariantId;

    // Sinkronisasi ke variant_items dengan package_id
    final currentVariants = List<BookingVariantItemEntity>.from(state.selectedVariants);
    currentVariants.removeWhere((v) => v.packageId == event.packageId && v.variantId == event.parentVariantId);
    currentVariants.add(BookingVariantItemEntity(
      variantId: event.childVariantId,
      qty: 1,
      packageId: event.packageId,
    ));

    emit(state.copyWith(
      selectedPackageChildren: currentChildren,
      selectedVariants: currentVariants,
      clearError: true,
    ));
  }

  void _onToggleApplyDiscount(ToggleApplyDiscountEvent event, Emitter<BookingState> emit) {
    emit(state.copyWith(applyDiscount: event.applyDiscount, clearError: true));
  }

  Future<void> _onSelectWorkshop(SelectWorkshopEvent event, Emitter<BookingState> emit) async {
    emit(state.copyWith(
      selectedWorkshop: event.workshop,
      clearSelectedHour: true,
      clearError: true,
    ));

    // Update variants to include stock at this workshop
    final variantsResult = await getVariantsUseCase(GetVariantsParams(
      workshopId: event.workshop.id,
      vehicleType: state.vehicleType,
      isEv: state.isEv,
    ));
    variantsResult.fold(
      (_) => null,
      (variants) => emit(state.copyWith(availableVariants: variants)),
    );

    if (state.selectedDate != null) {
      await _fetchAvailability(event.workshop.id, state.selectedDate!, emit);
    }
  }

  Future<void> _onSelectDate(SelectDateEvent event, Emitter<BookingState> emit) async {
    final startDateStr = DateTimeUtils.formatForApi(event.date);
    final rollover = DurationCalculator.calculateEndDate(
      startDateStr: startDateStr,
      totalEstimatedMinutes: state.estimatedMinutes,
      startHourStr: state.selectedHour,
      hasBiled: state.hasBiledService,
    );

    emit(state.copyWith(
      selectedDate: event.date,
      endDate: rollover.endDate,
      isMultiDay: rollover.isMultiDay,
      clearSelectedHour: true,
      clearError: true,
    ));

    if (state.selectedWorkshop != null) {
      await _fetchAvailability(state.selectedWorkshop!.id, event.date, emit);
      _subscribeSse(state.selectedWorkshop!.id, startDateStr);
    }
  }

  void _subscribeSse(int workshopId, String bookingDate) {
    _sseSubscription?.cancel();
    _sseSubscription = sseDataSource.subscribeToUpdates(
      workshopId: workshopId,
      bookingDate: bookingDate,
    ).listen((_) {
      if (!isClosed) {
        add(BookingSseUpdateReceivedEvent());
      }
    });
  }

  void _onSseUpdateReceived(BookingSseUpdateReceivedEvent event, Emitter<BookingState> emit) {
    if (state.selectedWorkshop != null && state.selectedDate != null) {
      _fetchAvailability(state.selectedWorkshop!.id, state.selectedDate!, emit);
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
      excludeTicket: state.isEditing ? state.editingTicket : null,
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
    final validation = SlotCalculator.validateConsecutiveSlots(
      startHour: event.hour,
      availability: state.timeSlots,
      totalMinutes: state.estimatedMinutes,
      techniciansNeeded: state.requiredTechnicians,
    );

    if (!validation.isValid) {
      emit(state.copyWith(
        slotConflict: validation,
        errorMessage: 'Jadwal teknisi penuh atau slot waktu tidak tersedia secara berurutan.',
      ));
      return;
    }

    final startDateStr = DateTimeUtils.formatForApi(state.selectedDate!);
    final rollover = DurationCalculator.calculateEndDate(
      startDateStr: startDateStr,
      totalEstimatedMinutes: state.estimatedMinutes,
      startHourStr: event.hour,
      hasBiled: state.hasBiledService,
    );

    emit(state.copyWith(
      selectedHour: event.hour,
      endDate: rollover.endDate,
      isMultiDay: rollover.isMultiDay,
      clearSlotConflict: true,
      clearError: true,
    ));
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

  Future<void> _onLoadBookingForEdit(LoadBookingForEditEvent event, Emitter<BookingState> emit) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final result = await getBookingByTicketUseCase(event.ticket);
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (booking) {
        DateTime? bookingDate;
        try {
          bookingDate = DateTime.parse(booking.bookingDate);
        } catch (_) {}

        emit(state.copyWith(
          isLoading: false,
          isEditing: true,
          editingTicket: event.ticket,
          customerName: booking.customerName,
          customerPhone: booking.customerPhone,
          customerEmail: booking.customerEmail,
          custAddress: booking.custAddress,
          cityId: booking.cityId,
          cityName: booking.cityName,
          vehicleType: booking.vehicleType,
          vehicleModel: booking.vehicleModel,
          vehiclePlat: booking.vehiclePlat,
          vehicleColor: booking.vehicleColor,
          isEv: booking.isEv,
          notes: booking.notes,
          selectedDate: bookingDate,
          selectedHour: booking.hour,
          currentStep: 4,
          clearError: true,
        ));

        if (bookingDate != null) {
          add(SelectDateEvent(bookingDate));
        }
      },
    );
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

    final packageNotes = PackageNotesBuilder.buildPackageNotes(
      selectedPackages: state.selectedPackages,
      selectedPackageChildren: state.selectedPackageChildren,
      allVariants: state.availableVariants,
    );
    final finalNotes = PackageNotesBuilder.mergeBookingNotes(
      customerNotes: state.notes,
      packageNotes: packageNotes,
    );

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
      endDate: state.endDate ?? bookingDateStr,
      isMultiDay: state.isMultiDay,
      hour: state.selectedHour!,
      hasVisited: state.hasVisited,
      referralSource: state.referralSource,
      purchaseSource: 'online',
      serviceIds: state.selectedServices.map((s) => s.id).toList(),
      packageIds: state.selectedPackages.map((p) => p.id).toList(),
      variantItems: state.selectedVariants,
      voucherId: state.appliedVoucher?.id,
      voucherCode: state.appliedVoucher?.code,
      subTotal: state.subTotal,
      discountAmount: state.voucherDiscount,
      totalAmount: state.totalAmount,
      estimatedMinutes: state.estimatedMinutes,
      notes: finalNotes.isNotEmpty ? finalNotes : null,
    );

    final Either<dynamic, BookingEntity> result = state.isEditing && state.editingTicket != null
        ? await updateBookingUseCase(UpdateBookingParams(ticket: state.editingTicket!, booking: bookingPayload))
        : await submitBookingUseCase(bookingPayload);

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
