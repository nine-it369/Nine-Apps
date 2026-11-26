class ApiEndpoints {
  ApiEndpoints._();

  // Garage Core Endpoints (Port 8080 /api/v1)
  static const String workshops = '/workshops';
  static const String services = '/services';
  static const String packages = '/packages';
  static const String regencies = '/regencies';
  static const String vouchers = '/vouchers';
  static const String validateVoucher = '/vouchers/validate';

  static const String bookings = '/bookings';
  static const String bookingAvailability = '/bookings/availability';
  static const String bookingPreview = '/bookings/preview';
  static const String bookingCancelPreview = '/bookings/cancel-preview';
  static const String customerBookings = '/customers/me/bookings';
  static const String workOrders = '/workorders';

  // Customer & Auth
  static const String loginOtp = '/auth/login';
  static const String register = '/auth/register';
  static const String customerProfile = '/customers/me';
}
