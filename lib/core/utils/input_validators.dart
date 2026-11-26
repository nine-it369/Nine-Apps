class InputValidators {
  InputValidators._();

  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static final RegExp _phoneCleanRegex = RegExp(r'[^0-9]');

  static String? required(String? value, [String message = 'Wajib diisi']) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  static String? name(String? value) {
    if (value == null || value.trim().length < 3) {
      return 'Nama lengkap minimal 3 karakter';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nomor WhatsApp wajib diisi';
    }
    final cleanPhone = value.replaceAll(_phoneCleanRegex, '');
    if (cleanPhone.length < 9 || cleanPhone.length > 15) {
      return 'Nomor WhatsApp tidak valid (9-15 digit)';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Opsional jika no WhatsApp terisi
    }
    if (!_emailRegex.hasMatch(value.trim())) {
      return 'Format email tidak valid';
    }
    return null;
  }

  static String? licensePlate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nomor polisi wajib diisi';
    }
    final upper = value.trim().toUpperCase();
    if (upper.length < 3 || upper.length > 15) {
      return 'Format plat nomor tidak valid';
    }
    return null;
  }

  static String normalizePhoneForBackend(String raw) {
    final digits = raw.replaceAll(_phoneCleanRegex, '');
    if (digits.startsWith('08')) {
      return '62${digits.substring(1)}';
    }
    return digits;
  }
}
