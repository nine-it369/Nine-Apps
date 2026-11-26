class ApiEndpoints {
  ApiEndpoints._();

  // Garage Core Endpoints
  static const String workshops = '/workshops';
  static const String services = '/services';
  static const String bookings = '/bookings';
  static const String bookingAvailability = '/bookings/availability';
  static const String bookingPreview = '/bookings/preview';
  static const String bookingCancelPreview = '/bookings/cancel-preview';
  static const String customerBookings = '/customers/me/bookings';

  // Customer & Auth
  static const String loginOtp = '/auth/otp';
  static const String verifyOtp = '/auth/verify';
  static const String customerProfile = '/customers/me';
}
