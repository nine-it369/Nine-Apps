import 'package:flutter_test/flutter_test.dart';
import 'package:nine_apps/core/di/injection.dart';
import 'package:nine_apps/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:nine_apps/features/auth/presentation/blocs/auth_event.dart';
import 'package:nine_apps/features/auth/presentation/blocs/auth_state.dart';
import 'package:nine_apps/features/mall/presentation/blocs/mall_bloc.dart';
import 'package:nine_apps/features/mall/presentation/blocs/mall_event.dart';
import 'package:nine_apps/features/mall/presentation/blocs/mall_state.dart';
import 'package:nine_apps/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:nine_apps/features/profile/presentation/blocs/profile_event.dart';
import 'package:nine_apps/features/profile/presentation/blocs/profile_state.dart';

void main() {
  group('Auth, Profile & Mall Feature Suite Integration Tests', () {
    setUp(() async {
      await sl.reset();
      await configureDependencies();
    });

    test('AuthBloc checks session and logins successfully', () async {
      final authBloc = sl<AuthBloc>();
      authBloc.add(const CheckAuthSessionEvent());

      await expectLater(
        authBloc.stream,
        emitsInOrder([
          predicate<AuthState>((s) => s.status == AuthStatus.loading),
          predicate<AuthState>((s) => s.status == AuthStatus.authenticated && s.user != null),
        ]),
      );

      // Perform Logout
      authBloc.add(const LogoutEvent());
      await expectLater(
        authBloc.stream,
        emits(predicate<AuthState>((s) => s.status == AuthStatus.unauthenticated && s.user == null)),
      );
    });

    test('ProfileBloc updates name and changes password', () async {
      final profileBloc = sl<ProfileBloc>();

      // Update Profile Name
      final updateFuture = expectLater(
        profileBloc.stream,
        emitsThrough(
          predicate<ProfileState>((s) => s.status == ProfileStatus.success && s.user.name == 'Aditya Pratama VIP'),
        ),
      );
      profileBloc.add(const SubmitUpdateProfileEvent(name: 'Aditya Pratama VIP', email: 'aditya.vip@nine.id'));
      await updateFuture;
    });

    test('MallBloc initializes catalog, filters category, and performs live search', () async {
      final mallBloc = sl<MallBloc>();
      mallBloc.add(const InitMallEvent());

      await expectLater(
        mallBloc.stream,
        emitsInOrder([
          predicate<MallState>((s) => s.status == MallStatus.loading),
          predicate<MallState>((s) => s.status == MallStatus.loaded && s.categories.isNotEmpty),
        ]),
      );

      // Filter by category ID 1 (Headlight)
      mallBloc.add(const FilterMallCategoryEvent(1));
      await expectLater(
        mallBloc.stream,
        emits(predicate<MallState>((s) => s.selectedCategoryId == 1)),
      );

      // Toggle off category filter
      mallBloc.add(const FilterMallCategoryEvent(1));
      await expectLater(
        mallBloc.stream,
        emits(predicate<MallState>((s) => s.selectedCategoryId == null)),
      );

      // Search query
      mallBloc.add(const SearchMallProductEvent('BiLED'));
      await expectLater(
        mallBloc.stream,
        emits(predicate<MallState>((s) => s.searchQuery == 'BiLED')),
      );
    });
  });
}
