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
    sl.unregister<IGarageRepository>();
    sl.registerLazySingleton<IGarageRepository>(() => FakeGarageRepository());
    sl.unregister<GetWorkshopsUseCase>();
    sl.registerLazySingleton<GetWorkshopsUseCase>(
      () => GetWorkshopsUseCase(sl<IGarageRepository>()),
    );
  });

  testWidgets('NineApp launches and displays Garage Landing Screen with workshops',
      (WidgetTester tester) async {
    await tester.pumpWidget(const NineApp());
    await tester.pumpAndSettle();

    expect(find.text('Nine Garage®'), findsOneWidget);
    expect(find.text('Instalasi Presisi & Servis Kendaraan'), findsOneWidget);
    expect(find.text('Buat Reservasi Servis (Booking)'), findsOneWidget);
    expect(find.text('Arcadia Daan Mogot'), findsOneWidget);
  });
}
