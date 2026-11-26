import 'package:intl/intl.dart';
import '../entities/package_entity.dart';
import '../entities/service_entity.dart';

class DurationCalculator {
  static const int workingMinutesPerDay = 540; // 9 jam per hari (09:00 - 18:00)

  /// Cek apakah ada layanan Bi-LED yang berpotensi membutuhkan pengerjaan multi-hari
  static bool hasBiledService({
    required List<ServiceEntity> services,
    required List<PackageEntity> packages,
  }) {
    for (final s in services) {
      if (isBiledServiceName(s.name)) return true;
    }
    for (final p in packages) {
      if (isBiledServiceName(p.name)) return true;
    }
    return false;
  }

  static bool isBiledServiceName(String? name) {
    if (name == null || name.isEmpty) return false;
    final lower = name.toLowerCase();
    return lower.contains('biled') || lower.contains('bi-led') || lower.contains('bi led');
  }

  /// Menghitung tanggal selesai (`end_date`) dan mendeteksi multi-day rollover
  static ({String endDate, bool isMultiDay}) calculateEndDate({
    required String startDateStr,
    required int totalEstimatedMinutes,
    String? startHourStr,
    required bool hasBiled,
    int closingHour = 18,
  }) {
    if (!hasBiled || totalEstimatedMinutes <= 0) {
      return (endDate: startDateStr, isMultiDay: false);
    }

    final dateFormat = DateFormat('yyyy-MM-dd');
    DateTime currentDate;
    try {
      currentDate = dateFormat.parse(startDateStr);
    } catch (_) {
      return (endDate: startDateStr, isMultiDay: false);
    }

    // Hitung kapasitas menit pengerjaan pada Hari 1 berdasarkan jam mulai
    int startMinutes = 9 * 60; // default 09:00
    if (startHourStr != null && startHourStr.contains(':')) {
      final parts = startHourStr.split(':');
      final h = int.tryParse(parts[0]) ?? 9;
      final m = int.tryParse(parts[1]) ?? 0;
      startMinutes = h * 60 + m;
    }

    final closingMinutes = closingHour * 60;
    final day1WorkingMinutes = (closingMinutes - startMinutes).clamp(0, workingMinutesPerDay);

    if (totalEstimatedMinutes <= day1WorkingMinutes) {
      return (endDate: startDateStr, isMultiDay: false);
    }

    // Melebihi hari pertama -> rollover hari
    int remainingMinutes = totalEstimatedMinutes - day1WorkingMinutes;
    currentDate = currentDate.add(const Duration(days: 1));

    int safetyCount = 0;
    while (remainingMinutes > 0 && safetyCount < 30) {
      safetyCount++;
      // Asumsi operasional bengkel: 540 menit per hari buka
      if (remainingMinutes <= workingMinutesPerDay) {
        break;
      }
      remainingMinutes -= workingMinutesPerDay;
      currentDate = currentDate.add(const Duration(days: 1));
    }

    final calculatedEndDate = dateFormat.format(currentDate);
    final isMulti = calculatedEndDate != startDateStr;
    return (endDate: calculatedEndDate, isMultiDay: isMulti);
  }
}
