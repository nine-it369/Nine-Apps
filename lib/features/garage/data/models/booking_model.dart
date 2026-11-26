import '../../domain/entities/booking_entity.dart';

class BookingModel extends BookingEntity {
  const BookingModel({
    super.id,
    super.bookingTicket,
    required super.customerName,
    required super.customerPhone,
    super.customerEmail,
    super.address,
    required super.vehicleCategory,
    required super.vehicleBrand,
    required super.vehicleModel,
    super.vehicleYear,
    required super.licensePlate,
    required super.transmissionType,
    required super.workshopId,
    super.workshopName,
    required super.bookingDate,
    required super.timeSlot,
    required super.serviceIds,
    super.voucherCode,
    required super.subtotalPrice,
    super.discountAmount = 0,
    required super.totalPrice,
    super.estimatedDurationMinutes = 60,
    super.notes,
    super.status = 'PENDING',
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      bookingTicket: json['booking_ticket']?.toString() ?? json['ticket']?.toString(),
      customerName: json['customer_name']?.toString() ?? '',
      customerPhone: json['customer_phone']?.toString() ?? '',
      customerEmail: json['customer_email']?.toString(),
      address: json['address']?.toString(),
      vehicleCategory: json['vehicle_category']?.toString() ?? 'car',
      vehicleBrand: json['vehicle_brand']?.toString() ?? '',
      vehicleModel: json['vehicle_model']?.toString() ?? '',
      vehicleYear: json['vehicle_year']?.toString(),
      licensePlate: json['license_plate']?.toString() ?? '',
      transmissionType: json['transmission_type']?.toString() ?? 'automatic',
      workshopId: json['workshop_id'] is int
          ? json['workshop_id'] as int
          : int.tryParse(json['workshop_id']?.toString() ?? '1') ?? 1,
      workshopName: json['workshop_name']?.toString(),
      bookingDate: json['booking_date']?.toString() ?? '',
      timeSlot: json['time_slot']?.toString() ?? '',
      serviceIds: (json['service_ids'] as List<dynamic>?)
              ?.map((e) => e is int ? e : int.tryParse(e.toString()) ?? 0)
              .toList() ??
          [],
      voucherCode: json['voucher_code']?.toString(),
      subtotalPrice: json['subtotal_price'] is num
          ? json['subtotal_price'] as num
          : num.tryParse(json['subtotal_price']?.toString() ?? '0') ?? 0,
      discountAmount: json['discount_amount'] is num
          ? json['discount_amount'] as num
          : num.tryParse(json['discount_amount']?.toString() ?? '0') ?? 0,
      totalPrice: json['total_price'] is num
          ? json['total_price'] as num
          : num.tryParse(json['total_price']?.toString() ?? '0') ?? 0,
      estimatedDurationMinutes: json['estimated_duration_minutes'] is int
          ? json['estimated_duration_minutes'] as int
          : int.tryParse(json['estimated_duration_minutes']?.toString() ?? '60') ?? 60,
      notes: json['notes']?.toString(),
      status: json['status']?.toString() ?? 'PENDING',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (bookingTicket != null) 'booking_ticket': bookingTicket,
      'customer_name': customerName,
      'customer_phone': customerPhone,
      if (customerEmail != null) 'customer_email': customerEmail,
      if (address != null) 'address': address,
      'vehicle_category': vehicleCategory,
      'vehicle_brand': vehicleBrand,
      'vehicle_model': vehicleModel,
      if (vehicleYear != null) 'vehicle_year': vehicleYear,
      'license_plate': licensePlate,
      'transmission_type': transmissionType,
      'workshop_id': workshopId,
      'booking_date': bookingDate,
      'time_slot': timeSlot,
      'service_ids': serviceIds,
      if (voucherCode != null) 'voucher_code': voucherCode,
      'subtotal_price': subtotalPrice,
      'discount_amount': discountAmount,
      'total_price': totalPrice,
      'estimated_duration_minutes': estimatedDurationMinutes,
      if (notes != null) 'notes': notes,
      'status': status,
    };
  }
}
