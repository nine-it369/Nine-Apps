import '../entities/booking_availability_entity.dart';
import '../entities/booking_variant_item_entity.dart';
import '../entities/package_entity.dart';
import '../entities/service_entity.dart';
import '../entities/variant_entity.dart';

class SlotValidationResult {
  final bool isValid;
  final List<String> conflictingSlots;
  final List<String> conflictReasons; // 'capacity', 'booked', 'locked', 'outside_hours'
  final List<String> suggestedSlots;
  final int requiredDuration;
  final int requiredSlots;
  final int requiredTechnicians;

  const SlotValidationResult({
    required this.isValid,
    this.conflictingSlots = const [],
    this.conflictReasons = const [],
    this.suggestedSlots = const [],
    required this.requiredDuration,
    required this.requiredSlots,
    required this.requiredTechnicians,
  });
}

class SlotCalculator {
  static const int workingMinutesPerDay = 540; // 9 jam operasional standar bengkel

  /// Menghitung total estimasi durasi dalam menit dari seluruh layanan, paket, dan varian yang dipilih.
  static int calculateEstimatedMinutes({
    required List<ServiceEntity> selectedServices,
    required List<PackageEntity> selectedPackages,
    required List<BookingVariantItemEntity> selectedVariants,
    required List<VariantEntity> allVariants,
    bool isEv = false,
  }) {
    int totalMinutes = 0;

    // 1. Layanan Satuan
    for (final service in selectedServices) {
      totalMinutes += service.estimatedMinutes > 0 ? service.estimatedMinutes : 30;
    }

    // 2. Paket Layanan (120 menit default jika tidak ada sub-service terinci)
    for (final _ in selectedPackages) {
      totalMinutes += 120;
    }

    // 3. Varian Produk Mandiri dengan Jasa Pasang (Durasi instalasi paralel: diambil nilai maksimum)
    int maxVariantMinutes = 0;
    for (final v in selectedVariants) {
      // Abaikan jika merupakan sub-varian milik paket atau tanpa instalasi
      if (v.packageId != null && v.packageId! > 0) continue;
      if (!v.withInstallation) continue;

      final variantObj = _findVariant(v.variantId, allVariants);
      int mins = variantObj?.estimatedMinutes ?? 0;
      if (mins > maxVariantMinutes) {
        maxVariantMinutes = mins;
      }
    }
    totalMinutes += maxVariantMinutes;

    return totalMinutes > 0 ? totalMinutes : 30;
  }

  /// Menghitung jumlah teknisi konkuren yang dibutuhkan.
  static int calculateRequiredTechnicians({
    required List<ServiceEntity> selectedServices,
    required List<PackageEntity> selectedPackages,
    required List<BookingVariantItemEntity> selectedVariants,
    required List<VariantEntity> allVariants,
  }) {
    int maxTech = 0;
    bool hasSelectedItems = false;
    bool hasZeroTech = false;

    for (final s in selectedServices) {
      hasSelectedItems = true;
      if (s.requiredTechnicians == 0) {
        hasZeroTech = true;
      } else if (s.requiredTechnicians > maxTech) {
        maxTech = s.requiredTechnicians;
      }
    }

    for (final _ in selectedPackages) {
      hasSelectedItems = true;
      if (1 > maxTech) maxTech = 1;
    }

    for (final v in selectedVariants) {
      if (v.packageId != null && v.packageId! > 0) continue;
      if (!v.withInstallation) continue;

      hasSelectedItems = true;
      final variantObj = _findVariant(v.variantId, allVariants);
      final req = variantObj?.requiredTechnicians ?? 1;
      if (req > maxTech) maxTech = req;
    }

    if (!hasSelectedItems || hasZeroTech) return 0;
    return maxTech > 0 ? maxTech : 1;
  }

  /// Jumlah slot 30 menit yang dibutuhkan
  static int slotsNeeded(int minutes) {
    if (minutes <= 0) return 1;
    return (minutes / 30).ceil();
  }

  /// Mencari slot awal alternatif yang memiliki ketersediaan berurutan (Paritas 100% Web Frontend)
  static List<String> findAvailableConsecutiveSlots({
    required List<BookingAvailabilityEntity> availability,
    required int neededSlots,
    required int techniciansNeeded,
  }) {
    final suggestions = <String>[];

    for (final slot in availability) {
      final isAvailable =
          slot.status == 'available' || (techniciansNeeded == 0 && slot.status == 'full');
      final hasCapacity =
          techniciansNeeded == 0 || slot.remainingCapacity >= techniciansNeeded;

      if (isAvailable && hasCapacity) {
        suggestions.add(slot.hour);
      }
    }

    return suggestions;
  }

  /// Validasi slot yang dipilih apakah berurutan dan cukup kapasitas teknisinya (Paritas 100% Web Frontend)
  static SlotValidationResult validateConsecutiveSlots({
    required String startHour,
    required List<BookingAvailabilityEntity> availability,
    required int totalMinutes,
    required int techniciansNeeded,
  }) {
    final needed = slotsNeeded(totalMinutes);
    final startIndex = availability.indexWhere((a) => a.hour == startHour);
    final conflictingSlots = <String>[];
    final conflictReasons = <String>[];

    if (startIndex == -1) {
      return SlotValidationResult(
        isValid: false,
        conflictingSlots: [startHour],
        conflictReasons: ['outside_hours'],
        suggestedSlots: const [],
        requiredDuration: totalMinutes,
        requiredSlots: needed,
        requiredTechnicians: techniciansNeeded,
      );
    }

    final slot = availability[startIndex];
    final isAvailable =
        slot.status == 'available' || (techniciansNeeded == 0 && slot.status == 'full');
    final hasCapacity =
        techniciansNeeded == 0 || slot.remainingCapacity >= techniciansNeeded;

    if (!isAvailable || !hasCapacity) {
      conflictingSlots.add(startHour);
      conflictReasons.add(!hasCapacity ? 'capacity' : 'booked');
    }

    final suggested = findAvailableConsecutiveSlots(
      availability: availability,
      neededSlots: needed,
      techniciansNeeded: techniciansNeeded,
    );

    return SlotValidationResult(
      isValid: conflictingSlots.isEmpty,
      conflictingSlots: conflictingSlots,
      conflictReasons: conflictReasons,
      suggestedSlots: suggested.take(3).toList(),
      requiredDuration: totalMinutes,
      requiredSlots: needed,
      requiredTechnicians: techniciansNeeded,
    );
  }

  static VariantEntity? _findVariant(int variantId, List<VariantEntity> allVariants) {
    for (final v in allVariants) {
      if (v.id == variantId) return v;
      for (final child in v.children) {
        if (child.id == variantId) return child;
      }
    }
    return null;
  }
}
