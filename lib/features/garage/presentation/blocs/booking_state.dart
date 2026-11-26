import 'package:equatable/equatable.dart';
import '../../domain/entities/booking_availability_entity.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/entities/booking_variant_item_entity.dart';
import '../../domain/entities/package_entity.dart';
import '../../domain/entities/regency_entity.dart';
import '../../domain/entities/service_entity.dart';
import '../../domain/entities/variant_entity.dart';
import '../../domain/entities/voucher_entity.dart';
import '../../domain/entities/workshop_entity.dart';
import '../../domain/utils/duration_calculator.dart';
import '../../domain/utils/slot_calculator.dart';

enum BookingSubmissionStatus {
  initial,
  submitting,
  success,
  failure,
}

class BookingState extends Equatable {
  final int currentStep; // 1 to 5
  final bool isLoading;
  final bool isLockingSlot;
  final bool isValidatingVoucher;
  final String? errorMessage;

  // Master Data
  final List<WorkshopEntity> workshops;
  final List<ServiceEntity> availableServices;
  final List<PackageEntity> availablePackages;
  final List<VariantEntity> availableVariants;
  final List<RegencyEntity> regencyResults;
  final List<BookingAvailabilityEntity> timeSlots;
  final List<VoucherEntity> availableVouchers;

  // Step 1: Contact & Address
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final String custAddress;
  final int cityId;
  final String cityName;
  final String referralSource;
  final bool hasVisited;
  final String notes;

  // Step 2: Vehicle
  final String vehicleType; // 'car' | 'motorcycle'
  final bool isEv;
  final String vehicleModel;
  final String vehiclePlat;
  final String vehicleColor;

  // Step 3: Services, Packages & Standalone Variants
  final List<ServiceEntity> selectedServices;
  final List<PackageEntity> selectedPackages;
  final List<BookingVariantItemEntity> selectedVariants;
  final Map<int, Map<int, int>> selectedPackageChildren; // packageId -> {parentVariantId: childVariantId}
  final bool applyDiscount; // Toggle promo discount (review & IG story terms)

  // Step 4: Schedule & Branch
  final WorkshopEntity? selectedWorkshop;
  final DateTime? selectedDate;
  final String? selectedHour;
  final String? endDate;
  final bool isMultiDay;
  final SlotValidationResult? slotConflict;

  // Step 5: Review, Timer & Voucher
  final int reviewSecondsRemaining;
  final VoucherEntity? appliedVoucher;
  final num voucherDiscount;

  // Edit Mode
  final bool isEditing;
  final String? editingTicket;

  // Submission Status
  final BookingSubmissionStatus submissionStatus;
  final BookingEntity? submittedBooking;

  const BookingState({
    this.currentStep = 1,
    this.isLoading = false,
    this.isLockingSlot = false,
    this.isValidatingVoucher = false,
    this.errorMessage,
    this.workshops = const [],
    this.availableServices = const [],
    this.availablePackages = const [],
    this.availableVariants = const [],
    this.regencyResults = const [],
    this.timeSlots = const [],
    this.availableVouchers = const [],
    this.customerName = '',
    this.customerPhone = '',
    this.customerEmail = '',
    this.custAddress = '',
    this.cityId = 0,
    this.cityName = '',
    this.referralSource = 'Google Search',
    this.hasVisited = false,
    this.notes = '',
    this.vehicleType = 'car',
    this.isEv = false,
    this.vehicleModel = '',
    this.vehiclePlat = '',
    this.vehicleColor = '',
    this.selectedServices = const [],
    this.selectedPackages = const [],
    this.selectedVariants = const [],
    this.selectedPackageChildren = const {},
    this.applyDiscount = true,
    this.selectedWorkshop,
    this.selectedDate,
    this.selectedHour,
    this.endDate,
    this.isMultiDay = false,
    this.slotConflict,
    this.reviewSecondsRemaining = 180,
    this.appliedVoucher,
    this.voucherDiscount = 0,
    this.isEditing = false,
    this.editingTicket,
    this.submissionStatus = BookingSubmissionStatus.initial,
    this.submittedBooking,
  });

  num get servicesSubtotal => selectedServices.fold(
        0,
        (sum, item) => sum + (applyDiscount ? item.nowPrice : item.price),
      );

  num get packagesSubtotal => selectedPackages.fold(
        0,
        (sum, item) => sum + (applyDiscount ? item.effectivePrice(isEv) : item.price),
      );

  num get variantsSubtotal {
    num sum = 0;
    for (final v in selectedVariants) {
      if (v.packageId != null && v.packageId! > 0) continue;
      final itemPrice = applyDiscount ? (v.discPrice ?? v.price ?? 0) : (v.price ?? 0);
      sum += itemPrice * v.qty;
      if (v.withInstallation) {
        final installPrice = applyDiscount ? (v.serviceDiscPrice ?? v.servicePrice ?? 0) : (v.servicePrice ?? 0);
        sum += installPrice;
      }
    }
    return sum;
  }

  num get subTotal => servicesSubtotal + packagesSubtotal + variantsSubtotal;

  num get totalAmount => (subTotal - voucherDiscount).clamp(0, double.infinity);

  int get estimatedMinutes {
    return SlotCalculator.calculateEstimatedMinutes(
      selectedServices: selectedServices,
      selectedPackages: selectedPackages,
      selectedVariants: selectedVariants,
      allVariants: availableVariants,
      isEv: isEv,
    );
  }

  int get requiredTechnicians {
    return SlotCalculator.calculateRequiredTechnicians(
      selectedServices: selectedServices,
      selectedPackages: selectedPackages,
      selectedVariants: selectedVariants,
      allVariants: availableVariants,
    );
  }

  int get slotsNeeded => SlotCalculator.slotsNeeded(estimatedMinutes);

  bool get hasBiledService => DurationCalculator.hasBiledService(
        services: selectedServices,
        packages: selectedPackages,
      );

  bool get isStep1Valid {
    final hasName = customerName.trim().length >= 3;
    final cleanPhone = customerPhone.replaceAll(RegExp(r'[^0-9]'), '');
    final hasContact = cleanPhone.length >= 9 || customerEmail.trim().isNotEmpty;
    final hasCity = cityId > 0;
    final hasAddress = custAddress.trim().length >= 5;
    final hasReferral = referralSource.trim().isNotEmpty;
    return hasName && hasContact && hasCity && hasAddress && hasReferral;
  }

  bool get isStep2Valid =>
      vehicleType.isNotEmpty &&
      vehicleModel.trim().isNotEmpty &&
      vehiclePlat.trim().length >= 3 &&
      vehicleColor.trim().isNotEmpty;

  bool get isStep3Valid {
    final hasMainItem = selectedServices.isNotEmpty || selectedPackages.isNotEmpty || selectedVariants.isNotEmpty;
    return hasMainItem;
  }

  bool get isStep4Valid =>
      selectedWorkshop != null && selectedDate != null && selectedHour != null;

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
        return isStep1Valid && isStep2Valid && isStep3Valid && isStep4Valid;
      default:
        return false;
    }
  }

  BookingState copyWith({
    int? currentStep,
    bool? isLoading,
    bool? isLockingSlot,
    bool? isValidatingVoucher,
    String? errorMessage,
    List<WorkshopEntity>? workshops,
    List<ServiceEntity>? availableServices,
    List<PackageEntity>? availablePackages,
    List<VariantEntity>? availableVariants,
    List<RegencyEntity>? regencyResults,
    List<BookingAvailabilityEntity>? timeSlots,
    List<VoucherEntity>? availableVouchers,
    String? customerName,
    String? customerPhone,
    String? customerEmail,
    String? custAddress,
    int? cityId,
    String? cityName,
    String? referralSource,
    bool? hasVisited,
    String? notes,
    String? vehicleType,
    bool? isEv,
    String? vehicleModel,
    String? vehiclePlat,
    String? vehicleColor,
    List<ServiceEntity>? selectedServices,
    List<PackageEntity>? selectedPackages,
    List<BookingVariantItemEntity>? selectedVariants,
    Map<int, Map<int, int>>? selectedPackageChildren,
    bool? applyDiscount,
    WorkshopEntity? selectedWorkshop,
    DateTime? selectedDate,
    String? selectedHour,
    bool clearSelectedHour = false,
    String? endDate,
    bool? isMultiDay,
    SlotValidationResult? slotConflict,
    bool clearSlotConflict = false,
    int? reviewSecondsRemaining,
    VoucherEntity? appliedVoucher,
    bool clearVoucher = false,
    num? voucherDiscount,
    bool? isEditing,
    String? editingTicket,
    BookingSubmissionStatus? submissionStatus,
    BookingEntity? submittedBooking,
    bool clearError = false,
  }) {
    return BookingState(
      currentStep: currentStep ?? this.currentStep,
      isLoading: isLoading ?? this.isLoading,
      isLockingSlot: isLockingSlot ?? this.isLockingSlot,
      isValidatingVoucher: isValidatingVoucher ?? this.isValidatingVoucher,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      workshops: workshops ?? this.workshops,
      availableServices: availableServices ?? this.availableServices,
      availablePackages: availablePackages ?? this.availablePackages,
      availableVariants: availableVariants ?? this.availableVariants,
      regencyResults: regencyResults ?? this.regencyResults,
      timeSlots: timeSlots ?? this.timeSlots,
      availableVouchers: availableVouchers ?? this.availableVouchers,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerEmail: customerEmail ?? this.customerEmail,
      custAddress: custAddress ?? this.custAddress,
      cityId: cityId ?? this.cityId,
      cityName: cityName ?? this.cityName,
      referralSource: referralSource ?? this.referralSource,
      hasVisited: hasVisited ?? this.hasVisited,
      notes: notes ?? this.notes,
      vehicleType: vehicleType ?? this.vehicleType,
      isEv: isEv ?? this.isEv,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      vehiclePlat: vehiclePlat ?? this.vehiclePlat,
      vehicleColor: vehicleColor ?? this.vehicleColor,
      selectedServices: selectedServices ?? this.selectedServices,
      selectedPackages: selectedPackages ?? this.selectedPackages,
      selectedVariants: selectedVariants ?? this.selectedVariants,
      selectedPackageChildren: selectedPackageChildren ?? this.selectedPackageChildren,
      applyDiscount: applyDiscount ?? this.applyDiscount,
      selectedWorkshop: selectedWorkshop ?? this.selectedWorkshop,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedHour: clearSelectedHour ? null : (selectedHour ?? this.selectedHour),
      endDate: endDate ?? this.endDate,
      isMultiDay: isMultiDay ?? this.isMultiDay,
      slotConflict: clearSlotConflict ? null : (slotConflict ?? this.slotConflict),
      reviewSecondsRemaining: reviewSecondsRemaining ?? this.reviewSecondsRemaining,
      appliedVoucher: clearVoucher ? null : (appliedVoucher ?? this.appliedVoucher),
      voucherDiscount: clearVoucher ? 0 : (voucherDiscount ?? this.voucherDiscount),
      isEditing: isEditing ?? this.isEditing,
      editingTicket: editingTicket ?? this.editingTicket,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      submittedBooking: submittedBooking ?? this.submittedBooking,
    );
  }

  @override
  List<Object?> get props => [
        currentStep,
        isLoading,
        isLockingSlot,
        isValidatingVoucher,
        errorMessage,
        workshops,
        availableServices,
        availablePackages,
        availableVariants,
        regencyResults,
        timeSlots,
        availableVouchers,
        customerName,
        customerPhone,
        customerEmail,
        custAddress,
        cityId,
        cityName,
        referralSource,
        hasVisited,
        notes,
        vehicleType,
        isEv,
        vehicleModel,
        vehiclePlat,
        vehicleColor,
        selectedServices,
        selectedPackages,
        selectedVariants,
        selectedPackageChildren,
        applyDiscount,
        selectedWorkshop,
        selectedDate,
        selectedHour,
        endDate,
        isMultiDay,
        slotConflict,
        reviewSecondsRemaining,
        appliedVoucher,
        voucherDiscount,
        isEditing,
        editingTicket,
        submissionStatus,
        submittedBooking,
      ];
}
