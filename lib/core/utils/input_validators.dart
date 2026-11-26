class InputValidators {
  InputValidators._();

  static String? required(String? value, [String message = 'Wajib diisi']) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nomor WhatsApp wajib diisi';
    }
    final cleanPhone = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanPhone.length < 9 || cleanPhone.length > 15) {
      return 'Nomor WhatsApp tidak valid (9-15 digit)';
    }
    return null;
  }

  static String? licensePlate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nomor polisi wajib diisi';
    }
    final upper = value.trim().toUpperCase();
    if (upper.length < 3 || upper.length > 12) {
      return 'Format plat nomor tidak valid';
    }
    return null;
  }
}
