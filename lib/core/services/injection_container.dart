import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd_education_app/src/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:tdd_education_app/src/onboarding/data/repositories/onboarding_repository_implementation.dart';
import 'package:tdd_education_app/src/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:tdd_education_app/src/onboarding/domain/usecases/cache_first_timer.dart';
import 'package:tdd_education_app/src/onboarding/domain/usecases/check_if_user_is_first_timer.dart';
import 'package:tdd_education_app/src/onboarding/presentation/cubit/onboarding_cubit.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
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
    ..registerLazySingleton(() => CacheFirstTimer(serviceLocator()))
    ..registerLazySingleton(() => CheckIfUserIsFirstTimer(serviceLocator()))
    ..registerLazySingleton<OnboardingRepository>(
        () => OnboardingRepositoryImplementation(serviceLocator()))
    ..registerLazySingleton<OnboardingLocalDataSource>(
        () => OnboardingLocalDataSourceImplementation(serviceLocator()))
    ..registerLazySingleton(() => prefs);
}
