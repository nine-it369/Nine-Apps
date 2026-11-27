import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/garage/domain/entities/booking_entity.dart';
import '../../features/garage/presentation/screens/accessories_screen.dart';
import '../../features/garage/presentation/screens/booking_stepper_screen.dart';
import '../../features/garage/presentation/screens/booking_success_screen.dart';
import '../../features/garage/presentation/screens/garage_landing_screen.dart';
import '../../features/garage/presentation/screens/ticket_lookup_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/mall/presentation/screens/mall_landing_screen.dart';
import '../../features/profile/presentation/screens/change_password_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/loyalty_points_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/vouchers_screen.dart';
import '../../features/smart_lighting/presentation/blocs/smart_lighting_bloc.dart';
import '../../features/smart_lighting/presentation/screens/sensor_override_screen.dart';
import '../../features/smart_lighting/presentation/screens/smart_lamp_studio_screen.dart';
import '../../shared/widgets/navigation/main_navigation_shell.dart';
import '../di/injection.dart';
import 'route_names.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.home,
    routes: [
      // StatefulShellRoute with 4 Dock Branches: Home, Aksesoris, Mall, Profile
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainNavigationShell(navigationShell: navigationShell);
        },
        branches: [
          // Branch 0: Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.home,
                name: 'home',
                builder: (context, state) => BlocProvider.value(
                  value: sl<SmartLightingBloc>(),
                  child: const HomeScreen(),
                ),
              ),
            ],
          ),
          // Branch 1: Aksesoris
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.accessories,
                name: 'accessories',
                builder: (context, state) => const AccessoriesScreen(),
              ),
            ],
          ),
          // Branch 2: Mall
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.mall,
                name: 'mall',
                builder: (context, state) => const MallLandingScreen(),
              ),
            ],
          ),
          // Branch 3: Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.profile,
                name: 'profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),

      // Standalone & Dedicated Flows
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

      // Profile Sub-Screens
      GoRoute(
        path: RouteNames.editProfile,
        name: 'editProfile',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: RouteNames.changePassword,
        name: 'changePassword',
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: RouteNames.vouchers,
        name: 'vouchers',
        builder: (context, state) => const VouchersScreen(),
      ),
      GoRoute(
        path: RouteNames.loyalty,
        name: 'loyalty',
        builder: (context, state) => const LoyaltyPointsScreen(),
      ),
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
    ],
  );
}
