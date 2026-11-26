class ErrorSanitizer {
  ErrorSanitizer._();

  static const String defaultFallback =
      'Terjadi kendala pada sistem. Silakan coba beberapa saat lagi.';

  static bool isTechnicalError(String? msg) {
    if (msg == null || msg.trim().isEmpty) return true;
    final lower = msg.toLowerCase().trim();

    if (lower.startsWith('{') || lower.startsWith('[') || lower.contains('object object')) {
      return true;
    }

    const technicalKeywords = [
      'dioexception',
      'socketexception',
      'failed host lookup',
      'econnrefused',
      'connection refused',
      'err_connection',
      'internal server error',
      'bad gateway',
      'service unavailable',
      'gateway timeout',
      'panic:',
      'runtime error:',
      'nil pointer',
      'sql:',
      'pq:',
      'sqlstate',
      'duplicate key value',
      'violates unique constraint',
      'violates foreign key',
      'relation does not exist',
      'column does not exist',
      'status code 5',
      'status code 4',
      'stack trace',
      'xmlhttprequest',
    ];

    return technicalKeywords.any(lower.contains);
  }

  static String sanitize(dynamic error, {String fallback = defaultFallback}) {
    if (error == null) return fallback;
    final raw = error.toString().trim();
    if (raw.isEmpty) return fallback;

    final lower = raw.toLowerCase();

    if (lower.contains('already have a booking with the same') ||
        (lower.contains('booking') && lower.contains('at this time'))) {
      return 'Anda sudah memiliki jadwal reservasi aktif untuk layanan yang sama pada jam ini. Silakan pilih waktu lain.';
    }

    if (lower.contains('already booked') ||
        lower.contains('is locked') ||
        lower.contains('held by another user') ||
        lower.contains('capacity is full')) {
      return 'Slot jam kedatangan ini baru saja dipesan atau sedang penuh. Silakan pilih jam atau tanggal lain.';
    }

    if (lower.contains('no available technicians')) {
      return 'Kapasitas mekanik pada jam tersebut sedang penuh. Silakan pilih waktu kedatangan lain.';
    }

    if (lower.contains('cannot book for a past date')) {
      return 'Tanggal kedatangan tidak boleh di masa lalu. Silakan pilih tanggal hari ini atau mendatang.';
    }

    if (lower.contains('connection') ||
        lower.contains('network') ||
        lower.contains('econnrefused') ||
        lower.contains('socket') ||
        lower.contains('xmlhttprequest')) {
      return 'Tidak dapat terhubung ke sistem. Pastikan koneksi internet Anda aktif, lalu coba lagi.';
    }

    if (lower.contains('timeout') || lower.contains('timed out') || lower.contains('504')) {
      return 'Sistem membutuhkan waktu terlalu lama untuk merespons. Silakan coba lagi.';
    }

    if (lower.contains('unauthorized') || lower.contains('401')) {
      return 'Sesi akun Anda telah berakhir. Silakan masuk kembali untuk melanjutkan.';
    }

    if (lower.contains('not found') || lower.contains('tidak ditemukan')) {
      return 'Data yang Anda cari tidak ditemukan atau telah diperbarui.';
    }

    if (isTechnicalError(raw)) {
      return fallback;
    }

    // Humanize remaining English backend validation hints if any
    if (lower.startsWith('cannot allocate schedule')) {
      return 'Jadwal bengkel belum tersedia untuk durasi pengerjaan tersebut. Silakan pilih jam lebih awal.';
    }

    return raw;
  }
}
