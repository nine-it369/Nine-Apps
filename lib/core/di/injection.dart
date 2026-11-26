import 'package:get_it/get_it.dart';
import '../network/api_client.dart';
import '../../features/garage/data/datasources/garage_remote_datasource.dart';
import '../../features/garage/data/datasources/garage_sse_datasource.dart';
import '../../features/garage/data/repositories/garage_repository_impl.dart';
import '../../features/garage/domain/repositories/i_garage_repository.dart';
import '../../features/garage/domain/usecases/cancel_preview_booking_usecase.dart';
import '../../features/garage/domain/usecases/get_availability_usecase.dart';
import '../../features/garage/domain/usecases/get_booking_by_ticket_usecase.dart';
import '../../features/garage/domain/usecases/get_packages_usecase.dart';
import '../../features/garage/domain/usecases/get_services_usecase.dart';
import '../../features/garage/domain/usecases/get_variants_usecase.dart';
import '../../features/garage/domain/usecases/get_vouchers_usecase.dart';
import '../../features/garage/domain/usecases/get_workshops_usecase.dart';
import '../../features/garage/domain/usecases/preview_booking_usecase.dart';
import '../../features/garage/domain/usecases/search_regencies_usecase.dart';
import '../../features/garage/domain/usecases/submit_booking_usecase.dart';
import '../../features/garage/domain/usecases/update_booking_usecase.dart';
import '../../features/garage/domain/usecases/validate_voucher_usecase.dart';
import '../../features/garage/presentation/blocs/booking_bloc.dart';
import '../../features/smart_lighting/data/datasources/led_ble_datasource.dart';
import '../../features/smart_lighting/data/repositories/smart_lighting_repository_impl.dart';
import '../../features/smart_lighting/domain/repositories/i_smart_lighting_repository.dart';
import '../../features/smart_lighting/domain/usecases/connect_led_device_usecase.dart';
import '../../features/smart_lighting/domain/usecases/send_led_color_usecase.dart';
import '../../features/smart_lighting/domain/usecases/smart_lamp_commands_usecases.dart';
import '../../features/smart_lighting/presentation/blocs/smart_lighting_bloc.dart';
import '../../features/smart_lighting/presentation/blocs/smart_lighting_event.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  // 1. Core Network
  sl.registerLazySingleton<ApiClient>(() => ApiClient.create());

  // 2. Data Sources
  sl.registerLazySingleton<IGarageRemoteDataSource>(
    () => GarageRemoteDataSourceImpl(sl<ApiClient>()),
  );
  sl.registerLazySingleton<IGarageSseDataSource>(
    () => GarageSseDataSourceImpl(sl<ApiClient>()),
  );
  sl.registerLazySingleton<ILedBleDataSource>(
    () => SimulatedLedBleDataSourceImpl(),
  );

  // 3. Repositories
  sl.registerLazySingleton<IGarageRepository>(
    () => GarageRepositoryImpl(sl<IGarageRemoteDataSource>()),
  );
  sl.registerLazySingleton<ISmartLightingRepository>(
    () => SmartLightingRepositoryImpl(sl<ILedBleDataSource>()),
  );

  // 4. Use Cases - Garage
  sl.registerLazySingleton<GetWorkshopsUseCase>(
    () => GetWorkshopsUseCase(sl<IGarageRepository>()),
  );
  sl.registerLazySingleton<GetServicesUseCase>(
    () => GetServicesUseCase(sl<IGarageRepository>()),
  );
  sl.registerLazySingleton<GetPackagesUseCase>(
    () => GetPackagesUseCase(sl<IGarageRepository>()),
  );
  sl.registerLazySingleton<GetVariantsUseCase>(
    () => GetVariantsUseCase(sl<IGarageRepository>()),
  );
  sl.registerLazySingleton<SearchRegenciesUseCase>(
    () => SearchRegenciesUseCase(sl<IGarageRepository>()),
  );
  sl.registerLazySingleton<GetAvailabilityUseCase>(
    () => GetAvailabilityUseCase(sl<IGarageRepository>()),
  );
  sl.registerLazySingleton<PreviewBookingUseCase>(
    () => PreviewBookingUseCase(sl<IGarageRepository>()),
  );
  sl.registerLazySingleton<CancelPreviewBookingUseCase>(
    () => CancelPreviewBookingUseCase(sl<IGarageRepository>()),
  );
  sl.registerLazySingleton<GetVouchersUseCase>(
    () => GetVouchersUseCase(sl<IGarageRepository>()),
  );
  sl.registerLazySingleton<ValidateVoucherUseCase>(
    () => ValidateVoucherUseCase(sl<IGarageRepository>()),
  );
  sl.registerLazySingleton<SubmitBookingUseCase>(
    () => SubmitBookingUseCase(sl<IGarageRepository>()),
  );
  sl.registerLazySingleton<UpdateBookingUseCase>(
    () => UpdateBookingUseCase(sl<IGarageRepository>()),
  );
  sl.registerLazySingleton<GetBookingByTicketUseCase>(
    () => GetBookingByTicketUseCase(sl<IGarageRepository>()),
  );

  // 4b. Use Cases - Smart Lighting IoT
  sl.registerLazySingleton<ScanLedDevicesUseCase>(
    () => ScanLedDevicesUseCase(sl<ISmartLightingRepository>()),
  );
  sl.registerLazySingleton<ConnectLedDeviceUseCase>(
    () => ConnectLedDeviceUseCase(sl<ISmartLightingRepository>()),
  );
  sl.registerLazySingleton<SendLampPowerUseCase>(
    () => SendLampPowerUseCase(sl<ISmartLightingRepository>()),
  );
  sl.registerLazySingleton<SendLedColorUseCase>(
    () => SendLedColorUseCase(sl<ISmartLightingRepository>()),
  );
  sl.registerLazySingleton<SendLampModeUseCase>(
    () => SendLampModeUseCase(sl<ISmartLightingRepository>()),
  );
  sl.registerLazySingleton<SendRunningTextUseCase>(
    () => SendRunningTextUseCase(sl<ISmartLightingRepository>()),
  );
  sl.registerLazySingleton<SendLampSettingUseCase>(
    () => SendLampSettingUseCase(sl<ISmartLightingRepository>()),
  );

  // 5. BLoCs
  sl.registerFactory<BookingBloc>(
    () => BookingBloc(
      getWorkshopsUseCase: sl<GetWorkshopsUseCase>(),
      getServicesUseCase: sl<GetServicesUseCase>(),
      getPackagesUseCase: sl<GetPackagesUseCase>(),
      getVariantsUseCase: sl<GetVariantsUseCase>(),
      searchRegenciesUseCase: sl<SearchRegenciesUseCase>(),
      getAvailabilityUseCase: sl<GetAvailabilityUseCase>(),
      previewBookingUseCase: sl<PreviewBookingUseCase>(),
      cancelPreviewBookingUseCase: sl<CancelPreviewBookingUseCase>(),
      getVouchersUseCase: sl<GetVouchersUseCase>(),
      validateVoucherUseCase: sl<ValidateVoucherUseCase>(),
      submitBookingUseCase: sl<SubmitBookingUseCase>(),
      updateBookingUseCase: sl<UpdateBookingUseCase>(),
      getBookingByTicketUseCase: sl<GetBookingByTicketUseCase>(),
      sseDataSource: sl<IGarageSseDataSource>(),
    ),
  );
  sl.registerLazySingleton<SmartLightingBloc>(
    () => SmartLightingBloc(
      scanDevicesUseCase: sl<ScanLedDevicesUseCase>(),
      connectDeviceUseCase: sl<ConnectLedDeviceUseCase>(),
      sendPowerUseCase: sl<SendLampPowerUseCase>(),
      sendColorUseCase: sl<SendLedColorUseCase>(),
      sendModeUseCase: sl<SendLampModeUseCase>(),
      sendRunningTextUseCase: sl<SendRunningTextUseCase>(),
      sendSettingUseCase: sl<SendLampSettingUseCase>(),
      repository: sl<ISmartLightingRepository>(),
    )..add(const InitSmartLightingEvent()),
  );
}
