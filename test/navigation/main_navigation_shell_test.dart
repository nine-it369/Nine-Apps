import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nine_apps/core/di/injection.dart';
import 'package:nine_apps/core/router/app_router.dart';
import 'package:nine_apps/features/smart_lighting/data/datasources/led_ble_datasource.dart';
import 'package:nine_apps/features/smart_lighting/data/repositories/smart_lighting_repository_impl.dart';
import 'package:nine_apps/features/smart_lighting/domain/usecases/connect_led_device_usecase.dart';
import 'package:nine_apps/features/smart_lighting/domain/usecases/send_led_color_usecase.dart';
import 'package:nine_apps/features/smart_lighting/domain/usecases/smart_lamp_commands_usecases.dart';
import 'package:nine_apps/features/smart_lighting/presentation/blocs/smart_lighting_bloc.dart';

SmartLightingBloc _createTestBloc() {
  final ds = SimulatedLedBleDataSourceImpl();
  final repo = SmartLightingRepositoryImpl(ds);
  return SmartLightingBloc(
    scanDevicesUseCase: ScanLedDevicesUseCase(repo),
    connectDeviceUseCase: ConnectLedDeviceUseCase(repo),
    sendPowerUseCase: SendLampPowerUseCase(repo),
    sendColorUseCase: SendLedColorUseCase(repo),
    sendModeUseCase: SendLampModeUseCase(repo),
    sendRunningTextUseCase: SendRunningTextUseCase(repo),
    sendSettingUseCase: SendLampSettingUseCase(repo),
    repository: repo,
  );
}

void main() {
  group('Master 4-Tab Navigation Shell & Screens Integration Tests', () {
    setUp(() {
      if (!sl.isRegistered<SmartLightingBloc>()) {
        sl.registerFactory<SmartLightingBloc>(() => _createTestBloc());
      }
    });

    testWidgets('MainNavigationShell renders 4 tabs (Home, Aksesoris, Mall, Profile) and navigates seamlessly', (tester) async {
      tester.view.physicalSize = const Size(800, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: AppRouter.router,
        ),
      );
      await tester.pumpAndSettle();

      // 1. Verify Home Screen on initial location
      expect(find.text('SELAMAT PAGI,'), findsOneWidget);
      expect(find.text('Aditya Pratama'), findsOneWidget);
      expect(find.text('Belanja Suku Cadang'), findsOneWidget);
      expect(find.text('Booking Bengkel'), findsWidgets);
      expect(find.text('AKTIFITAS'), findsOneWidget);
      expect(find.text('PRODUK TERBAIK'), findsOneWidget);

      // Verify Dock items present
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Aksesoris'), findsOneWidget);
      expect(find.text('Mall'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);

      // 2. Tap Tab: Profile
      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();

      expect(find.text('Akun'), findsOneWidget);
      expect(find.text('Gaspol terus!'), findsOneWidget);
      expect(find.text('N-COINS'), findsOneWidget);
      expect(find.text('2.450 Poin'), findsOneWidget);
      expect(find.text('VOUCHER'), findsOneWidget);
      expect(find.text('3 Kupon'), findsOneWidget);
      expect(find.text('Edit Profil'), findsOneWidget);
      expect(find.text('Ganti Password'), findsOneWidget);
      expect(find.text('Lingkaran Keluarga Pratama'), findsOneWidget);
      expect(find.text('Nine Care Center 24/7'), findsOneWidget);

      // Navigate to Edit Profil
      await tester.tap(find.text('Edit Profil'));
      await tester.pumpAndSettle();
      expect(find.text('Perbarui identitas akun & kontak utama'), findsOneWidget);
      expect(find.text('Simpan Perubahan'), findsOneWidget);
      await tester.tap(find.byIcon(TablerIcons.chevron_left));
      await tester.pumpAndSettle();

      // Navigate to Ganti Password
      await tester.tap(find.text('Ganti Password'));
      await tester.pumpAndSettle();
      expect(find.text('Keamanan Sandi Akun'), findsOneWidget);
      expect(find.text('Perbarui Password'), findsOneWidget);
      await tester.tap(find.byIcon(TablerIcons.chevron_left));
      await tester.pumpAndSettle();

      // Navigate to Vouchers
      await tester.tap(find.text('3 Kupon'));
      await tester.pumpAndSettle();
      expect(find.text('Kupon Saya'), findsOneWidget);
      expect(find.text('Diskon Rp 100.000 Servis'), findsOneWidget);
      await tester.tap(find.byIcon(TablerIcons.chevron_left));
      await tester.pumpAndSettle();

      // Navigate to N-Coins Loyalty
      await tester.tap(find.text('2.450 Poin'));
      await tester.pumpAndSettle();
      expect(find.text('Nine VIP Pass & N-Coins'), findsOneWidget);
      expect(find.text('RIWAYAT POIN TERBARU'), findsOneWidget);
      await tester.tap(find.byIcon(TablerIcons.chevron_left));
      await tester.pumpAndSettle();

      // 3. Tap Tab: Mall
      await tester.tap(find.text('Mall'));
      await tester.pumpAndSettle();

      expect(find.text('Nine Mall Official Store'), findsOneWidget);
      expect(find.text('100% Suku Cadang Resmi & Garansi Nasional'), findsOneWidget);
      expect(find.text('Lacak Pengiriman Pesanan (AWB)'), findsOneWidget);
      expect(find.text('JELAJAHI PRODUK KAMI'), findsOneWidget);
      expect(find.text('VOUCHER BELANJA'), findsOneWidget);
      expect(find.text('FLASH SALE NINE MALL'), findsOneWidget);

      // 4. Tap Tab: Aksesoris
      await tester.tap(find.text('Aksesoris'));
      await tester.pumpAndSettle();

      expect(find.text('Aksesoris Terpasang'), findsOneWidget);
      expect(find.text('Nine GPS'), findsOneWidget);
      expect(find.text('Nine Dashcam 4K'), findsOneWidget);
      expect(find.text('SMART LIGHTING IOT'), findsOneWidget);

      // 5. Tap Tab: Home
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();

      expect(find.text('SELAMAT PAGI,'), findsOneWidget);
    });
  });
}
