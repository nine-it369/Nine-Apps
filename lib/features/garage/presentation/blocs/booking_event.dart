import 'package:equatable/equatable.dart';
import '../../domain/entities/package_entity.dart';
import '../../domain/entities/regency_entity.dart';
import '../../domain/entities/service_entity.dart';
import '../../domain/entities/voucher_entity.dart';
import '../../domain/entities/workshop_entity.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object?> get props => [];
}

class InitBookingEvent extends BookingEvent {}

class GoToStepEvent extends BookingEvent {
  final int step;
  const GoToStepEvent(this.step);

  @override
  List<Object?> get props => [step];
}

class NextStepEvent extends BookingEvent {}

class PrevStepEvent extends BookingEvent {}

class UpdateContactEvent extends BookingEvent {
  final String? name;
  final String? phone;
  final String? email;
  final String? address;
  final String? referralSource;
  final bool? hasVisited;
  final String? notes;

  const UpdateContactEvent({
    this.name,
    this.phone,
    this.email,
    this.address,
    this.referralSource,
    this.hasVisited,
    this.notes,
  });

  @override
  List<Object?> get props => [name, phone, email, address, referralSource, hasVisited, notes];
}

class SearchRegencyEvent extends BookingEvent {
  final String query;
  const SearchRegencyEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class SelectRegencyEvent extends BookingEvent {
  final RegencyEntity regency;
  const SelectRegencyEvent(this.regency);

  @override
  List<Object?> get props => [regency];
}

class UpdateVehicleEvent extends BookingEvent {
  final String? vehicleType;
  final bool? isEv;
  final String? model;
  final String? plat;
  final String? color;

  const UpdateVehicleEvent({
    this.vehicleType,
    this.isEv,
    this.model,
    this.plat,
    this.color,
  });

  @override
  List<Object?> get props => [vehicleType, isEv, model, plat, color];
}

class ToggleServiceSelectionEvent extends BookingEvent {
  final ServiceEntity service;
  const ToggleServiceSelectionEvent(this.service);

  @override
  List<Object?> get props => [service];
}

class TogglePackageSelectionEvent extends BookingEvent {
  final PackageEntity package;
  const TogglePackageSelectionEvent(this.package);

  @override
  List<Object?> get props => [package];
}

class SelectWorkshopEvent extends BookingEvent {
  final WorkshopEntity workshop;
  const SelectWorkshopEvent(this.workshop);

  @override
  List<Object?> get props => [workshop];
}

class SelectDateEvent extends BookingEvent {
  final DateTime date;
  const SelectDateEvent(this.date);

  @override
  List<Object?> get props => [date];
}

class SelectTimeSlotEvent extends BookingEvent {
  final String hour;
  const SelectTimeSlotEvent(this.hour);

  @override
  List<Object?> get props => [hour];
}

class ApplyVoucherEvent extends BookingEvent {
  final VoucherEntity voucher;
  const ApplyVoucherEvent(this.voucher);

  @override
  List<Object?> get props => [voucher];
}

class ApplyVoucherCodeEvent extends BookingEvent {
  final String code;
  const ApplyVoucherCodeEvent(this.code);

  @override
  List<Object?> get props => [code];
}

class RemoveVoucherEvent extends BookingEvent {}

class TickReviewTimerEvent extends BookingEvent {}

class SubmitBookingEvent extends BookingEvent {}
