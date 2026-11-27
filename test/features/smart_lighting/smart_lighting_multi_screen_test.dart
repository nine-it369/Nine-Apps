import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nine_apps/app.dart';
import 'package:nine_apps/core/di/injection.dart';
import 'package:nine_apps/features/garage/domain/repositories/i_garage_repository.dart';
import 'package:nine_apps/features/garage/domain/usecases/get_workshops_usecase.dart';
import 'package:nine_apps/features/smart_lighting/presentation/widgets/home_hero_led_card.dart';
import '../../integration/booking_bloc_test.dart';

void main() {
  setUp(() async {
    await sl.reset();
    await configureDependencies();

    // Replace garage repo with deterministic fake for smoke tests
    await sl.unregister<IGarageRepository>();
    sl.registerLazySingleton<IGarageRepository>(() => FakeGarageRepository());
    await sl.unregister<GetWorkshopsUseCase>();
    sl.registerLazySingleton<GetWorkshopsUseCase>(
      () => GetWorkshopsUseCase(sl<IGarageRepository>()),
    );
  });

  group('Smart Lighting Across Multi-Screen Journey Tests', () {
    testWidgets('Full flow: HomeScreen -> AccessoriesScreen -> SmartLampStudioScreen with 7x4 DIY Grid', (tester) async {
      tester.view.physicalSize = const Size(800, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(const NineApp());
      await tester.pumpAndSettle();

      // ==========================================
      // 1. VERIFIKASI PADA HALAMAN HOME
      // ==========================================
      expect(find.text('SELAMAT PAGI,'), findsOneWidget);
      expect(find.byType(HomeHeroLedCard), findsOneWidget);
      expect(find.text('⚡ Khusus Nine (Matrix)'), findsOneWidget);
      expect(find.text('🌐 Lampu Universal'), findsOneWidget);
      expect(find.text('Buka Studio'), findsOneWidget);

      // Tap Segment Switcher on Home -> "🌐 Lampu Universal"
      await tester.tap(find.text('🌐 Lampu Universal'));
      await tester.pump(const Duration(milliseconds: 250));
      await tester.pumpAndSettle();
      expect(find.text('Universal'), findsWidgets);

      // Tap Segment Switcher on Home -> "⚡ Khusus Nine (Matrix)"
      await tester.tap(find.text('⚡ Khusus Nine (Matrix)'));
      await tester.pump(const Duration(milliseconds: 250));
      await tester.pumpAndSettle();
      expect(find.text('Khusus Nine'), findsWidgets);

      // ==========================================
      // 2. NAVIGASI KE HALAMAN AKSESORIS
      // ==========================================
      final aksesorisTab = find.text('Aksesoris');
      expect(aksesorisTab, findsOneWidget);
      await tester.tap(aksesorisTab);
      await tester.pumpAndSettle();

      // Verifikasi di Halaman Aksesoris (IoT Hub)
      expect(find.text('Aksesoris Terpasang'), findsOneWidget);
      expect(find.text('SMART LIGHTING IOT'), findsOneWidget);
      expect(find.text('Semua (4)'), findsOneWidget);
      expect(find.text('Smart LED (2)'), findsOneWidget);
      expect(find.text('Tautkan Aksesoris Baru'), findsOneWidget);

      // Filter chip Smart LED
      await tester.tap(find.text('Smart LED (2)'));
      await tester.pumpAndSettle();
      expect(find.text('SMART LIGHTING IOT'), findsOneWidget);

      // ==========================================
      // 3. NAVIGASI KE DETAIL STUDIO LAMPU
      // ==========================================
      final bukaStudioBtn = find.text('Buka Studio');
      expect(bukaStudioBtn, findsOneWidget);
      await tester.tap(bukaStudioBtn);
      await tester.pumpAndSettle();

      // Verifikasi Halaman Studio Lampu Cockpit
      expect(find.text('TEKS BERJALAN'), findsOneWidget);
      expect(find.text('NINE AUTOSERIES'), findsWidgets);
      expect(find.text('Buka Editor Matriks DIY (7x4 Grid Pixel)'), findsOneWidget);

      // Buka Modal 7x4 DIY Matrix Editor (Paritas NINE TL CB1..CB28)
      await tester.tap(find.text('Buka Editor Matriks DIY (7x4 Grid Pixel)'));
      await tester.pumpAndSettle();

      // Verifikasi elemen modal matriks
      expect(find.text('Matriks DIY Pixel 7x4'), findsOneWidget);
      expect(find.text('Paritas Hardware NINE TL (CB1..CB28)'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('28'), findsOneWidget);
      expect(find.text('Reset'), findsOneWidget);
      expect(find.text('Invert'), findsOneWidget);
      expect(find.text('Penuh'), findsOneWidget);

      // Interaksi dengan tombol modal
      await tester.tap(find.text('1'));
      await tester.pump();

      await tester.tap(find.text('Invert'));
      await tester.pump();

      await tester.tap(find.text('Kirim Pola Matriks ke Lampu (BLE)'));
      await tester.pumpAndSettle();

      // Verifikasi snackbar berhasil
      expect(find.text('Pola matriks 7x4 berhasil dikirim ke modul NINE Tail Light!'), findsOneWidget);
    });
  });
}
