import 'package:dio/dio.dart';
import '../../errors/exceptions.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String message = 'Terjadi kesalahan pada server';
    int? statusCode = err.response?.statusCode;
    dynamic details;

    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError) {
      throw const NetworkException('Koneksi ke server terputus. Pastikan koneksi internet stabil.');
    }

    if (err.response != null && err.response?.data is Map) {
      final data = err.response!.data as Map;
      message = data['message']?.toString() ?? message;
      details = data['errors'] ?? data['details'];
    }

    throw ServerException(
      message: message,
      statusCode: statusCode,
      details: details,
    );
  }
}
