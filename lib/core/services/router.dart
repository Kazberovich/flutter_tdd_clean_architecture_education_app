import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_education_app/core/common/views/page_under_construction.dart';
import 'package:tdd_education_app/core/services/injection_container.dart';
import 'package:tdd_education_app/src/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:tdd_education_app/src/onboarding/presentation/views/onboarding_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case OnboardingScreen.routeName:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (_) => serviceLocator<OnboardingCubit>(),
          child: const OnboardingScreen(),
        ),
        settings: routeSettings,
      );

    default:
      return _pageBuilder((_) => const PageUnderConstruction(),
          settings: routeSettings);
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
