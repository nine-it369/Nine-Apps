import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/booking_variant_item_entity.dart';
import '../models/booking_availability_model.dart';
import '../models/booking_model.dart';
import '../models/package_model.dart';
import '../models/regency_model.dart';
import '../models/service_model.dart';
import '../models/variant_model.dart';
import '../models/voucher_model.dart';
import '../models/workshop_model.dart';

abstract class IGarageRemoteDataSource {
  Future<List<WorkshopModel>> getWorkshops();
  Future<List<ServiceModel>> getServices({String? vehicleType});
  Future<List<PackageModel>> getPackages();
  Future<List<VariantModel>> getVariants({
    int? workshopId,
    int? categoryId,
    String? search,
    String? vehicleType,
    bool? isEv,
    int? page,
    int? limit,
  });
  Future<List<RegencyModel>> searchRegencies(String query);
  Future<List<BookingAvailabilityModel>> getAvailability({
    required int workshopId,
    required String bookingDate,
    String? excludeTicket,
  });
  Future<void> previewBooking({
    required int workshopId,
    required String bookingDate,
    required String hour,
    required String customerPhone,
    String? customerEmail,
    required List<int> serviceIds,
    required List<int> packageIds,
    List<BookingVariantItemEntity> variantItems = const [],
    required bool isEv,
  });
  Future<void> cancelPreviewBooking({
    required int workshopId,
    required String bookingDate,
    required String hour,
    required String customerPhone,
    String? customerEmail,
  });
  Future<List<VoucherModel>> getAvailableVouchers({
    int? workshopId,
    String? date,
    String? time,
  });
  Future<VoucherValidationResultModel> validateVoucher({
    required int voucherId,
    required String vehicleType,
    required String bookingDate,
    required String hour,
    required bool isEv,
    required int workshopId,
    required List<int> serviceIds,
    required List<int> packageIds,
    List<BookingVariantItemEntity> variantItems = const [],
  });
  Future<BookingModel> submitBooking(BookingModel booking);
  Future<BookingModel> updateBooking(String ticket, BookingModel booking);
  Future<BookingModel> getBookingByTicket(String ticket);
}

class GarageRemoteDataSourceImpl implements IGarageRemoteDataSource {
  final ApiClient apiClient;

  GarageRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<WorkshopModel>> getWorkshops() async {
    final response = await apiClient.get(ApiEndpoints.workshops);
    if (response.statusCode == 200 && response.data != null) {
      final rawData = response.data['data'] as List<dynamic>? ?? [];
      return rawData
          .map((e) => WorkshopModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw const ServerException(message: 'Gagal memuat daftar cabang bengkel.');
  }

  @override
  Future<List<ServiceModel>> getServices({String? vehicleType}) async {
    final queryParams = <String, dynamic>{
      'limit': 50,
      if (vehicleType != null && vehicleType.isNotEmpty && vehicleType != 'all')
        'vehicle_type': vehicleType,
    };
    final response = await apiClient.get(
      ApiEndpoints.services,
      queryParameters: queryParams,
    );
    if (response.statusCode == 200 && response.data != null) {
      final rawData = response.data['data'] as List<dynamic>? ?? [];
      return rawData
          .map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw const ServerException(message: 'Gagal memuat katalog jasa servis.');
  }

  @override
  Future<List<PackageModel>> getPackages() async {
    final response = await apiClient.get(
      ApiEndpoints.packages,
      queryParameters: {'limit': 50},
    );
    if (response.statusCode == 200 && response.data != null) {
      final rawData = response.data['data'] as List<dynamic>? ?? [];
      return rawData
          .map((e) => PackageModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw const ServerException(message: 'Gagal memuat katalog paket layanan.');
  }

  @override
  Future<List<VariantModel>> getVariants({
    int? workshopId,
    int? categoryId,
    String? search,
    String? vehicleType,
    bool? isEv,
    int? page,
    int? limit,
  }) async {
    final queryParams = <String, dynamic>{
      'limit': limit ?? 50,
      'page': ?page,
      'workshop_id': ?workshopId,
      'category_id': ?categoryId,
      if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      if (vehicleType != null && vehicleType.isNotEmpty && vehicleType != 'all')
        'vehicle_type': vehicleType,
      'is_ev': ?isEv,
    };
    final endpoint = (search != null && search.trim().isNotEmpty)
        ? ApiEndpoints.variantsSearch
        : ApiEndpoints.variants;
    final response = await apiClient.get(
      endpoint,
      queryParameters: queryParams,
    );
    if (response.statusCode == 200 && response.data != null) {
      final rawData = response.data['data'] as List<dynamic>? ?? [];
      return rawData
          .map((e) => VariantModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw const ServerException(message: 'Gagal memuat katalog produk suku cadang.');
  }

  @override
  Future<List<RegencyModel>> searchRegencies(String query) async {
    final response = await apiClient.get(
      ApiEndpoints.regencies,
      queryParameters: {
        if (query.trim().isNotEmpty) 'search': query.trim(),
      },
    );
    if (response.statusCode == 200 && response.data != null) {
      final rawData = response.data['data'] as List<dynamic>? ?? [];
      return rawData
          .map((e) => RegencyModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw const ServerException(message: 'Gagal memuat daftar kota/kabupaten.');
  }

  @override
  Future<List<BookingAvailabilityModel>> getAvailability({
    required int workshopId,
    required String bookingDate,
    String? excludeTicket,
  }) async {
    final response = await apiClient.get(
      ApiEndpoints.bookingAvailability,
      queryParameters: {
        'workshop_id': workshopId,
        'booking_date': bookingDate,
        if (excludeTicket != null && excludeTicket.isNotEmpty)
          'exclude_ticket': excludeTicket,
      },
    );
    if (response.statusCode == 200 && response.data != null) {
      final rawData = response.data['data'];
      if (rawData is List) {
        return rawData
            .map((e) => BookingAvailabilityModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    }
    return const [];
  }

  @override
  Future<void> previewBooking({
    required int workshopId,
    required String bookingDate,
    required String hour,
    required String customerPhone,
    String? customerEmail,
    required List<int> serviceIds,
    required List<int> packageIds,
    List<BookingVariantItemEntity> variantItems = const [],
    required bool isEv,
  }) async {
    final payload = {
      'workshop_id': workshopId,
      'booking_date': bookingDate,
      'hour': hour,
      if (customerPhone.trim().isNotEmpty) 'customer_phone': customerPhone.trim(),
      if (customerEmail != null && customerEmail.trim().isNotEmpty)
        'customer_email': customerEmail.trim(),
      'service_items': serviceIds.map((id) => {'service_id': id}).toList(),
      'package_items': packageIds.map((id) => {'package_id': id}).toList(),
      'variant_items': variantItems.map((v) => v.toJson()).toList(),
      'is_ev': isEv,
    };

    await apiClient.post(ApiEndpoints.bookingPreview, data: payload);
  }

  @override
  Future<void> cancelPreviewBooking({
    required int workshopId,
    required String bookingDate,
    required String hour,
    required String customerPhone,
    String? customerEmail,
  }) async {
    final payload = {
      'workshop_id': workshopId,
      'booking_date': bookingDate,
      'hour': hour,
      if (customerPhone.trim().isNotEmpty) 'customer_phone': customerPhone.trim(),
      if (customerEmail != null && customerEmail.trim().isNotEmpty)
        'customer_email': customerEmail.trim(),
    };

    await apiClient.post(ApiEndpoints.bookingCancelPreview, data: payload);
  }

  @override
  Future<List<VoucherModel>> getAvailableVouchers({
    int? workshopId,
    String? date,
    String? time,
  }) async {
    final response = await apiClient.get(
      ApiEndpoints.vouchers,
      queryParameters: {
        'workshop_id': ?workshopId,
        'date': ?date,
        'time': ?time,
      },
    );
    if (response.statusCode == 200 && response.data != null) {
      final rawData = response.data['data'] as List<dynamic>? ?? [];
      return rawData
          .map((e) => VoucherModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return const [];
  }

  @override
  Future<VoucherValidationResultModel> validateVoucher({
    required int voucherId,
    required String vehicleType,
    required String bookingDate,
    required String hour,
    required bool isEv,
    required int workshopId,
    required List<int> serviceIds,
    required List<int> packageIds,
    List<BookingVariantItemEntity> variantItems = const [],
  }) async {
    final response = await apiClient.post(
      ApiEndpoints.validateVoucher,
      data: {
        'voucher_id': voucherId,
        'vehicle_type': vehicleType,
        'booking_date': bookingDate,
        'hour': hour,
        'is_ev': isEv,
        'workshop_id': workshopId,
        'service_items': serviceIds.map((id) => {'service_id': id}).toList(),
        'package_items': packageIds.map((id) => {'package_id': id}).toList(),
        'variant_items': variantItems.map((v) => v.toJson()).toList(),
      },
    );
    if (response.statusCode == 200 && response.data != null) {
      final data = response.data['data'] as Map<String, dynamic>? ?? {};
      return VoucherValidationResultModel.fromJson(data);
    }
    throw const ServerException(message: 'Gagal memvalidasi kode voucher.');
  }

  @override
  Future<BookingModel> submitBooking(BookingModel booking) async {
    final response = await apiClient.post(
      ApiEndpoints.bookings,
      data: booking.toCreateJson(),
    );
    if ((response.statusCode == 200 || response.statusCode == 201) &&
        response.data != null) {
      final data = response.data['data'] as Map<String, dynamic>? ??
          response.data as Map<String, dynamic>;
      return BookingModel.fromJson(data);
    }
    throw const ServerException(message: 'Gagal membuat reservasi booking.');
  }

  @override
  Future<BookingModel> updateBooking(String ticket, BookingModel booking) async {
    final response = await apiClient.patch(
      '${ApiEndpoints.bookings}/$ticket',
      data: booking.toCreateJson(),
    );
    if (response.statusCode == 200 && response.data != null) {
      final data = response.data['data'] as Map<String, dynamic>? ??
          response.data as Map<String, dynamic>;
      return BookingModel.fromJson(data);
    }
    throw const ServerException(message: 'Gagal memperbarui reservasi booking.');
  }

  @override
  Future<BookingModel> getBookingByTicket(String ticket) async {
    final response = await apiClient.get('${ApiEndpoints.bookings}/$ticket');
    if (response.statusCode == 200 && response.data != null) {
      final data = response.data['data'] as Map<String, dynamic>;
      return BookingModel.fromJson(data);
    }
    throw const ServerException(message: 'Tiket reservasi tidak ditemukan.');
  }
}
