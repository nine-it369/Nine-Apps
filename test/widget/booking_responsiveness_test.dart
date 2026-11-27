import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nine_apps/core/di/injection.dart';
import 'package:nine_apps/core/theme/app_theme.dart';
import 'package:nine_apps/features/garage/domain/entities/booking_entity.dart';
import 'package:nine_apps/features/garage/domain/repositories/i_garage_repository.dart';
import 'package:nine_apps/features/garage/domain/usecases/cancel_preview_booking_usecase.dart';
import 'package:nine_apps/features/garage/domain/usecases/get_availability_usecase.dart';
import 'package:nine_apps/features/garage/domain/usecases/get_packages_usecase.dart';
import 'package:nine_apps/features/garage/domain/usecases/get_services_usecase.dart';
import 'package:nine_apps/features/garage/domain/usecases/get_vouchers_usecase.dart';
import 'package:nine_apps/features/garage/domain/usecases/get_workshops_usecase.dart';
import 'package:nine_apps/features/garage/domain/usecases/preview_booking_usecase.dart';
import 'package:nine_apps/features/garage/domain/usecases/search_regencies_usecase.dart';
import 'package:nine_apps/features/garage/domain/usecases/submit_booking_usecase.dart';
import 'package:nine_apps/features/garage/domain/usecases/validate_voucher_usecase.dart';
import 'package:nine_apps/features/garage/domain/usecases/get_booking_by_ticket_usecase.dart';
import 'package:nine_apps/features/garage/domain/usecases/get_variants_usecase.dart';
import 'package:nine_apps/features/garage/domain/usecases/update_booking_usecase.dart';
import 'package:nine_apps/features/garage/presentation/blocs/booking_bloc.dart';
import 'package:nine_apps/features/garage/presentation/screens/booking_stepper_screen.dart';
import 'package:nine_apps/features/garage/presentation/screens/booking_success_screen.dart';
import '../integration/booking_bloc_test.dart';

void main() {
  setUp(() async {
    await sl.reset();
    await configureDependencies();
    final fakeRepo = FakeGarageRepository();
    await sl.unregister<IGarageRepository>();
    sl.registerLazySingleton<IGarageRepository>(() => fakeRepo);

    await sl.unregister<BookingBloc>();
    sl.registerFactory<BookingBloc>(
      () => BookingBloc(
        getWorkshopsUseCase: GetWorkshopsUseCase(fakeRepo),
        getServicesUseCase: GetServicesUseCase(fakeRepo),
        getPackagesUseCase: GetPackagesUseCase(fakeRepo),
        searchRegenciesUseCase: SearchRegenciesUseCase(fakeRepo),
        getAvailabilityUseCase: GetAvailabilityUseCase(fakeRepo),
        previewBookingUseCase: PreviewBookingUseCase(fakeRepo),
        cancelPreviewBookingUseCase: CancelPreviewBookingUseCase(fakeRepo),
        getVouchersUseCase: GetVouchersUseCase(fakeRepo),
        validateVoucherUseCase: ValidateVoucherUseCase(fakeRepo),
        submitBookingUseCase: SubmitBookingUseCase(fakeRepo),
        getBookingByTicketUseCase: GetBookingByTicketUseCase(fakeRepo),
        getVariantsUseCase: GetVariantsUseCase(fakeRepo),
        updateBookingUseCase: UpdateBookingUseCase(fakeRepo),
        sseDataSource: FakeGarageSseDataSource(),
      ),
    );
  });

  final viewports = <String, Size>{
    'Small Phone (360x640)': const Size(360, 640),
    'Standard Phone (390x844)': const Size(390, 844),
    'Tablet (768x1024)': const Size(768, 1024),
  };

  for (final entry in viewports.entries) {
    testWidgets('BookingStepperScreen & BookingSuccessScreen render without overflow on ${entry.key}',
        (WidgetTester tester) async {
      tester.view.physicalSize = entry.value;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final errors = <FlutterErrorDetails>[];
      final oldOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        errors.add(details);
      };
      try {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const BookingStepperScreen(),
          ),
        );
        await tester.pumpAndSettle();
      } finally {
        FlutterError.onError = oldOnError;
      }

      expect(find.text('Reservasi Servis Bengkel'), findsOneWidget);
      expect(find.text('Informasi Kontak & Domisili'), findsOneWidget);
      expect(errors, isEmpty, reason: errors.map((e) => e.toString()).join('\n---\n'));

      // Verify BookingSuccessScreen responsiveness + QR rendering
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const BookingSuccessScreen(
            booking: BookingEntity(
              id: 1,
              bookingTicket: 'TGR-RESP-001',
              customerName: 'Budi Santoso',
              customerPhone: '628123456789',
              custAddress: 'Jl. Merdeka',
              cityId: 156,
              vehicleType: 'car',
              vehicleModel: 'Toyota Innova Zenix',
              vehiclePlat: 'B 1234 NNE',
              vehicleColor: 'Hitam',
              workshopId: 1,
              bookingDate: '2026-11-28',
              hour: '13:00',
              referralSource: 'Google Search',
              itemNames: ['Jasa Single Biled'],
              subTotal: 600000,
              totalAmount: 600000,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('TGR-RESP-001'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
