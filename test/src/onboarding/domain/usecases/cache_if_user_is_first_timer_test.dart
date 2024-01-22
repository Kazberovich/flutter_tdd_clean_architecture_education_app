import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_education_app/core/errors/failures.dart';
import 'package:tdd_education_app/src/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:tdd_education_app/src/onboarding/domain/usecases/cache_first_timer.dart';
import 'package:tdd_education_app/src/onboarding/domain/usecases/check_if_user_is_first_timer.dart';

import 'onboarding_repository.mock.dart';

void main() {
  late OnboardingRepository onboardingRepository;
  late CheckIfUserIsFirstTimer usecase;

  setUp(() {
    onboardingRepository = MockOnboardingRepository();
    usecase = CheckIfUserIsFirstTimer(onboardingRepository);
  });

  test(
    'should call the [OnboardingRepository.cacheFirstTimer] '
    'and return right data',
    () async {
      // stub
      when(() => onboardingRepository.checkIfUserIsFirstTimer()).thenAnswer(
        (_) async => const Right(true),
      );

      final result = await usecase();

      expect(
        result,
        equals(
          const Right<dynamic, bool>(true),
        ),
      );

      verify(() => onboardingRepository.checkIfUserIsFirstTimer()).called(1);
      verifyNoMoreInteractions(onboardingRepository);
    },
  );
}
