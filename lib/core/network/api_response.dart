class ApiResponse<T> {
  final String status;
  final int code;
  final String message;
  final T? data;
  final Map<String, dynamic>? meta;

  const ApiResponse({
    required this.status,
    required this.code,
    required this.message,
    this.data,
    this.meta,
  });

  bool get isSuccess => status == 'success' || (code >= 200 && code < 300);

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic rawData) fromJsonT,
  ) {
    return ApiResponse<T>(
      status: json['status']?.toString() ?? 'unknown',
      code: json['code'] is int ? json['code'] as int : int.tryParse(json['code']?.toString() ?? '200') ?? 200,
      message: json['message']?.toString() ?? '',
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      meta: json['meta'] is Map<String, dynamic> ? json['meta'] as Map<String, dynamic> : null,
    );
  }
}
