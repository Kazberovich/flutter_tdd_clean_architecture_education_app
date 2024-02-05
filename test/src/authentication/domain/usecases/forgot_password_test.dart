import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_education_app/src/authentication/domain/usecases/forgot_password.dart';
import 'package:test/test.dart';
import 'auth_repo.mock.dart';

void main() {
  late MockAuthRepo repo;
  late ForgotPasswordUsecase usecase;

  setUp(() {
    repo = MockAuthRepo();
    usecase = ForgotPasswordUsecase(repo);
  });

  test(
    'should call the [AuthRepo.forgotPassword]',
    () async {
      when(() => repo.forgotPassword(any())).thenAnswer(
        (_) async => const Right(null),
      );

      final result = await usecase('email');

      expect(result, equals(const Right<dynamic, void>(null)));

      verify(() => repo.forgotPassword('email')).called(1);

      verifyNoMoreInteractions(repo);
    },
  );
}
