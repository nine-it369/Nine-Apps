import 'flavor.dart';

class EnvConfig {
  final Flavor flavor;
  final String apiBaseUrl;
  final int connectTimeoutMs;
  final int receiveTimeoutMs;

  const EnvConfig({
    required this.flavor,
    required this.apiBaseUrl,
    this.connectTimeoutMs = 15000,
    this.receiveTimeoutMs = 15000,
  });

  static EnvConfig dev = const EnvConfig(
    flavor: Flavor.dev,
    // Web & desktop default to localhost:8080/api/v1 (garage-api)
    apiBaseUrl: 'http://localhost:8080/api/v1',
  );

  static EnvConfig staging = const EnvConfig(
    flavor: Flavor.staging,
    apiBaseUrl: 'https://dev-garage.nine.co.id/api/v1',
  );

  static EnvConfig prod = const EnvConfig(
    flavor: Flavor.prod,
    apiBaseUrl: 'https://garage.nine.co.id/api/v1',
  );

  static EnvConfig current = dev;
}
