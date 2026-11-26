import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/garage/domain/entities/booking_entity.dart';
import '../../features/garage/presentation/screens/accessories_screen.dart';
import '../../features/garage/presentation/screens/booking_stepper_screen.dart';
import '../../features/garage/presentation/screens/booking_success_screen.dart';
import '../../features/garage/presentation/screens/garage_landing_screen.dart';
import '../../features/garage/presentation/screens/ticket_lookup_screen.dart';
import '../../features/smart_lighting/presentation/blocs/smart_lighting_bloc.dart';
import '../../features/smart_lighting/presentation/screens/sensor_override_screen.dart';
import '../../features/smart_lighting/presentation/screens/smart_lamp_studio_screen.dart';
import '../di/injection.dart';
import 'route_names.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.garage,
    routes: [
      GoRoute(
        path: RouteNames.garage,
        name: 'garage',
        builder: (context, state) => const GarageLandingScreen(),
      ),
      GoRoute(
        path: RouteNames.booking,
        name: 'booking',
        builder: (context, state) {
          final ticket = state.extra as String?;
          return BookingStepperScreen(editTicket: ticket);
        },
      ),
      GoRoute(
        path: RouteNames.bookingSuccess,
        name: 'bookingSuccess',
        builder: (context, state) {
          final booking = state.extra as BookingEntity?;
          return BookingSuccessScreen(booking: booking);
        },
      ),
      GoRoute(
        path: RouteNames.ticketLookup,
        name: 'ticketLookup',
        builder: (context, state) {
          final ticket = state.extra as String?;
          return TicketLookupScreen(initialTicket: ticket);
        },
      ),
      GoRoute(
        path: RouteNames.smartLampStudio,
        name: 'smartLampStudio',
        builder: (context, state) => BlocProvider.value(
          value: sl<SmartLightingBloc>(),
          child: const SmartLampStudioScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.sensorOverride,
        name: 'sensorOverride',
        builder: (context, state) => BlocProvider.value(
          value: sl<SmartLightingBloc>(),
          child: const SensorOverrideScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.accessories,
        name: 'accessories',
        builder: (context, state) => const AccessoriesScreen(),
      ),
    ],
  );
}
