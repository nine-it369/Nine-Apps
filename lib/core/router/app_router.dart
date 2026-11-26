import 'package:go_router/go_router.dart';
import '../../features/garage/domain/entities/booking_entity.dart';
import '../../features/garage/presentation/screens/booking_stepper_screen.dart';
import '../../features/garage/presentation/screens/booking_success_screen.dart';
import '../../features/garage/presentation/screens/garage_landing_screen.dart';
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
        builder: (context, state) => const BookingStepperScreen(),
      ),
      GoRoute(
        path: RouteNames.bookingSuccess,
        name: 'bookingSuccess',
        builder: (context, state) {
          final booking = state.extra as BookingEntity?;
          return BookingSuccessScreen(booking: booking);
        },
      ),
    ],
  );
}
