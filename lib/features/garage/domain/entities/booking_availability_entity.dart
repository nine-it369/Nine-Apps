import 'package:equatable/equatable.dart';

class BookingAvailabilityEntity extends Equatable {
  final String hour; // e.g. "13:00", "13:30"
  final String status; // "available" | "booked" | "locked" | "full"
  final int remainingCapacity;

  const BookingAvailabilityEntity({
    required this.hour,
    required this.status,
    required this.remainingCapacity,
  });

  bool get isAvailable => status == 'available' && remainingCapacity > 0;

  @override
  List<Object?> get props => [hour, status, remainingCapacity];
}
