import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_education_app/core/errors/failures.dart';
import 'package:tdd_education_app/src/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:tdd_education_app/src/onboarding/domain/usecases/cache_first_timer.dart';

import 'onboarding_repository.mock.dart';

void main() {
  late OnboardingRepository onboardingRepository;
  late CacheFirstTimer usecase;

  setUp(() {
    onboardingRepository = MockOnboardingRepository();
    usecase = CacheFirstTimer(onboardingRepository);
  });

  test(
    'should call the [OnboardingRepository.cacheFirstTimer] '
    'and return right data',
    () async {
      // stub
      when(() => onboardingRepository.cacheFirstTimer()).thenAnswer(
        (_) async => Left(
          ServerFailure(message: 'Unknown error', statusCode: 500),
        ),
      );

      final result = await usecase();

      expect(
        result,
        equals(
          Left<Failure, dynamic>(
            ServerFailure(
              message: 'Unknown error',
              statusCode: 500,
            ),
          ),
        ),
      );

      verify(() => onboardingRepository.cacheFirstTimer()).called(1);
      verifyNoMoreInteractions(onboardingRepository);
    },
  );
}
