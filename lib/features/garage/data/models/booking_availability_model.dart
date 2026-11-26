import '../../domain/entities/booking_availability_entity.dart';

class BookingAvailabilityModel extends BookingAvailabilityEntity {
  const BookingAvailabilityModel({
    required super.timeSlot,
    required super.isAvailable,
    required super.availableCapacity,
    super.reason,
  });

  factory BookingAvailabilityModel.fromJson(Map<String, dynamic> json) {
    return BookingAvailabilityModel(
      timeSlot: json['time_slot']?.toString() ?? json['slot']?.toString() ?? '09:00',
      isAvailable: json['is_available'] == true || json['available'] == true,
      availableCapacity: json['available_capacity'] is int
          ? json['available_capacity'] as int
          : int.tryParse(json['available_capacity']?.toString() ?? '1') ?? 1,
      reason: json['reason']?.toString(),
    );
  }
}
