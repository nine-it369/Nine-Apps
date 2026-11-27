import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/blocs/auth_bloc.dart';
import 'features/mall/presentation/blocs/mall_bloc.dart';
import 'features/profile/presentation/blocs/profile_bloc.dart';
import 'features/smart_lighting/presentation/blocs/smart_lighting_bloc.dart';

class NineApp extends StatelessWidget {
  const NineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<AuthBloc>()),
        BlocProvider.value(value: sl<ProfileBloc>()),
        BlocProvider.value(value: sl<MallBloc>()),
        BlocProvider.value(value: sl<SmartLightingBloc>()),
      ],
      child: MaterialApp.router(
        title: 'Nine AutoSeries',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
