import 'package:dio/dio.dart';
import '../../errors/exceptions.dart';
import '../../utils/error_sanitizer.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final int? statusCode = err.response?.statusCode;
    dynamic details;

    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError) {
      const netEx = NetworkException(
        'Koneksi ke sistem terputus. Pastikan koneksi internet Anda aktif.',
      );
      return handler.reject(
        err.copyWith(error: netEx, message: netEx.message),
      );
    }

    String rawMessage = '';
    if (err.response?.data is Map) {
      final data = err.response!.data as Map;
      rawMessage = data['message']?.toString() ?? data['error']?.toString() ?? '';
      details = data['errors'] ?? data['details'];
    } else if (err.response?.data is String) {
      rawMessage = err.response!.data as String;
    }

    final friendlyMessage = ErrorSanitizer.sanitize(
      rawMessage.isNotEmpty ? rawMessage : err.message,
    );

    final serverEx = ServerException(
      message: friendlyMessage,
      statusCode: statusCode,
      details: details,
    );

    handler.reject(
      err.copyWith(error: serverEx, message: friendlyMessage),
    );
  }
}
