import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_education_app/core/errors/exceptions.dart';
import 'package:tdd_education_app/core/errors/failures.dart';
import 'package:tdd_education_app/src/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:tdd_education_app/src/onboarding/data/repositories/onboarding_repository_implementation.dart';

class MockOnboardingLocalDataSource extends Mock
    implements OnboardingLocalDataSource {}

void main() {
  late OnboardingLocalDataSource localDataSource;
  late OnboardingRepositoryImplementation repositoryImplementation;

  setUp(() {
    localDataSource = MockOnboardingLocalDataSource();
    repositoryImplementation =
        OnboardingRepositoryImplementation(localDataSource);
  });

  test('should be a subclass of [OnboardingRepositoryImplementation]', () {
    expect(repositoryImplementation, isA<OnboardingRepositoryImplementation>());
  });

  group('cacheFirstTimer', () {
    test('should complete successfully when call to local source is successful',
        () async {
      when(() => localDataSource.cacheFirstTimer())
          .thenAnswer((_) async => Future.value());

      // act
      final result = await repositoryImplementation.cacheFirstTimer();

      expect(result, equals(const Right<dynamic, void>(null)));
      verify(() => localDataSource.cacheFirstTimer()).called(1);
      verifyNoMoreInteractions(localDataSource);
    });

    test(
        'should return [CacheFailure] when call a local source '
        'is unsuccessful', () async {
      when(() => localDataSource.cacheFirstTimer())
          .thenThrow(const CacheException(message: 'Insufficient storage'));

      // act
      final result = await repositoryImplementation.cacheFirstTimer();

      expect(
        result,
        Left<CacheFailure, dynamic>(
          CacheFailure(message: 'Insufficient storage', statusCode: 500),
        ),
      );

      verify(() => localDataSource.cacheFirstTimer()).called(1);
      verifyNoMoreInteractions(localDataSource);
    });
  });
}
