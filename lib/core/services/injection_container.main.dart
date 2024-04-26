part of 'injection_container.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  await _initOnboarding();
  await _initAuth();
  await _initCourse();
  await _initVideo();
  await _initMaterial();
  await _initExam();
  await _initNotifications();
}

Future<void> _initNotifications() async {
  serviceLocator
    ..registerFactory(
      () => NotificationCubit(
        clear: serviceLocator(),
        clearAll: serviceLocator(),
        getNotifications: serviceLocator(),
        markAsRead: serviceLocator(),
        sendNotification: serviceLocator(),
        notificationCleared: serviceLocator(),
      ),
    )
    ..registerLazySingleton(() => Clear(serviceLocator()))
    ..registerLazySingleton(() => ClearAll(serviceLocator()))
    ..registerLazySingleton(() => GetNotifications(serviceLocator()))
    ..registerLazySingleton(() => MarkAsRead(serviceLocator()))
    ..registerLazySingleton(() => SendNotification(serviceLocator()))
    ..registerLazySingleton(() => const NotificationCleared())
    ..registerLazySingleton<NotificationRepository>(
        () => NotificationRepositoryImplementation(serviceLocator()))
    ..registerLazySingleton<NotificationRemoteDatasource>(
      () => NotificationRemoteDatasourceImplementation(
        firestore: serviceLocator(),
        auth: serviceLocator(),
      ),
    );
}

Future<void> _initExam() async {
  serviceLocator
    ..registerFactory(
      () => ExamCubit(
        getExamQuestions: serviceLocator(),
        getExams: serviceLocator(),
        submitExam: serviceLocator(),
        updateExam: serviceLocator(),
        uploadExam: serviceLocator(),
        getUserCourseExams: serviceLocator(),
        getUserExams: serviceLocator(),
      ),
    )
    ..registerLazySingleton(() => GetExamQuestions(serviceLocator()))
    ..registerLazySingleton(() => GetExams(serviceLocator()))
    ..registerLazySingleton(() => SubmitExam(serviceLocator()))
    ..registerLazySingleton(() => UpdateExam(serviceLocator()))
    ..registerLazySingleton(() => UploadExam(serviceLocator()))
    ..registerLazySingleton(() => GetUserCourseExams(serviceLocator()))
    ..registerLazySingleton(() => GetUserExams(serviceLocator()))
    ..registerLazySingleton<ExamRepository>(
        () => ExamRepoImpl(serviceLocator()))
    ..registerLazySingleton<ExamRemoteDataSrc>(
      () => ExamRemoteDataSrcImpl(
        auth: serviceLocator(),
        firestore: serviceLocator(),
      ),
    );
}

Future<void> _initMaterial() async {
  serviceLocator
    ..registerFactory(
      () => MaterialCubit(
        addMaterial: serviceLocator(),
        getMaterials: serviceLocator(),
      ),
    )
    ..registerLazySingleton(() => AddMaterial(serviceLocator()))
    ..registerLazySingleton(() => GetMaterials(serviceLocator()))
    ..registerLazySingleton<MaterialRepo>(
        () => MaterialRepoImpl(serviceLocator()))
    ..registerLazySingleton<MaterialRemoteDataSrc>(
      () => MaterialRemoteDataSrcImpl(
        firestore: serviceLocator(),
        auth: serviceLocator(),
        storage: serviceLocator(),
      ),
    );
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
