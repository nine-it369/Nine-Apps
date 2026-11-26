import 'package:equatable/equatable.dart';
import '../../domain/entities/service_entity.dart';
import '../../domain/entities/workshop_entity.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object?> get props => [];
}

class InitBookingEvent extends ActionBookingEvent {}

abstract class ActionBookingEvent extends BookingEvent {}

class GoToStepEvent extends BookingEvent {
  final int step;
  const GoToStepEvent(this.step);

  @override
  List<Object?> get props => [step];
}

class NextStepEvent extends BookingEvent {}
class PrevStepEvent extends BookingEvent {}

class UpdateContactEvent extends BookingEvent {
  final String name;
  final String phone;
  final String? email;
  final String? address;
  final String? notes;

  const UpdateContactEvent({
    required this.name,
    required this.phone,
    this.email,
    this.address,
    this.notes,
  });

  @override
  List<Object?> get props => [name, phone, email, address, notes];
}

class UpdateVehicleEvent extends BookingEvent {
  final String category;
  final String brand;
  final String model;
  final String? year;
  final String licensePlate;
  final String transmission;

  const UpdateVehicleEvent({
    required this.category,
    required this.brand,
    required this.model,
    this.year,
    required this.licensePlate,
    required this.transmission,
  });

  @override
  List<Object?> get props => [category, brand, model, year, licensePlate, transmission];
}

class ToggleServiceSelectionEvent extends BookingEvent {
  final ServiceEntity service;
  const ToggleServiceSelectionEvent(this.service);

  @override
  List<Object?> get props => [service];
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
  final String timeSlot;
  const SelectTimeSlotEvent(this.timeSlot);

  @override
  List<Object?> get props => [timeSlot];
}

class ApplyVoucherEvent extends BookingEvent {
  final String voucherCode;
  const ApplyVoucherEvent(this.voucherCode);

  @override
  List<Object?> get props => [voucherCode];
}

class RemoveVoucherEvent extends BookingEvent {}

class SubmitBookingEvent extends BookingEvent {}
