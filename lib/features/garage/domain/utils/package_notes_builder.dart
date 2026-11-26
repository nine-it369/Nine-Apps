import '../entities/package_entity.dart';
import '../entities/variant_entity.dart';

class PackageNotesBuilder {
  /// Membentuk catatan pilihan sub-varian paket seperti pada web:
  /// "Pilihan Varian Paket [Nama Paket]: Sub Varian A, Sub Varian B"
  static String buildPackageNotes({
    required List<PackageEntity> selectedPackages,
    required Map<int, Map<int, int>> selectedPackageChildren,
    required List<VariantEntity> allVariants,
  }) {
    final List<String> packageNotes = [];

    for (final pkg in selectedPackages) {
      final packageSelections = selectedPackageChildren[pkg.id];
      if (packageSelections == null || packageSelections.isEmpty) continue;

      final List<String> childDetails = [];
      packageSelections.forEach((parentVariantId, childVariantId) {
        final childVariant = _findVariantById(childVariantId, allVariants);
        if (childVariant != null && childVariant.name.isNotEmpty) {
          childDetails.add(childVariant.displayName);
        }
      });

      if (childDetails.isNotEmpty) {
        packageNotes.add('Pilihan Varian Paket [${pkg.name}]: ${childDetails.join(", ")}');
      }
    }

    return packageNotes.join('\n');
  }

  /// Menggabungkan catatan customer dengan catatan pilihan sub-varian paket
  static String mergeBookingNotes({
    String? customerNotes,
    required String packageNotes,
  }) {
    var notes = (customerNotes ?? '').trim();
    if (notes.isNotEmpty) {
      notes = notes
          .split('\n')
          .where((line) => !line.trim().startsWith('Pilihan Varian Paket'))
          .join('\n')
          .trim();
    }

    if (packageNotes.isNotEmpty) {
      return notes.isNotEmpty ? '$notes\n\n$packageNotes' : packageNotes;
    }
    return notes;
  }

  static VariantEntity? _findVariantById(int id, List<VariantEntity> allVariants) {
    for (final v in allVariants) {
      if (v.id == id) return v;
      for (final c in v.children) {
        if (c.id == id) return c;
      }
    }
    return null;
  }
}
