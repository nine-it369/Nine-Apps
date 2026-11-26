import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/date_time_utils.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/usecases/get_availability_usecase.dart';
import '../../domain/usecases/get_services_usecase.dart';
import '../../domain/usecases/get_workshops_usecase.dart';
import '../../domain/usecases/submit_booking_usecase.dart';
import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final GetWorkshopsUseCase getWorkshopsUseCase;
  final GetServicesUseCase getServicesUseCase;
  final GetAvailabilityUseCase getAvailabilityUseCase;
  final SubmitBookingUseCase submitBookingUseCase;

  BookingBloc({
    required this.getWorkshopsUseCase,
    required this.getServicesUseCase,
    required this.getAvailabilityUseCase,
    required this.submitBookingUseCase,
  }) : super(const BookingState()) {
    on<InitBookingEvent>(_onInit);
    on<GoToStepEvent>(_onGoToStep);
    on<NextStepEvent>(_onNextStep);
    on<PrevStepEvent>(_onPrevStep);
    on<UpdateContactEvent>(_onUpdateContact);
    on<UpdateVehicleEvent>(_onUpdateVehicle);
    on<ToggleServiceSelectionEvent>(_onToggleService);
    on<SelectWorkshopEvent>(_onSelectWorkshop);
    on<SelectDateEvent>(_onSelectDate);
    on<SelectTimeSlotEvent>(_onSelectTimeSlot);
    on<ApplyVoucherEvent>(_onApplyVoucher);
    on<RemoveVoucherEvent>(_onRemoveVoucher);
    on<SubmitBookingEvent>(_onSubmitBooking);
  }

  Future<void> _onInit(InitBookingEvent event, Emitter<BookingState> emit) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    // Fetch workshops & services in parallel
    final workshopsResult = await getWorkshopsUseCase(const NoParams());
    final servicesResult = await getServicesUseCase(const GetServicesParams());

    workshopsResult.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      )),
      (workshops) {
        servicesResult.fold(
          (failure) => emit(state.copyWith(
            isLoading: false,
            errorMessage: failure.message,
            workshops: workshops,
          )),
          (services) {
            final defaultWorkshop = workshops.isNotEmpty ? workshops.first : null;
            final defaultDate = DateTime.now().add(const Duration(days: 1));

            emit(state.copyWith(
              isLoading: false,
              workshops: workshops,
              availableServices: services,
              selectedWorkshop: defaultWorkshop,
              selectedDate: defaultDate,
            ));

            if (defaultWorkshop != null) {
              add(SelectDateEvent(defaultDate));
            }
          },
        );
      },
    );
  }

  void _onGoToStep(GoToStepEvent event, Emitter<BookingState> emit) {
    if (event.step >= 1 && event.step <= 5) {
      emit(state.copyWith(currentStep: event.step));
    }
  }

  void _onNextStep(NextStepEvent event, Emitter<BookingState> emit) {
    if (state.currentStep < 5 && state.canProceed(state.currentStep)) {
      emit(state.copyWith(currentStep: state.currentStep + 1));
    }
  }

  void _onPrevStep(PrevStepEvent event, Emitter<BookingState> emit) {
    if (state.currentStep > 1) {
      emit(state.copyWith(currentStep: state.currentStep - 1));
    }
  }

  void _onUpdateContact(UpdateContactEvent event, Emitter<BookingState> emit) {
    emit(state.copyWith(
      customerName: event.name,
      customerPhone: event.phone,
      customerEmail: event.email ?? state.customerEmail,
      address: event.address ?? state.address,
      notes: event.notes ?? state.notes,
    ));
  }

  void _onUpdateVehicle(UpdateVehicleEvent event, Emitter<BookingState> emit) {
    emit(state.copyWith(
      vehicleCategory: event.category,
      vehicleBrand: event.brand,
      vehicleModel: event.model,
      vehicleYear: event.year ?? state.vehicleYear,
      licensePlate: event.licensePlate,
      transmissionType: event.transmission,
    ));
  }

  void _onToggleService(ToggleServiceSelectionEvent event, Emitter<BookingState> emit) {
    final current = List.of(state.selectedServices);
    final exists = current.any((s) => s.id == event.service.id);
    if (exists) {
      current.removeWhere((s) => s.id == event.service.id);
    } else {
      current.add(event.service);
    }
    emit(state.copyWith(selectedServices: current));
  }

  Future<void> _onSelectWorkshop(SelectWorkshopEvent event, Emitter<BookingState> emit) async {
    emit(state.copyWith(selectedWorkshop: event.workshop, selectedTimeSlot: null));
    if (state.selectedDate != null) {
      await _fetchAvailability(event.workshop.id, state.selectedDate!, emit);
    }
  }

  Future<void> _onSelectDate(SelectDateEvent event, Emitter<BookingState> emit) async {
    emit(state.copyWith(selectedDate: event.date, selectedTimeSlot: null));
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
      (failure) => null, // Biarkan slot default tetap jalan
      (slots) {
        final firstAvailable = slots.where((s) => s.isAvailable).firstOrNull?.timeSlot;
        emit(state.copyWith(
          timeSlots: slots,
          selectedTimeSlot: firstAvailable,
        ));
      },
    );
  }

  void _onSelectTimeSlot(SelectTimeSlotEvent event, Emitter<BookingState> emit) {
    emit(state.copyWith(selectedTimeSlot: event.timeSlot));
  }

  void _onApplyVoucher(ApplyVoucherEvent event, Emitter<BookingState> emit) {
    final code = event.voucherCode.trim().toUpperCase();
    if (code == 'NINE50K' || code == 'DISCOUNT50') {
      emit(state.copyWith(
        appliedVoucherCode: code,
        voucherDiscount: 50000,
      ));
    } else if (code == 'NINE100K' || code == 'WELCOME') {
      emit(state.copyWith(
        appliedVoucherCode: code,
        voucherDiscount: 100000,
      ));
    } else {
      emit(state.copyWith(
        errorMessage: 'Kode voucher "$code" tidak valid atau telah kedaluwarsa.',
      ));
    }
  }

  void _onRemoveVoucher(RemoveVoucherEvent event, Emitter<BookingState> emit) {
    emit(state.copyWith(
      appliedVoucherCode: null,
      voucherDiscount: 0,
    ));
  }

  Future<void> _onSubmitBooking(SubmitBookingEvent event, Emitter<BookingState> emit) async {
    if (state.selectedWorkshop == null ||
        state.selectedDate == null ||
        state.selectedTimeSlot == null) {
      emit(state.copyWith(errorMessage: 'Mohon lengkapi jadwal dan cabang bengkel terlebih dahulu.'));
      return;
    }

    emit(state.copyWith(
      submissionStatus: BookingSubmissionStatus.submitting,
      clearError: true,
    ));

    final bookingPayload = BookingEntity(
      customerName: state.customerName,
      customerPhone: state.customerPhone,
      customerEmail: state.customerEmail.isNotEmpty ? state.customerEmail : null,
      address: state.address.isNotEmpty ? state.address : null,
      vehicleCategory: state.vehicleCategory,
      vehicleBrand: state.vehicleBrand,
      vehicleModel: state.vehicleModel,
      vehicleYear: state.vehicleYear.isNotEmpty ? state.vehicleYear : null,
      licensePlate: state.licensePlate,
      transmissionType: state.transmissionType,
      workshopId: state.selectedWorkshop!.id,
      workshopName: state.selectedWorkshop!.name,
      bookingDate: DateTimeUtils.formatForApi(state.selectedDate!),
      timeSlot: state.selectedTimeSlot!,
      serviceIds: state.selectedServices.map((s) => s.id).toList(),
      voucherCode: state.appliedVoucherCode,
      subtotalPrice: state.subtotalPrice,
      discountAmount: state.voucherDiscount,
      totalPrice: state.totalPrice,
      estimatedDurationMinutes: state.estimatedDurationMinutes,
      notes: state.notes.isNotEmpty ? state.notes : null,
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
        emit(state.copyWith(
          submissionStatus: BookingSubmissionStatus.success,
          submittedBooking: submitted,
        ));
      },
    );
  }
}
