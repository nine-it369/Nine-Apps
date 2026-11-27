import 'package:equatable/equatable.dart';

class CustomerOrderSummaryEntity extends Equatable {
  final int id;
  final String orderNumber;
  final double totalAmount;
  final String status;
  final DateTime? createdAt;
  final String? courier;
  final String? trackingNumber;
  final int itemsCount;

  const CustomerOrderSummaryEntity({
    required this.id,
    required this.orderNumber,
    required this.totalAmount,
    required this.status,
    this.createdAt,
    this.courier,
    this.trackingNumber,
    this.itemsCount = 1,
  });

  @override
  List<Object?> get props => [
        id,
        orderNumber,
        totalAmount,
        status,
        createdAt,
        courier,
        trackingNumber,
        itemsCount,
      ];
}
