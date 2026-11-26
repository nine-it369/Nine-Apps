import '../../domain/entities/booking_availability_entity.dart';

class BookingAvailabilityModel extends BookingAvailabilityEntity {
  const BookingAvailabilityModel({
    required super.hour,
    required super.status,
    required super.remainingCapacity,
  });

  factory BookingAvailabilityModel.fromJson(Map<String, dynamic> json) {
    return BookingAvailabilityModel(
      hour: json['hour']?.toString() ?? json['time_slot']?.toString() ?? '09:00',
      status: json['status']?.toString() ?? 'available',
      remainingCapacity: json['remaining_capacity'] is int
          ? json['remaining_capacity'] as int
          : int.tryParse(json['remaining_capacity']?.toString() ?? '0') ?? 0,
    );
  }
}
