import '../../domain/entities/booking_entity.dart';

class BookingModel extends BookingEntity {
  const BookingModel({
    super.id,
    super.bookingTicket,
    required super.customerName,
    required super.customerPhone,
    super.customerEmail = '',
    required super.custAddress,
    required super.cityId,
    super.cityName,
    required super.vehicleType,
    required super.vehicleModel,
    required super.vehiclePlat,
    required super.vehicleColor,
    super.isEv = false,
    required super.workshopId,
    super.workshopName,
    required super.bookingDate,
    super.endDate,
    super.isMultiDay = false,
    required super.hour,
    super.hasVisited = false,
    required super.referralSource,
    super.purchaseSource = 'online',
    super.serviceIds = const [],
    super.packageIds = const [],
    super.itemNames = const [],
    super.voucherId,
    super.voucherCode,
    required super.subTotal,
    super.discountAmount = 0,
    required super.totalAmount,
    super.estimatedMinutes = 60,
    super.notes,
    super.status = 'pending',
  });

  factory BookingModel.fromEntity(BookingEntity entity) {
    return BookingModel(
      id: entity.id,
      bookingTicket: entity.bookingTicket,
      customerName: entity.customerName,
      customerPhone: entity.customerPhone,
      customerEmail: entity.customerEmail,
      custAddress: entity.custAddress,
      cityId: entity.cityId,
      cityName: entity.cityName,
      vehicleType: entity.vehicleType,
      vehicleModel: entity.vehicleModel,
      vehiclePlat: entity.vehiclePlat,
      vehicleColor: entity.vehicleColor,
      isEv: entity.isEv,
      workshopId: entity.workshopId,
      workshopName: entity.workshopName,
      bookingDate: entity.bookingDate,
      endDate: entity.endDate,
      isMultiDay: entity.isMultiDay,
      hour: entity.hour,
      hasVisited: entity.hasVisited,
      referralSource: entity.referralSource,
      purchaseSource: entity.purchaseSource,
      serviceIds: entity.serviceIds,
      packageIds: entity.packageIds,
      itemNames: entity.itemNames,
      voucherId: entity.voucherId,
      voucherCode: entity.voucherCode,
      subTotal: entity.subTotal,
      discountAmount: entity.discountAmount,
      totalAmount: entity.totalAmount,
      estimatedMinutes: entity.estimatedMinutes,
      notes: entity.notes,
      status: entity.status,
    );
  }

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    final serviceList = json['service_items'] as List<dynamic>? ?? [];
    final packageList = json['package_items'] as List<dynamic>? ?? [];

    final parsedServiceIds = <int>[];
    final parsedPackageIds = <int>[];
    final parsedNames = <String>[];

    for (final s in serviceList) {
      if (s is Map) {
        final sid = s['service_id'] ?? s['id'];
        if (sid != null) {
          parsedServiceIds.add(int.tryParse(sid.toString()) ?? 0);
        }
        final name = s['service_name']?.toString() ?? s['name']?.toString();
        if (name != null && name.isNotEmpty) parsedNames.add(name);
      }
    }

    for (final p in packageList) {
      if (p is Map) {
        final pid = p['package_id'] ?? p['id'];
        if (pid != null) {
          parsedPackageIds.add(int.tryParse(pid.toString()) ?? 0);
        }
        final name = p['package_name']?.toString() ?? p['name']?.toString();
        if (name != null && name.isNotEmpty) parsedNames.add(name);
      }
    }

    final workshopMap = json['workshop'];
    final String? wsName = workshopMap is Map
        ? workshopMap['name']?.toString()
        : json['workshop_name']?.toString();

    return BookingModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? ''),
      bookingTicket: json['booking_ticket']?.toString(),
      customerName: json['customer_name']?.toString() ?? '',
      customerPhone: json['customer_phone']?.toString() ?? '',
      customerEmail: json['customer_email']?.toString() ?? '',
      custAddress: json['cust_address']?.toString() ?? '',
      cityId: json['city_id'] is int
          ? json['city_id'] as int
          : int.tryParse(json['city_id']?.toString() ?? '0') ?? 0,
      vehicleType: json['vehicle_type']?.toString() ?? 'car',
      vehicleModel: json['vehicle_model']?.toString() ?? '',
      vehiclePlat: json['vehicle_plat']?.toString() ?? '',
      vehicleColor: json['vehicle_color']?.toString() ?? '',
      isEv: json['is_ev'] == true,
      workshopId: json['workshop_id'] is int
          ? json['workshop_id'] as int
          : int.tryParse(json['workshop_id']?.toString() ?? '1') ?? 1,
      workshopName: wsName,
      bookingDate: json['booking_date']?.toString() ?? '',
      endDate: json['end_date']?.toString(),
      isMultiDay: json['is_multi_day'] == true,
      hour: json['hour']?.toString() ?? '',
      hasVisited: json['has_visited'] == true,
      referralSource: json['referral_source']?.toString() ?? '',
      purchaseSource: json['purchase_source']?.toString() ?? 'online',
      serviceIds: parsedServiceIds,
      packageIds: parsedPackageIds,
      itemNames: parsedNames,
      voucherId: json['voucher_id'] is int
          ? json['voucher_id'] as int
          : int.tryParse(json['voucher_id']?.toString() ?? ''),
      voucherCode: json['voucher_code']?.toString(),
      subTotal: json['sub_total'] is num
          ? json['sub_total'] as num
          : num.tryParse(json['sub_total']?.toString() ?? '0') ?? 0,
      discountAmount: json['discount_amount'] is num
          ? json['discount_amount'] as num
          : num.tryParse(json['discount_amount']?.toString() ?? '0') ?? 0,
      totalAmount: json['total_amount'] is num
          ? json['total_amount'] as num
          : num.tryParse(json['total_amount']?.toString() ?? '0') ?? 0,
      estimatedMinutes: json['estimated_minutes'] is int
          ? json['estimated_minutes'] as int
          : int.tryParse(json['estimated_minutes']?.toString() ?? '60') ?? 60,
      notes: json['notes']?.toString(),
      status: json['status']?.toString() ?? 'pending',
    );
  }

  /// Minimal pruned DTO payload matching Nine Garage Go Backend CreateBooking contract
  Map<String, dynamic> toCreateJson() {
    return {
      'workshop_id': workshopId,
      'customer_name': customerName.trim(),
      'customer_email': customerEmail.trim(),
      'customer_phone': customerPhone.trim(),
      'cust_address': custAddress.trim(),
      'city_id': cityId,
      'vehicle_type': vehicleType,
      'vehicle_model': vehicleModel.trim(),
      'vehicle_plat': vehiclePlat.trim().toUpperCase(),
      'vehicle_color': vehicleColor.trim(),
      'is_ev': isEv,
      'booking_date': bookingDate,
      'end_date': endDate ?? bookingDate,
      'is_multi_day': isMultiDay,
      'hour': hour,
      'has_visited': hasVisited,
      'referral_source': referralSource,
      'purchase_source': purchaseSource,
      'service_items': serviceIds.map((id) => {'service_id': id}).toList(),
      'package_items': packageIds.map((id) => {'package_id': id}).toList(),
      'variant_items': <Map<String, dynamic>>[],
      if (voucherId != null) 'voucher_id': voucherId,
      if (notes != null && notes!.trim().isNotEmpty) 'notes': notes!.trim(),
    };
  }
}
