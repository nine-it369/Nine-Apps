class ServerException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic details;

  const ServerException({
    required this.message,
    this.statusCode,
    this.details,
  });

  @override
  String toString() => 'ServerException: $message (code: $statusCode)';
}

class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'Koneksi jaringan terputus']);
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Gagal memproses data lokal']);
}
