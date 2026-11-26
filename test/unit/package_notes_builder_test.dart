import 'package:flutter_test/flutter_test.dart';
import 'package:nine_apps/features/garage/domain/entities/package_entity.dart';
import 'package:nine_apps/features/garage/domain/entities/variant_entity.dart';
import 'package:nine_apps/features/garage/domain/utils/package_notes_builder.dart';

void main() {
  group('PackageNotesBuilder', () {
    const package = PackageEntity(
      id: 1,
      name: 'Q2 PRO - SET',
      description: 'Paket Lengkap',
      price: 1500000,
      nowPrice: 1200000,
    );

    const childShroud = VariantEntity(
      id: 201,
      name: 'BMW Sport Shroud Black',
      price: 200000,
      nowPrice: 180000,
      stock: 10,
    );

    const childDemonEye = VariantEntity(
      id: 202,
      name: 'Devil Eye Ice Blue',
      price: 150000,
      nowPrice: 120000,
      stock: 8,
    );

    const parentVariant = VariantEntity(
      id: 10,
      name: 'Opsi Aksesoris',
      price: 0,
      nowPrice: 0,
      children: [childShroud, childDemonEye],
    );

    test('buildPackageNotes builds correct string for selected package sub-variants', () {
      final notes = PackageNotesBuilder.buildPackageNotes(
        selectedPackages: [package],
        selectedPackageChildren: {
          1: {10: 201, 11: 202},
        },
        allVariants: [parentVariant],
      );

      expect(notes, contains('Pilihan Varian Paket [Q2 PRO - SET]:'));
      expect(notes, contains('BMW Sport Shroud Black'));
      expect(notes, contains('Devil Eye Ice Blue'));
    });

    test('buildPackageNotes returns empty string when no selections made', () {
      final notes = PackageNotesBuilder.buildPackageNotes(
        selectedPackages: [package],
        selectedPackageChildren: const {},
        allVariants: [parentVariant],
      );

      expect(notes, isEmpty);
    });

    test('mergeBookingNotes combines customer notes with package notes cleanly', () {
      const customerNotes = 'Mohon kabel dirapikan pakai spiral.';
      const packageNotes = 'Pilihan Varian Paket [Q2 PRO - SET]: BMW Sport Shroud Black';

      final merged = PackageNotesBuilder.mergeBookingNotes(
        customerNotes: customerNotes,
        packageNotes: packageNotes,
      );

      expect(merged, equals('$customerNotes\n\n$packageNotes'));
    });

    test('mergeBookingNotes replaces previous package notes if customer updates sub-variants', () {
      const oldNotes = 'Mohon rapih.\n\nPilihan Varian Paket [Q2 PRO - SET]: Old Shroud';
      const newPackageNotes = 'Pilihan Varian Paket [Q2 PRO - SET]: BMW Sport Shroud Black';

      final merged = PackageNotesBuilder.mergeBookingNotes(
        customerNotes: oldNotes,
        packageNotes: newPackageNotes,
      );

      expect(merged, equals('Mohon rapih.\n\n$newPackageNotes'));
      expect(merged.contains('Old Shroud'), isFalse);
    });
  });
}
