import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd_education_app/core/common/app/providers/user_provider.dart';
import 'package:tdd_education_app/core/common/views/page_under_construction.dart';
import 'package:tdd_education_app/core/extensions/context_extension.dart';
import 'package:tdd_education_app/core/services/injection_container.dart';
import 'package:tdd_education_app/src/authentication/data/models/user_model.dart';
import 'package:tdd_education_app/src/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:tdd_education_app/src/authentication/presentation/views/sign_in_screen.dart';
import 'package:tdd_education_app/src/authentication/presentation/views/sign_up_screen.dart';
import 'package:tdd_education_app/src/dashboard/presentation/views/dashboard_screen.dart';
import 'package:tdd_education_app/src/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:tdd_education_app/src/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:tdd_education_app/src/onboarding/presentation/views/onboarding_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case '/':
      final prefs = serviceLocator<SharedPreferences>();
      return _pageBuilder(
        (context) {
          if (prefs.getBool(kFirstTimerKey) ?? true) {
            return BlocProvider(
              create: (_) => serviceLocator<OnboardingCubit>(),
              child: const OnboardingScreen(),
            );
          } else if (serviceLocator<FirebaseAuth>().currentUser != null) {
            final user = serviceLocator<FirebaseAuth>().currentUser!;

            final localUser = LocalUserModel(
              uid: user.uid,
              email: user.email ?? '',
              points: 0,
              fullName: user.displayName ?? '',
            );

            context.userProvider.initUser(localUser);
            return const DashboardScreen();
          }

          return BlocProvider(
            create: (_) => serviceLocator<AuthenticationBloc>(),
            child: const SignInScreen(),
          );
        },
        settings: routeSettings,
      );

    case SignInScreen.routeName:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (_) => serviceLocator<AuthenticationBloc>(),
          child: const SignInScreen(),
        ),
        settings: routeSettings,
      );

    case SignUpScreen.routeName:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (_) => serviceLocator<AuthenticationBloc>(),
          child: const SignUpScreen(),
        ),
        settings: routeSettings,
      );

    case DashboardScreen.routeName:
      return _pageBuilder(
        (_) => const DashboardScreen(),
        settings: routeSettings,
      );

    default:
      return _pageBuilder(
        (_) => const PageUnderConstruction(),
        settings: routeSettings,
      );
  }
}

PageRouteBuilder<dynamic> _pageBuilder(
  Widget Function(BuildContext) page, {
  required RouteSettings settings,
}) {
  return PageRouteBuilder(
    settings: settings,
    pageBuilder: (context, _, __) => page(context),
    transitionsBuilder: (context, animation, __, child) => FadeTransition(
      opacity: animation,
      child: child,
    ),
  );
}
