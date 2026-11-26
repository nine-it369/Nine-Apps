import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/booking_availability_model.dart';
import '../models/booking_model.dart';
import '../models/service_model.dart';
import '../models/workshop_model.dart';

abstract class IGarageRemoteDataSource {
  Future<List<WorkshopModel>> getWorkshops();
  Future<List<ServiceModel>> getServices({String? vehicleType});
  Future<List<BookingAvailabilityModel>> getAvailability({
    required int workshopId,
    required String bookingDate,
  });
  Future<BookingModel> submitBooking(BookingModel booking);
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
      return rawData.map((e) => WorkshopModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw const ServerException(message: 'Gagal mengambil data bengkel');
  }

  @override
  Future<List<ServiceModel>> getServices({String? vehicleType}) async {
    final queryParams = <String, dynamic>{
      'limit': 50,
      if (vehicleType != null && vehicleType != 'all') 'vehicle_type': vehicleType,
    };
    final response = await apiClient.get(
      ApiEndpoints.services,
      queryParameters: queryParams,
    );
    if (response.statusCode == 200 && response.data != null) {
      final rawData = response.data['data'] as List<dynamic>? ?? [];
      return rawData.map((e) => ServiceModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw const ServerException(message: 'Gagal mengambil katalog jasa');
  }

  @override
  Future<List<BookingAvailabilityModel>> getAvailability({
    required int workshopId,
    required String bookingDate,
  }) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.bookingAvailability,
        queryParameters: {
          'workshop_id': workshopId,
          'booking_date': bookingDate,
        },
      );
      if (response.statusCode == 200 && response.data != null) {
        final rawData = response.data['data'];
        if (rawData is List) {
          return rawData.map((e) => BookingAvailabilityModel.fromJson(e as Map<String, dynamic>)).toList();
        }
      }
    } catch (_) {
      // Fallback default operational time slots (09:00 - 16:00) jika endpoint availability belum disetup
    }

    return const [
      BookingAvailabilityModel(timeSlot: '09:00', isAvailable: true, availableCapacity: 3),
      BookingAvailabilityModel(timeSlot: '10:00', isAvailable: true, availableCapacity: 3),
      BookingAvailabilityModel(timeSlot: '11:00', isAvailable: true, availableCapacity: 2),
      BookingAvailabilityModel(timeSlot: '13:00', isAvailable: true, availableCapacity: 3),
      BookingAvailabilityModel(timeSlot: '14:00', isAvailable: true, availableCapacity: 3),
      BookingAvailabilityModel(timeSlot: '15:00', isAvailable: true, availableCapacity: 2),
      BookingAvailabilityModel(timeSlot: '16:00', isAvailable: true, availableCapacity: 1),
    ];
  }

  @override
  Future<BookingModel> submitBooking(BookingModel booking) async {
    final response = await apiClient.post(
      ApiEndpoints.bookings,
      data: booking.toJson(),
    );
    if ((response.statusCode == 200 || response.statusCode == 201) && response.data != null) {
      final data = response.data['data'] as Map<String, dynamic>? ?? response.data as Map<String, dynamic>;
      return BookingModel.fromJson(data);
    }
    throw const ServerException(message: 'Gagal membuat reservasi booking');
  }

  @override
  Future<BookingModel> getBookingByTicket(String ticket) async {
    final response = await apiClient.get('${ApiEndpoints.bookings}/$ticket');
    if (response.statusCode == 200 && response.data != null) {
      final data = response.data['data'] as Map<String, dynamic>;
      return BookingModel.fromJson(data);
    }
    throw const ServerException(message: 'Data booking tidak ditemukan');
  }
}
