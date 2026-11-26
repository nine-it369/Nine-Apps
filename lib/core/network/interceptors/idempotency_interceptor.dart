import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

class IdempotencyInterceptor extends Interceptor {
  static const _uuid = Uuid();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Apply Idempotency-Key header to mutations (POST, PUT, PATCH, DELETE)
    final method = options.method.toUpperCase();
    if (method == 'POST' || method == 'PUT' || method == 'PATCH' || method == 'DELETE') {
      if (!options.headers.containsKey('Idempotency-Key')) {
        options.headers['Idempotency-Key'] = _uuid.v4();
      }
    }
    handler.next(options);
  }
}
