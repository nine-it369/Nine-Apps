import 'package:equatable/equatable.dart';

class BookingAvailabilityEntity extends Equatable {
  final String timeSlot; // e.g. "09:00", "10:00"
  final bool isAvailable;
  final int availableCapacity;
  final String? reason;

  const BookingAvailabilityEntity({
    required this.timeSlot,
    required this.isAvailable,
    required this.availableCapacity,
    this.reason,
  });

  @override
  List<Object?> get props => [timeSlot, isAvailable, availableCapacity, reason];
}
