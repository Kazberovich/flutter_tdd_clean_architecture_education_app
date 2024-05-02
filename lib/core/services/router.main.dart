part of 'router.dart';

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
          } else if (serviceLocator<fauth.FirebaseAuth>().currentUser != null) {
            final user = serviceLocator<fauth.FirebaseAuth>().currentUser!;

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

    case '/forgot-password':
      return _pageBuilder(
        (_) => const fui.ForgotPasswordScreen(),
        settings: routeSettings,
      );

    case '/course-details':
      return _pageBuilder(
        (_) => CourseDetailsScreen(course: routeSettings.arguments! as Course),
        settings: routeSettings,
      );

    case AddVideoView.routeName:
      return _pageBuilder(
        (_) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => serviceLocator<CourseCubit>()),
            BlocProvider(create: (_) => serviceLocator<VideoCubit>()),
            BlocProvider(create: (_) => serviceLocator<NotificationCubit>()),
          ],
          child: const AddVideoView(),
        ),
        settings: routeSettings,
      );

    case AddMaterialsView.routeName:
      return _pageBuilder(
        (_) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => serviceLocator<CourseCubit>()),
            BlocProvider(create: (_) => serviceLocator<MaterialCubit>()),
            BlocProvider(create: (_) => serviceLocator<NotificationCubit>()),
          ],
          child: const AddMaterialsView(),
        ),
        settings: routeSettings,
      );

    case AddExamView.routeName:
      return _pageBuilder(
        (_) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => serviceLocator<CourseCubit>()),
            BlocProvider(create: (_) => serviceLocator<ExamCubit>()),
            BlocProvider(create: (_) => serviceLocator<NotificationCubit>()),
          ],
          child: const AddExamView(),
        ),
        settings: routeSettings,
      );
    case VideoPlayerView.routeName:
      return _pageBuilder(
        (p0) => VideoPlayerView(videoURL: routeSettings.arguments! as String),
        settings: routeSettings,
      );
    case CourseVideosView.routeName:
      return _pageBuilder(
        (p0) => BlocProvider(
          create: (_) => serviceLocator<VideoCubit>(),
          child: CourseVideosView(course: routeSettings.arguments! as Course),
        ),
        settings: routeSettings,
      );
    case CourseMaterialsView.routeName:
      return _pageBuilder(
        (p0) => BlocProvider(
          create: (_) => serviceLocator<MaterialCubit>(),
          child: CourseMaterialsView(routeSettings.arguments! as Course),
        ),
        settings: routeSettings,
      );

    case CourseExamsView.routeName:
      return _pageBuilder(
        (p0) => BlocProvider(
          create: (_) => serviceLocator<ExamCubit>(),
          child: CourseExamsView(routeSettings.arguments! as Course),
        ),
        settings: routeSettings,
      );

    case ExamDetailsView.routeName:
      return _pageBuilder(
        (p0) => BlocProvider(
          create: (_) => serviceLocator<ExamCubit>(),
          child: ExamDetailsView(routeSettings.arguments! as Exam),
        ),
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
