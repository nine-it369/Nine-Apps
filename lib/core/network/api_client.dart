import 'package:dio/dio.dart';
import '../config/env_config.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/idempotency_interceptor.dart';

class ApiClient {
  final Dio dio;
  final AuthInterceptor authInterceptor;

  ApiClient({
    required this.dio,
    required this.authInterceptor,
  });

  String get baseUrl => dio.options.baseUrl;

  factory ApiClient.create({
    EnvConfig? config,
    String? customBaseUrl,
    AuthInterceptor? sharedAuth,
  }) {
    final env = config ?? EnvConfig.current;
    final auth = sharedAuth ?? AuthInterceptor();

    final dio = Dio(
      BaseOptions(
        baseUrl: customBaseUrl ?? env.apiBaseUrl,
        connectTimeout: Duration(milliseconds: env.connectTimeoutMs),
        receiveTimeout: Duration(milliseconds: env.receiveTimeoutMs),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      auth,
      IdempotencyInterceptor(),
      ErrorInterceptor(),
    ]);

    return ApiClient(
      dio: dio,
      authInterceptor: auth,
    );
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return dio.get<T>(path, queryParameters: queryParameters, options: options);
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return dio.post<T>(path, data: data, queryParameters: queryParameters, options: options);
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return dio.put<T>(path, data: data, queryParameters: queryParameters, options: options);
  }

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return dio.patch<T>(path, data: data, queryParameters: queryParameters, options: options);
  }
}
