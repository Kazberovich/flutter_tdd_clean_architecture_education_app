part of 'injection_container.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  await _initOnboarding();
  await _initAuth();
  await _initCourse();
  await _initVideo();
}

Future<void> _initVideo() async {
  serviceLocator
    ..registerFactory(() =>
        VideoCubit(addVideo: serviceLocator(), getVideos: serviceLocator()))
    ..registerLazySingleton(() => AddVideo(serviceLocator()))
    ..registerLazySingleton(() => GetVideos(serviceLocator()))
    ..registerLazySingleton<VideoRepository>(
      () => VideoRepositoryImplementation(serviceLocator()),
    )
    ..registerLazySingleton<VideoRemoteDataSource>(
      () => VideoRemoteDataSourceImplementation(
        auth: serviceLocator(),
        firestore: serviceLocator(),
        storage: serviceLocator(),
      ),
    );
}

Future<void> _initCourse() async {
  serviceLocator
    ..registerFactory(
      () => CourseCubit(
        addCourse: serviceLocator(),
        getCourses: serviceLocator(),
      ),
    )
    ..registerLazySingleton(() => AddCourse(serviceLocator()))
    ..registerLazySingleton(() => GetCourses(serviceLocator()))
    ..registerLazySingleton<CourseRepository>(
      () => CourseRepositoryImplementation(serviceLocator()),
    )
    ..registerLazySingleton<CourseRemoteDataSource>(
      () => CourseRemoteDataSourceImplementation(
        firestore: serviceLocator(),
        storage: serviceLocator(),
        auth: serviceLocator(),
      ),
    );
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
