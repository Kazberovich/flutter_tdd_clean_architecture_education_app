import 'package:tdd_education_app/core/utils/typedefs.dart';

abstract class OnboardingRepository {
  const OnboardingRepository();

  ResultFuture<void> cacheFirstTimer();

  ResultFuture<bool> checkIfUserIsFirstTimer();
}
