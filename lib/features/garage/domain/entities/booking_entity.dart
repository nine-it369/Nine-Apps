import 'package:equatable/equatable.dart';

class BookingEntity extends Equatable {
  final int? id;
  final String? bookingTicket;
  final String customerName;
  final String customerPhone;
  final String? customerEmail;
  final String? address;
  final String vehicleCategory;
  final String vehicleBrand;
  final String vehicleModel;
  final String? vehicleYear;
  final String licensePlate;
  final String transmissionType;
  final int workshopId;
  final String? workshopName;
  final String bookingDate;
  final String timeSlot;
  final List<int> serviceIds;
  final String? voucherCode;
  final num subtotalPrice;
  final num discountAmount;
  final num totalPrice;
  final int estimatedDurationMinutes;
  final String? notes;
  final String status;

  const BookingEntity({
    this.id,
    this.bookingTicket,
    required this.customerName,
    required this.customerPhone,
    this.customerEmail,
    this.address,
    required this.vehicleCategory,
    required this.vehicleBrand,
    required this.vehicleModel,
    this.vehicleYear,
    required this.licensePlate,
    required this.transmissionType,
    required this.workshopId,
    this.workshopName,
    required this.bookingDate,
    required this.timeSlot,
    required this.serviceIds,
    this.voucherCode,
    required this.subtotalPrice,
    this.discountAmount = 0,
    required this.totalPrice,
    this.estimatedDurationMinutes = 60,
    this.notes,
    this.status = 'PENDING',
  });

  @override
  List<Object?> get props => [
        id,
        bookingTicket,
        customerName,
        customerPhone,
        customerEmail,
        address,
        vehicleCategory,
        vehicleBrand,
        vehicleModel,
        vehicleYear,
        licensePlate,
        transmissionType,
        workshopId,
        workshopName,
        bookingDate,
        timeSlot,
        serviceIds,
        voucherCode,
        subtotalPrice,
        discountAmount,
        totalPrice,
        estimatedDurationMinutes,
        notes,
        status,
      ];
}
