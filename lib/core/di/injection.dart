import 'package:get_it/get_it.dart';
import '../network/api_client.dart';
import '../../features/garage/data/datasources/garage_remote_datasource.dart';
import '../../features/garage/data/repositories/garage_repository_impl.dart';
import '../../features/garage/domain/repositories/i_garage_repository.dart';
import '../../features/garage/domain/usecases/get_availability_usecase.dart';
import '../../features/garage/domain/usecases/get_services_usecase.dart';
import '../../features/garage/domain/usecases/get_workshops_usecase.dart';
import '../../features/garage/domain/usecases/submit_booking_usecase.dart';
import '../../features/garage/presentation/blocs/booking_bloc.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  // 1. Core Network
  sl.registerLazySingleton<ApiClient>(() => ApiClient.create());

  // 2. Data Sources
  sl.registerLazySingleton<IGarageRemoteDataSource>(
    () => GarageRemoteDataSourceImpl(sl<ApiClient>()),
  );

  // 3. Repositories
  sl.registerLazySingleton<IGarageRepository>(
    () => GarageRepositoryImpl(sl<IGarageRemoteDataSource>()),
  );

  // 4. Use Cases
  sl.registerLazySingleton<GetWorkshopsUseCase>(
    () => GetWorkshopsUseCase(sl<IGarageRepository>()),
  );
  sl.registerLazySingleton<GetServicesUseCase>(
    () => GetServicesUseCase(sl<IGarageRepository>()),
  );
  sl.registerLazySingleton<GetAvailabilityUseCase>(
    () => GetAvailabilityUseCase(sl<IGarageRepository>()),
  );
  sl.registerLazySingleton<SubmitBookingUseCase>(
    () => SubmitBookingUseCase(sl<IGarageRepository>()),
  );

  // 5. BLoCs
  sl.registerFactory<BookingBloc>(
    () => BookingBloc(
      getWorkshopsUseCase: sl<GetWorkshopsUseCase>(),
      getServicesUseCase: sl<GetServicesUseCase>(),
      getAvailabilityUseCase: sl<GetAvailabilityUseCase>(),
      submitBookingUseCase: sl<SubmitBookingUseCase>(),
    ),
  );
}
