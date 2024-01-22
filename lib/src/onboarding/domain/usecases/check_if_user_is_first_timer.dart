import 'package:tdd_education_app/core/usecases/usecases.dart';
import 'package:tdd_education_app/core/utils/typedefs.dart';
import 'package:tdd_education_app/src/onboarding/domain/repositories/onboarding_repository.dart';

class CheckIfUserIsFirstTimer extends UsecaseWithoutParams<bool> {
  const CheckIfUserIsFirstTimer(this._onboardingRepository);

  final OnboardingRepository _onboardingRepository;

  @override
  ResultFuture<bool> call() => _onboardingRepository.checkIfUserIsFirstTimer();
}
