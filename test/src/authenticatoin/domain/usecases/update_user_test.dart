import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_education_app/core/enums/update_user.dart';
import 'package:tdd_education_app/src/authentication/domain/usecases/update_user.dart';

import 'auth_repo.mock.dart';

void main() {
  late MockAuthRepo repo;
  late UpdateUserUsecase usecase;

  setUp(() {
    repo = MockAuthRepo();
    usecase = UpdateUserUsecase(repo);
    registerFallbackValue(UpdateUserAction.email);
  });

  test(
    'should call the [AuthRepo]',
    () async {
      when(
        () => repo.updateUser(
          action: any(named: 'action'),
          userData: any<dynamic>(named: 'userData'),
        ),
      ).thenAnswer((_) async => const Right(null));

      final result = await usecase(
        const UpdateUserParams(
          action: UpdateUserAction.email,
          userData: 'Test email',
        ),
      );

      expect(result, const Right<dynamic, void>(null));

      verify(
        () => repo.updateUser(
          action: UpdateUserAction.email,
          userData: 'Test email',
        ),
      ).called(1);

      verifyNoMoreInteractions(repo);
    },
  );
}
