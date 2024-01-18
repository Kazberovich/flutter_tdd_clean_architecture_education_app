import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd_education_app/core/errors/exceptions.dart';
import 'package:tdd_education_app/src/onboarding/data/datasources/onboarding_local_datasource.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late SharedPreferences sharedPreferences;
  late OnboardingLocalDataSource localDataSource;

  setUp(() {
    sharedPreferences = MockSharedPreferences();
    localDataSource =
        OnboardingLocalDataSourceImplementation(sharedPreferences);
  });

  group('cacheFirstTimer', () {
    test('should call [SharedPreferences] to cache the data', () async {
      when(() => sharedPreferences.setBool(any(), any()))
          .thenAnswer((_) async => true);

      await localDataSource.cacheFirstTimer();

      verify(() => sharedPreferences.setBool(kFirstTimerKey, false));
      verifyNoMoreInteractions(sharedPreferences);
    });

    test(
        'should throw a [CacheException] when there is an error caching the data',
        () async {
      when(() => sharedPreferences.setBool(any(), any()))
          .thenThrow(Exception());

      final methodCall = localDataSource.cacheFirstTimer;

      expect(methodCall, throwsA(isA<CacheException>()));
      verify(() => sharedPreferences.setBool(kFirstTimerKey, false)).called(1);
      verifyNoMoreInteractions(sharedPreferences);
    });
  });
}
