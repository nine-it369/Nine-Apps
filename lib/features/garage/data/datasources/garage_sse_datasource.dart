import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../../../../core/network/api_client.dart';

class BookingSseEvent {
  final int? workshopId;
  final String? date;
  final String? eventType;
  final String? status;
  final bool isHeartbeat;

  const BookingSseEvent({
    this.workshopId,
    this.date,
    this.eventType,
    this.status,
    this.isHeartbeat = false,
  });

  factory BookingSseEvent.heartbeat() => const BookingSseEvent(isHeartbeat: true);

  factory BookingSseEvent.fromJson(Map<String, dynamic> json, {String? eventType}) {
    return BookingSseEvent(
      workshopId: json['workshop_id'] is int
          ? json['workshop_id'] as int
          : int.tryParse(json['workshop_id']?.toString() ?? ''),
      date: json['booking_date']?.toString() ?? json['date']?.toString(),
      eventType: eventType ?? json['event']?.toString(),
      status: json['status']?.toString(),
      isHeartbeat: false,
    );
  }
}

abstract class IGarageSseDataSource {
  Stream<BookingSseEvent> subscribeToUpdates({
    required int workshopId,
    required String bookingDate,
  });
  void unsubscribe();
}

class GarageSseDataSourceImpl implements IGarageSseDataSource {
  final ApiClient apiClient;
  HttpClient? _client;
  HttpClientRequest? _activeRequest;
  StreamSubscription? _streamSub;
  StreamController<BookingSseEvent>? _controller;
  bool _isDisposed = false;

  GarageSseDataSourceImpl(this.apiClient);

  @override
  Stream<BookingSseEvent> subscribeToUpdates({
    required int workshopId,
    required String bookingDate,
  }) {
    unsubscribe();
    _isDisposed = false;
    _controller = StreamController<BookingSseEvent>.broadcast();

    _connect(workshopId, bookingDate, 0);

    return _controller!.stream;
  }

  Future<void> _connect(int workshopId, String bookingDate, int attempt) async {
    if (_isDisposed || _controller == null || _controller!.isClosed) return;

    try {
      _client = HttpClient();
      final uri = Uri.parse(
        '${apiClient.baseUrl}/bookings/updates?workshop_id=$workshopId&date=$bookingDate',
      );

      _activeRequest = await _client!.getUrl(uri);
      _activeRequest!.headers.set(HttpHeaders.acceptHeader, 'text/event-stream');
      _activeRequest!.headers.set(HttpHeaders.cacheControlHeader, 'no-cache');

      final response = await _activeRequest!.close();

      if (response.statusCode == HttpStatus.ok) {
        String? currentEvent;

        _streamSub = response
            .transform(utf8.decoder)
            .transform(const LineSplitter())
            .listen(
          (line) {
            final trimmed = line.trim();
            if (trimmed.isEmpty) {
              currentEvent = null;
              return;
            }

            if (trimmed.startsWith(':heartbeat')) {
              _controller?.add(BookingSseEvent.heartbeat());
              return;
            }

            if (trimmed.startsWith('event:')) {
              currentEvent = trimmed.substring(6).trim();
              return;
            }

            if (trimmed.startsWith('data:')) {
              final rawJson = trimmed.substring(5).trim();
              try {
                final decoded = jsonDecode(rawJson);
                if (decoded is Map<String, dynamic>) {
                  _controller?.add(BookingSseEvent.fromJson(decoded, eventType: currentEvent));
                }
              } catch (_) {
                // Non-json or raw text data
                _controller?.add(BookingSseEvent(eventType: currentEvent));
              }
            }
          },
          onError: (error) {
            _scheduleReconnect(workshopId, bookingDate, attempt + 1);
          },
          onDone: () {
            _scheduleReconnect(workshopId, bookingDate, attempt + 1);
          },
          cancelOnError: true,
        );
      } else {
        _scheduleReconnect(workshopId, bookingDate, attempt + 1);
      }
    } catch (_) {
      _scheduleReconnect(workshopId, bookingDate, attempt + 1);
    }
  }

  void _scheduleReconnect(int workshopId, String bookingDate, int attempt) {
    if (_isDisposed || attempt >= 5) return;
    final delaySeconds = (1 << attempt).clamp(1, 16);
    Future.delayed(Duration(seconds: delaySeconds), () {
      if (!_isDisposed) {
        _connect(workshopId, bookingDate, attempt);
      }
    });
  }

  @override
  void unsubscribe() {
    _isDisposed = true;
    _streamSub?.cancel();
    _streamSub = null;
    _activeRequest?.abort();
    _activeRequest = null;
    _client?.close(force: true);
    _client = null;
    _controller?.close();
    _controller = null;
  }
}
