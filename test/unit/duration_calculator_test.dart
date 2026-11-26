import 'package:flutter_test/flutter_test.dart';
import 'package:nine_apps/features/garage/domain/entities/package_entity.dart';
import 'package:nine_apps/features/garage/domain/entities/service_entity.dart';
import 'package:nine_apps/features/garage/domain/utils/duration_calculator.dart';

void main() {
  group('DurationCalculator - Bi-LED Detection', () {
    test('isBiledServiceName detects various biled spellings', () {
      expect(DurationCalculator.isBiledServiceName('Jasa Pemasangan Bi-LED Projector'), isTrue);
      expect(DurationCalculator.isBiledServiceName('Paket Biled Matrix 3.0'), isTrue);
      expect(DurationCalculator.isBiledServiceName('Lampu Bi Led Turbo SE'), isTrue);
      expect(DurationCalculator.isBiledServiceName('Pemasangan Kaca Film'), isFalse);
      expect(DurationCalculator.isBiledServiceName('Klakson Denso'), isFalse);
      expect(DurationCalculator.isBiledServiceName(null), isFalse);
    });

    test('hasBiledService returns true if services or packages contain biled', () {
      const biledService = ServiceEntity(
        id: 1,
        name: 'Pasang Biled Q2',
        shortDesc: 'Pemasangan biled motor/mobil',
        vehicleType: 'car',
        isEv: false,
        estimatedMinutes: 180,
        requiredTechnicians: 1,
        warrantyMonths: 12,
        price: 1000000,
        nowPrice: 800000,
      );
      const regularService = ServiceEntity(
        id: 2,
        name: 'Cuci Lampu',
        shortDesc: 'Pembersihan mika lampu',
        vehicleType: 'car',
        isEv: false,
        estimatedMinutes: 30,
        requiredTechnicians: 1,
        warrantyMonths: 0,
        price: 200000,
        nowPrice: 150000,
      );
      const biledPackage = PackageEntity(
        id: 1,
        name: 'Paket Bi-LED All In',
        description: 'Lengkap',
        price: 2000000,
        nowPrice: 1800000,
      );

      expect(
        DurationCalculator.hasBiledService(services: [biledService], packages: const []),
        isTrue,
      );
      expect(
        DurationCalculator.hasBiledService(services: [regularService], packages: [biledPackage]),
        isTrue,
      );
      expect(
        DurationCalculator.hasBiledService(services: [regularService], packages: const []),
        isFalse,
      );
    });
  });

  group('DurationCalculator - End Date & Rollover Calculation', () {
    test('non-biled booking never triggers multi-day rollover', () {
      final result = DurationCalculator.calculateEndDate(
        startDateStr: '2026-11-28',
        totalEstimatedMinutes: 600,
        startHourStr: '16:00',
        hasBiled: false,
      );

      expect(result.isMultiDay, isFalse);
      expect(result.endDate, '2026-11-28');
    });

    test('biled booking finishing before 18:00 remains single day', () {
      // 09:00 start with 300 minutes (5 hours) -> finishes at 14:00 (before 18:00)
      final result = DurationCalculator.calculateEndDate(
        startDateStr: '2026-11-28',
        totalEstimatedMinutes: 300,
        startHourStr: '09:00',
        hasBiled: true,
      );

      expect(result.isMultiDay, isFalse);
      expect(result.endDate, '2026-11-28');
    });

    test('biled booking exceeding closing hour rolls over to next day', () {
      // 16:00 start with 240 minutes (4 hours):
      // Day 1 has only 2 hours (120 mins) before 18:00 closing.
      // Remaining 120 mins rollover to next day!
      final result = DurationCalculator.calculateEndDate(
        startDateStr: '2026-11-28',
        totalEstimatedMinutes: 240,
        startHourStr: '16:00',
        hasBiled: true,
      );

      expect(result.isMultiDay, isTrue);
      expect(result.endDate, '2026-11-29');
    });

    test('handles invalid date string gracefully', () {
      final result = DurationCalculator.calculateEndDate(
        startDateStr: 'invalid-date',
        totalEstimatedMinutes: 300,
        startHourStr: '16:00',
        hasBiled: true,
      );

      expect(result.isMultiDay, isFalse);
      expect(result.endDate, 'invalid-date');
    });
  });
}
