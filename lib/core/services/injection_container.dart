import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd_education_app/src/authentication/data/datasources/authentication_remote_datasource.dart';
import 'package:tdd_education_app/src/authentication/data/repositories/authentication_repository_implementation.dart';
import 'package:tdd_education_app/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:tdd_education_app/src/authentication/domain/usecases/forgot_password.dart';
import 'package:tdd_education_app/src/authentication/domain/usecases/sign_in.dart';
import 'package:tdd_education_app/src/authentication/domain/usecases/sign_up.dart';
import 'package:tdd_education_app/src/authentication/domain/usecases/update_user.dart';
import 'package:tdd_education_app/src/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:tdd_education_app/src/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:tdd_education_app/src/onboarding/data/repositories/onboarding_repository_implementation.dart';
import 'package:tdd_education_app/src/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:tdd_education_app/src/onboarding/domain/usecases/cache_first_timer.dart';
import 'package:tdd_education_app/src/onboarding/domain/usecases/check_if_user_is_first_timer.dart';
import 'package:tdd_education_app/src/onboarding/presentation/cubit/onboarding_cubit.dart';

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
