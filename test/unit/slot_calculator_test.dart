import 'package:flutter_test/flutter_test.dart';
import 'package:nine_apps/features/garage/domain/entities/booking_availability_entity.dart';
import 'package:nine_apps/features/garage/domain/entities/booking_variant_item_entity.dart';
import 'package:nine_apps/features/garage/domain/entities/package_entity.dart';
import 'package:nine_apps/features/garage/domain/entities/service_entity.dart';
import 'package:nine_apps/features/garage/domain/entities/variant_entity.dart';
import 'package:nine_apps/features/garage/domain/utils/slot_calculator.dart';

void main() {
  group('SlotCalculator - Duration & Technicians', () {
    const serviceA = ServiceEntity(
      id: 1,
      name: 'Pemasangan Proyektor Biled',
      shortDesc: 'Pasang proyektor biled berkualitas',
      vehicleType: 'car',
      isEv: false,
      estimatedMinutes: 180,
      requiredTechnicians: 2,
      warrantyMonths: 12,
      price: 1500000,
      nowPrice: 1300000,
    );

    const serviceB = ServiceEntity(
      id: 2,
      name: 'Pemasangan DRL Laser',
      shortDesc: 'Pasang lampu DRL alis laser',
      vehicleType: 'car',
      isEv: false,
      estimatedMinutes: 60,
      requiredTechnicians: 1,
      warrantyMonths: 6,
      price: 450000,
      nowPrice: 400000,
    );

    const packageA = PackageEntity(
      id: 10,
      name: 'Paket Ultimate Bi-LED',
      description: 'Lengkap Biled + Shroud + Devil Eye',
      price: 2500000,
      nowPrice: 2000000,
    );

    const variantStandalone = VariantEntity(
      id: 101,
      name: 'Demon Eye RGB Bluetooth',
      price: 350000,
      nowPrice: 300000,
      installationPrice: 150000,
      installationPricePromo: 100000,
      estimatedMinutes: 90,
      requiredTechnicians: 1,
      stock: 5,
    );

    test('calculateEstimatedMinutes sums services and packages', () {
      final total = SlotCalculator.calculateEstimatedMinutes(
        selectedServices: [serviceA, serviceB], // 180 + 60 = 240
        selectedPackages: [packageA], // 120
        selectedVariants: const [],
        allVariants: const [],
      );

      expect(total, 360);
    });

    test('calculateEstimatedMinutes includes variant installation time', () {
      final total = SlotCalculator.calculateEstimatedMinutes(
        selectedServices: [serviceB], // 60
        selectedPackages: const [],
        selectedVariants: const [
          BookingVariantItemEntity(variantId: 101, withInstallation: true),
        ],
        allVariants: [variantStandalone], // 90 min max
      );

      expect(total, 150); // 60 + 90
    });

    test('calculateEstimatedMinutes ignores variant if withInstallation is false', () {
      final total = SlotCalculator.calculateEstimatedMinutes(
        selectedServices: [serviceB], // 60
        selectedPackages: const [],
        selectedVariants: const [
          BookingVariantItemEntity(variantId: 101, withInstallation: false),
        ],
        allVariants: [variantStandalone],
      );

      expect(total, 60);
    });

    test('calculateRequiredTechnicians takes the maximum required technicians', () {
      final techs = SlotCalculator.calculateRequiredTechnicians(
        selectedServices: [serviceA, serviceB], // max(2, 1) = 2
        selectedPackages: [packageA], // 1
        selectedVariants: const [],
        allVariants: const [],
      );

      expect(techs, 2);
    });
  });

  group('SlotCalculator - Consecutive Slot Validation', () {
    final availability = [
      const BookingAvailabilityEntity(hour: '09:00', status: 'available', remainingCapacity: 2),
      const BookingAvailabilityEntity(hour: '10:00', status: 'available', remainingCapacity: 2),
      const BookingAvailabilityEntity(hour: '11:00', status: 'full', remainingCapacity: 0),
      const BookingAvailabilityEntity(hour: '12:00', status: 'break', remainingCapacity: 0),
      const BookingAvailabilityEntity(hour: '13:00', status: 'available', remainingCapacity: 2),
      const BookingAvailabilityEntity(hour: '14:00', status: 'available', remainingCapacity: 2),
      const BookingAvailabilityEntity(hour: '15:00', status: 'available', remainingCapacity: 2),
      const BookingAvailabilityEntity(hour: '16:00', status: 'available', remainingCapacity: 1),
    ];

    test('returns valid when selected slot has sufficient capacity', () {
      final result = SlotCalculator.validateConsecutiveSlots(
        startHour: '09:00',
        totalMinutes: 120,
        techniciansNeeded: 2,
        availability: availability,
      );

      expect(result.isValid, isTrue);
      expect(result.conflictingSlots, isEmpty);
      expect(result.requiredSlots, 4); // 120 / 30 = 4
    });

    test('returns invalid and conflicts when selected slot is full', () {
      final result = SlotCalculator.validateConsecutiveSlots(
        startHour: '11:00',
        totalMinutes: 120,
        techniciansNeeded: 2,
        availability: availability,
      );

      expect(result.isValid, isFalse);
      expect(result.conflictingSlots, contains('11:00'));
      expect(result.suggestedSlots, contains('09:00'));
      expect(result.suggestedSlots, contains('10:00'));
    });

    test('returns invalid when capacity is insufficient for required technicians', () {
      final result = SlotCalculator.validateConsecutiveSlots(
        startHour: '16:00',
        totalMinutes: 120,
        techniciansNeeded: 2,
        availability: availability,
      );

      expect(result.isValid, isFalse);
      expect(result.conflictingSlots, contains('16:00'));
      expect(result.conflictReasons, contains('capacity'));
    });
  });
}
