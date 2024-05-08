import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_education_app/core/errors/failures.dart';
import 'package:tdd_education_app/src/onboarding/domain/usecases/cache_first_timer.dart';
import 'package:tdd_education_app/src/onboarding/domain/usecases/check_if_user_is_first_timer.dart';
import 'package:tdd_education_app/src/onboarding/presentation/cubit/onboarding_cubit.dart';

class MockCacheFirstTimer extends Mock implements CacheFirstTimer {}

class MockCheckIfUserIsFirstTimer extends Mock
    implements CheckIfUserIsFirstTimer {}

void main() {
  late CacheFirstTimer cacheFirstTimer;
  late CheckIfUserIsFirstTimer checkIfUserIsFirstTimer;
  late OnboardingCubit onboardingCubit;

  setUp(() {
    cacheFirstTimer = MockCacheFirstTimer();
    checkIfUserIsFirstTimer = MockCheckIfUserIsFirstTimer();
    onboardingCubit = OnboardingCubit(
      cacheFirstTimer: cacheFirstTimer,
      checkIfUserIsFirstTimer: checkIfUserIsFirstTimer,
    );
  });

  final tFailure =
      CacheFailure(message: 'Insufficient Permissions', statusCode: 4032);

  test('initial state should be [OnboardingInitial]', () {
    expect(onboardingCubit.state, const OnboardingInitial());
  });

  group('cacheFirstTimer', () {
    blocTest<OnboardingCubit, OnboardingState>(
      'should emit [CachingFirstTimer, UserCached] when successful',
      build: () {
        when(() => cacheFirstTimer())
            .thenAnswer((_) async => const Right(null));
        return onboardingCubit;
      },
      act: (cubit) => cubit.cacheFirstTimer(),
      expect: () => const <OnboardingState>[
        CachingFirstTimer(),
        UserCached(),
      ],
      verify: (_) {
        verify(() => cacheFirstTimer()).called(1);
        verifyNoMoreInteractions(cacheFirstTimer);
      },
    );

    blocTest<OnboardingCubit, OnboardingState>(
      'should emit [CachingFirstTimer, OnboardingError] when unsuccessful',
      build: () {
        when(() => cacheFirstTimer()).thenAnswer(
          (_) async => Left(tFailure),
        );
        return onboardingCubit;
      },
      act: (cubit) => cubit.cacheFirstTimer(),
      expect: () => <OnboardingState>[
        const CachingFirstTimer(),
        OnboardingError(tFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => cacheFirstTimer()).called(1);
        verifyNoMoreInteractions(cacheFirstTimer);
      },
    );
  });

  group('checkIfUserIsFirstTimer', () {
    blocTest<OnboardingCubit, OnboardingState>(
      'should emit [CheckingIfUserIsFirstTimer, OnboardingStatus] '
      'when successful',
      build: () {
        when(() => checkIfUserIsFirstTimer()).thenAnswer(
          (_) async => const Right(false),
        );
        return onboardingCubit;
      },
      act: (cubit) => cubit.checkIfUserIsFirstTimer(),
      expect: () => const <OnboardingState>[
        CheckingIfUserIsFirstTimer(),
        OnboardingStatus(isFirstTimer: false),
      ],
      verify: (_) {
        verify(() => checkIfUserIsFirstTimer()).called(1);
        verifyNoMoreInteractions(checkIfUserIsFirstTimer);
      },
    );

    blocTest<OnboardingCubit, OnboardingState>(
      'should emit [CheckingIfUserIsFirstTimer, OnboardingStatus(true)] '
      'when unsuccessful',
      build: () {
        when(() => checkIfUserIsFirstTimer()).thenAnswer(
          (_) async => Left(tFailure),
        );
        return onboardingCubit;
      },
      act: (cubit) => cubit.checkIfUserIsFirstTimer(),
      expect: () => const <OnboardingState>[
        CheckingIfUserIsFirstTimer(),
        OnboardingStatus(isFirstTimer: true),
      ],
      verify: (_) {
        verify(() => checkIfUserIsFirstTimer()).called(1);
        verifyNoMoreInteractions(checkIfUserIsFirstTimer);
      },
    );
  });
}
