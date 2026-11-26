import 'package:equatable/equatable.dart';
import '../../domain/entities/booking_availability_entity.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/entities/service_entity.dart';
import '../../domain/entities/workshop_entity.dart';

enum BookingSubmissionStatus {
  initial,
  submitting,
  success,
  failure,
}

class BookingState extends Equatable {
  final int currentStep; // 1 to 5
  final bool isLoading;
  final String? errorMessage;

  // Master Data
  final List<WorkshopEntity> workshops;
  final List<ServiceEntity> availableServices;
  final List<BookingAvailabilityEntity> timeSlots;

  // Step 1: Contact
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final String address;
  final String notes;

  // Step 2: Vehicle
  final String vehicleCategory; // 'car' or 'motorcycle'
  final String vehicleBrand;
  final String vehicleModel;
  final String vehicleYear;
  final String licensePlate;
  final String transmissionType; // 'automatic' or 'manual'

  // Step 3: Services
  final List<ServiceEntity> selectedServices;

  // Step 4: Schedule & Branch
  final WorkshopEntity? selectedWorkshop;
  final DateTime? selectedDate;
  final String? selectedTimeSlot;

  // Step 5: Review & Voucher
  final String? appliedVoucherCode;
  final num voucherDiscount;

  // Submission Status
  final BookingSubmissionStatus submissionStatus;
  final BookingEntity? submittedBooking;

  const BookingState({
    this.currentStep = 1,
    this.isLoading = false,
    this.errorMessage,
    this.workshops = const [],
    this.availableServices = const [],
    this.timeSlots = const [],
    this.customerName = '',
    this.customerPhone = '',
    this.customerEmail = '',
    this.address = '',
    this.notes = '',
    this.vehicleCategory = 'car',
    this.vehicleBrand = 'Toyota',
    this.vehicleModel = 'Innova Zenix',
    this.vehicleYear = '2024',
    this.licensePlate = '',
    this.transmissionType = 'automatic',
    this.selectedServices = const [],
    this.selectedWorkshop,
    this.selectedDate,
    this.selectedTimeSlot,
    this.appliedVoucherCode,
    this.voucherDiscount = 0,
    this.submissionStatus = BookingSubmissionStatus.initial,
    this.submittedBooking,
  });

  num get subtotalPrice => selectedServices.fold(0, (sum, item) => sum + item.nowPrice);
  num get totalPrice => (subtotalPrice - voucherDiscount).clamp(0, double.infinity);
  int get estimatedDurationMinutes =>
      selectedServices.fold(0, (sum, item) => sum + item.estimatedMinutes);

  bool get isStep1Valid =>
      customerName.trim().isNotEmpty && customerPhone.trim().length >= 9;
  bool get isStep2Valid =>
      vehicleBrand.trim().isNotEmpty &&
      vehicleModel.trim().isNotEmpty &&
      licensePlate.trim().isNotEmpty;
  bool get isStep3Valid => selectedServices.isNotEmpty;
  bool get isStep4Valid =>
      selectedWorkshop != null && selectedDate != null && selectedTimeSlot != null;

  bool canProceed(int step) {
    switch (step) {
      case 1:
        return isStep1Valid;
      case 2:
        return isStep2Valid;
      case 3:
        return isStep3Valid;
      case 4:
        return isStep4Valid;
      case 5:
        return true;
      default:
        return false;
    }
  }

  BookingState copyWith({
    int? currentStep,
    bool? isLoading,
    String? errorMessage,
    List<WorkshopEntity>? workshops,
    List<ServiceEntity>? availableServices,
    List<BookingAvailabilityEntity>? timeSlots,
    String? customerName,
    String? customerPhone,
    String? customerEmail,
    String? address,
    String? notes,
    String? vehicleCategory,
    String? vehicleBrand,
    String? vehicleModel,
    String? vehicleYear,
    String? licensePlate,
    String? transmissionType,
    List<ServiceEntity>? selectedServices,
    WorkshopEntity? selectedWorkshop,
    DateTime? selectedDate,
    String? selectedTimeSlot,
    String? appliedVoucherCode,
    num? voucherDiscount,
    BookingSubmissionStatus? submissionStatus,
    BookingEntity? submittedBooking,
    bool clearError = false,
  }) {
    return BookingState(
      currentStep: currentStep ?? this.currentStep,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      workshops: workshops ?? this.workshops,
      availableServices: availableServices ?? this.availableServices,
      timeSlots: timeSlots ?? this.timeSlots,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerEmail: customerEmail ?? this.customerEmail,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      vehicleCategory: vehicleCategory ?? this.vehicleCategory,
      vehicleBrand: vehicleBrand ?? this.vehicleBrand,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      vehicleYear: vehicleYear ?? this.vehicleYear,
      licensePlate: licensePlate ?? this.licensePlate,
      transmissionType: transmissionType ?? this.transmissionType,
      selectedServices: selectedServices ?? this.selectedServices,
      selectedWorkshop: selectedWorkshop ?? this.selectedWorkshop,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTimeSlot: selectedTimeSlot ?? this.selectedTimeSlot,
      appliedVoucherCode: appliedVoucherCode ?? this.appliedVoucherCode,
      voucherDiscount: voucherDiscount ?? this.voucherDiscount,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      submittedBooking: submittedBooking ?? this.submittedBooking,
    );
  }

  @override
  List<Object?> get props => [
        currentStep,
        isLoading,
        errorMessage,
        workshops,
        availableServices,
        timeSlots,
        customerName,
        customerPhone,
        customerEmail,
        address,
        notes,
        vehicleCategory,
        vehicleBrand,
        vehicleModel,
        vehicleYear,
        licensePlate,
        transmissionType,
        selectedServices,
        selectedWorkshop,
        selectedDate,
        selectedTimeSlot,
        appliedVoucherCode,
        voucherDiscount,
        submissionStatus,
        submittedBooking,
      ];
}
