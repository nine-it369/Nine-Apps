import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nine_apps/app.dart';
import 'package:nine_apps/core/di/injection.dart';
import 'package:nine_apps/features/garage/domain/repositories/i_garage_repository.dart';
import 'package:nine_apps/features/garage/domain/usecases/get_workshops_usecase.dart';
import 'integration/booking_bloc_test.dart';

void main() {
  setUp(() async {
    await sl.reset();
    await configureDependencies();
    // Replace repository with deterministic fake for isolated widget smoke tests
    await sl.unregister<IGarageRepository>();
    sl.registerLazySingleton<IGarageRepository>(() => FakeGarageRepository());
    await sl.unregister<GetWorkshopsUseCase>();
    sl.registerLazySingleton<GetWorkshopsUseCase>(
      () => GetWorkshopsUseCase(sl<IGarageRepository>()),
    );
  });

  testWidgets('NineApp launches at Home screen with 4-tab dock and navigates to Garage',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const NineApp());
    await tester.pumpAndSettle();

    // Verify Home screen greeting & 4-tab dock
    expect(find.text('SELAMAT PAGI,'), findsOneWidget);
    expect(find.text('Aditya Pratama'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Aksesoris'), findsOneWidget);
    expect(find.text('Mall'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    // Tap quick action Booking Bengkel to open Nine Garage
    final bookingFinder = find.text('Booking Bengkel');
    expect(bookingFinder, findsWidgets);
    await tester.tap(bookingFinder.first);
    await tester.pumpAndSettle();

    // Verify Garage screen
    expect(find.text('Nine Garage®'), findsOneWidget);
    expect(find.text('Instalasi Presisi & Servis Kendaraan'), findsOneWidget);
    expect(find.text('Buat Reservasi Servis (Booking)'), findsOneWidget);
    expect(find.text('Arcadia Daan Mogot'), findsOneWidget);
  });
}
