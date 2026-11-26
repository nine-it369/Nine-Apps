class AppConstants {
  AppConstants._();

  static const String appName = 'Nine AutoSeries';
  static const String defaultCurrency = 'IDR';
  static const int previewLockDurationSeconds = 600; // 10 menit capacity lock

  // Storage Keys
  static const String tokenKey = 'nine_access_token';
  static const String refreshTokenKey = 'nine_refresh_token';
  static const String activeVehicleKey = 'nine_active_vehicle';
}
