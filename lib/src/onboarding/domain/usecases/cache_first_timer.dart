import 'package:tdd_education_app/core/usecases/usecases.dart';
import 'package:tdd_education_app/core/utils/typedefs.dart';
import 'package:tdd_education_app/src/onboarding/domain/repositories/onboarding_repository.dart';

class CacheFirstTimer extends UsecaseWithoutParams<void> {
  const CacheFirstTimer(this._onboardingRepository);

  final OnboardingRepository _onboardingRepository;

  @override
  ResultFuture<void> call() async => _onboardingRepository.cacheFirstTimer();
}
