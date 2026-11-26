import 'package:equatable/equatable.dart';
import 'booking_variant_item_entity.dart';

class BookingEntity extends Equatable {
  final int? id;
  final String? bookingTicket;
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final String custAddress;
  final int cityId;
  final String? cityName;
  final String vehicleType; // 'car' | 'motorcycle'
  final String vehicleModel;
  final String vehiclePlat;
  final String vehicleColor;
  final bool isEv;
  final int workshopId;
  final String? workshopName;
  final String bookingDate;
  final String? endDate;
  final bool isMultiDay;
  final String hour;
  final bool hasVisited;
  final String referralSource;
  final String purchaseSource;
  final List<int> serviceIds;
  final List<int> packageIds;
  final List<BookingVariantItemEntity> variantItems;
  final List<String> itemNames;
  final int? voucherId;
  final String? voucherCode;
  final num subTotal;
  final num discountAmount;
  final num totalAmount;
  final int estimatedMinutes;
  final String? notes;
  final String status;

  const BookingEntity({
    this.id,
    this.bookingTicket,
    required this.customerName,
    required this.customerPhone,
    this.customerEmail = '',
    required this.custAddress,
    required this.cityId,
    this.cityName,
    required this.vehicleType,
    required this.vehicleModel,
    required this.vehiclePlat,
    required this.vehicleColor,
    this.isEv = false,
    required this.workshopId,
    this.workshopName,
    required this.bookingDate,
    this.endDate,
    this.isMultiDay = false,
    required this.hour,
    this.hasVisited = false,
    required this.referralSource,
    this.purchaseSource = 'online',
    this.serviceIds = const [],
    this.packageIds = const [],
    this.variantItems = const [],
    this.itemNames = const [],
    this.voucherId,
    this.voucherCode,
    required this.subTotal,
    this.discountAmount = 0,
    required this.totalAmount,
    this.estimatedMinutes = 60,
    this.notes,
    this.status = 'pending',
  });

  @override
  List<Object?> get props => [
        id,
        bookingTicket,
        customerName,
        customerPhone,
        customerEmail,
        custAddress,
        cityId,
        cityName,
        vehicleType,
        vehicleModel,
        vehiclePlat,
        vehicleColor,
        isEv,
        workshopId,
        workshopName,
        bookingDate,
        endDate,
        isMultiDay,
        hour,
        hasVisited,
        referralSource,
        purchaseSource,
        serviceIds,
        packageIds,
        variantItems,
        itemNames,
        voucherId,
        voucherCode,
        subTotal,
        discountAmount,
        totalAmount,
        estimatedMinutes,
        notes,
        status,
      ];
}
