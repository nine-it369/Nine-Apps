import 'flavor.dart';

/// Production-grade compile-time environment configuration with binary splitting.
/// Values are injected at compile time via:
/// flutter build apk --release --obfuscate --split-debug-info=build/symbols --dart-define-from-file=config/env/.env.prod.json
///
/// Keuntungan:
/// 1. Tidak ada file `.env` mentah di dalam bundle assets APK/IPA (anti-unzip).
/// 2. Nilai terkompilasi langsung ke dalam AOT machine code (`libapp.so` / iOS Mach-O).
/// 3. Setiap binary (Dev, Staging, Prod) hanya membawa konfigurasi miliknya sendiri (Dead-code elimination).
/// 4. Saat di-reverse engineering dengan JADX atau strings, tidak dapat mengekstrak kredensial environment lain.
class EnvConfig {
  final Flavor flavor;
  final String apiBaseUrl;
  final String mallApiBaseUrl;
  final int connectTimeoutMs;
  final int receiveTimeoutMs;
  final bool enableTelemetryLogging;

  const EnvConfig({
    required this.flavor,
    required this.apiBaseUrl,
    required this.mallApiBaseUrl,
    this.connectTimeoutMs = 15000,
    this.receiveTimeoutMs = 15000,
    this.enableTelemetryLogging = false,
  });

  // Compile-time constants injected via --dart-define or --dart-define-from-file
  static const String _envFlavor = String.fromEnvironment(
    'FLAVOR',
    defaultValue: 'dev',
  );

  static const String _envApiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  static const String _envMallApiBaseUrl = String.fromEnvironment(
    'MALL_API_BASE_URL',
    defaultValue: '',
  );

  static const int _envConnectTimeout = int.fromEnvironment(
    'CONNECT_TIMEOUT_MS',
    defaultValue: 15000,
  );

  static const int _envReceiveTimeout = int.fromEnvironment(
    'RECEIVE_TIMEOUT_MS',
    defaultValue: 15000,
  );

  static const bool _envEnableLogging = bool.fromEnvironment(
    'ENABLE_LOGGING',
    defaultValue: true,
  );

  /// Active environment resolved strictly at compile time for the current binary
  static final EnvConfig current = _resolveConfig();

  static EnvConfig _resolveConfig() {
    switch (_envFlavor) {
      case 'prod':
      case 'production':
        return const EnvConfig(
          flavor: Flavor.prod,
          apiBaseUrl: _envApiBaseUrl == ''
              ? 'https://garage.nine.co.id/api/v1'
              : _envApiBaseUrl,
          mallApiBaseUrl: _envMallApiBaseUrl == ''
              ? 'https://mall.nine.co.id/api/v1'
              : _envMallApiBaseUrl,
          connectTimeoutMs: _envConnectTimeout,
          receiveTimeoutMs: _envReceiveTimeout,
          enableTelemetryLogging: false,
        );
      case 'staging':
        return const EnvConfig(
          flavor: Flavor.staging,
          apiBaseUrl: _envApiBaseUrl == ''
              ? 'https://dev-garage.nine.co.id/api/v1'
              : _envApiBaseUrl,
          mallApiBaseUrl: _envMallApiBaseUrl == ''
              ? 'https://dev-mall.nine.co.id/api/v1'
              : _envMallApiBaseUrl,
          connectTimeoutMs: _envConnectTimeout,
          receiveTimeoutMs: _envReceiveTimeout,
          enableTelemetryLogging: _envEnableLogging,
        );
      case 'dev':
      default:
        return const EnvConfig(
          flavor: Flavor.dev,
          apiBaseUrl: _envApiBaseUrl == ''
              ? 'http://localhost:8080/api/v1'
              : _envApiBaseUrl,
          mallApiBaseUrl: _envMallApiBaseUrl == ''
              ? 'http://localhost:8081/api/v1'
              : _envMallApiBaseUrl,
          connectTimeoutMs: _envConnectTimeout,
          receiveTimeoutMs: _envReceiveTimeout,
          enableTelemetryLogging: _envEnableLogging,
        );
    }
  }

  bool get isDev => flavor == Flavor.dev;
  bool get isStaging => flavor == Flavor.staging;
  bool get isProd => flavor == Flavor.prod;
}
