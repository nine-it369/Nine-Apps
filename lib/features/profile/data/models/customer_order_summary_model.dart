import '../../domain/entities/customer_order_summary_entity.dart';

class CustomerOrderSummaryModel extends CustomerOrderSummaryEntity {
  const CustomerOrderSummaryModel({
    required super.id,
    required super.orderNumber,
    required super.totalAmount,
    required super.status,
    super.createdAt,
    super.courier,
    super.trackingNumber,
    super.itemsCount,
  });

  factory CustomerOrderSummaryModel.fromJson(Map<String, dynamic> json) {
    DateTime? parsedDate;
    if (json['created_at'] != null) {
      parsedDate = DateTime.tryParse(json['created_at'].toString());
    }

    final rawTotal = json['total_amount'] ?? json['grand_total'] ?? json['total'] ?? 0;
    final total = rawTotal is num ? rawTotal.toDouble() : double.tryParse(rawTotal.toString()) ?? 0.0;

    return CustomerOrderSummaryModel(
      id: json['id'] as int? ?? 0,
      orderNumber: (json['order_number'] ?? json['invoice_number'] ?? 'ORD-000').toString(),
      totalAmount: total,
      status: (json['status'] ?? 'pending').toString(),
      createdAt: parsedDate,
      courier: json['courier']?.toString() ?? json['expedition']?.toString(),
      trackingNumber: json['awb_number']?.toString() ?? json['tracking_number']?.toString(),
      itemsCount: (json['items_count'] as int?) ?? (json['items'] as List<dynamic>?)?.length ?? 1,
    );
  }
}
