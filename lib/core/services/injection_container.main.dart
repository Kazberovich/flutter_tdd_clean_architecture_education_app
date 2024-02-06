part of 'injection_container.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  await _initOnboarding();
  await _initAuth();
}

Future<void> _initAuth() async {
  serviceLocator
    ..registerFactory(() => AuthenticationBloc(
        signInUsecase: serviceLocator(),
        signUpUsecase: serviceLocator(),
        forgotPasswordUsecase: serviceLocator(),
        updateUserUsecase: serviceLocator()))
    ..registerLazySingleton(
      () => SignInUsecase(serviceLocator()),
    )
    ..registerLazySingleton(
      () => SignUpUsecase(serviceLocator()),
    )
    ..registerLazySingleton(
      () => UpdateUserUsecase(serviceLocator()),
    )
    ..registerLazySingleton(
      () => ForgotPasswordUsecase(serviceLocator()),
    )
    ..registerLazySingleton<AuthenticationRepository>(
      () => AuthenticationRepositoryImplementation(serviceLocator()),
    )
    ..registerLazySingleton<AuthenticationRemoteDatasource>(
      () => AuthenticationRemoteDataSourceImplementation(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(() => FirebaseAuth.instance)
    ..registerLazySingleton(() => FirebaseFirestore.instance)
    ..registerLazySingleton(() => FirebaseStorage.instance);
}

Future<void> _initOnboarding() async {
  final prefs = await SharedPreferences.getInstance();
  // Feature -> Onboarding Feature
  // Business Logic

  serviceLocator
    ..registerFactory(
      () => OnboardingCubit(
        cacheFirstTimer: serviceLocator(),
        checkIfUserIsFirstTimer: serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => CacheFirstTimer(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(() => CheckIfUserIsFirstTimer(serviceLocator()))
    ..registerLazySingleton<OnboardingRepository>(
        () => OnboardingRepositoryImplementation(serviceLocator()))
    ..registerLazySingleton<OnboardingLocalDataSource>(
        () => OnboardingLocalDataSourceImplementation(serviceLocator()))
    ..registerLazySingleton(() => prefs);
}
