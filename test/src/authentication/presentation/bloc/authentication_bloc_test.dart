import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_education_app/core/errors/failures.dart';
import 'package:tdd_education_app/src/authentication/data/models/user_model.dart';
import 'package:tdd_education_app/src/authentication/domain/usecases/forgot_password.dart';
import 'package:tdd_education_app/src/authentication/domain/usecases/sign_in.dart';
import 'package:tdd_education_app/src/authentication/domain/usecases/sign_up.dart';
import 'package:tdd_education_app/src/authentication/domain/usecases/update_user.dart';
import 'package:tdd_education_app/src/authentication/presentation/bloc/authentication_bloc.dart';

class MockSignIn extends Mock implements SignInUsecase {}

class MockSignUp extends Mock implements SignUpUsecase {}

class MockForgotPassword extends Mock implements ForgotPasswordUsecase {}

class MockUpdateUser extends Mock implements UpdateUserUsecase {}

void main() {
  late SignInUsecase signInUsecase;
  late SignUpUsecase signUpUsecase;
  late ForgotPasswordUsecase forgotPasswordUsecase;
  late UpdateUserUsecase updateUserUsecase;
  late AuthenticationBloc authenticationBloc;

  const tPassword = 'password';
  const tEmail = 'email';
  const tFullName = 'fullName';

  const tSignUpParams = SignUpParams.empty();
  const tUpdateUserParams = UpdateUserParams.empty();
  const tSignInParams = SignInParams.empty();

  setUp(() {
    signInUsecase = MockSignIn();
    signUpUsecase = MockSignUp();
    forgotPasswordUsecase = MockForgotPassword();
    updateUserUsecase = MockUpdateUser();

    authenticationBloc = AuthenticationBloc(
      signInUsecase: signInUsecase,
      signUpUsecase: signUpUsecase,
      forgotPasswordUsecase: forgotPasswordUsecase,
      updateUserUsecase: updateUserUsecase,
    );
  });

  // runs once! instead of setUp
  setUpAll(() {
    registerFallbackValue(tUpdateUserParams);
    registerFallbackValue(tSignInParams);
    registerFallbackValue(tSignUpParams);
  });

  // after each individual test, the state gets reset
  tearDown(() => authenticationBloc.close());

  test('initialState should be [AuthenticationInitial]', () {
    expect(authenticationBloc.state, const AuthenticationInitial());
  });

  final tServerFailure = ServerFailure(
    message: 'user-not-found',
    statusCode: 'there is no user record corresponding to this identifier. '
        'The user may have been deleted',
  );

  group('SignInEvent', () {
    const tUser = LocalUserModel.empty();
    blocTest<AuthenticationBloc, AuthenticationState>(
      'should emit [AuthenticationLoading, SignedIn] '
      'when [SignInEvent] is added successful',
      build: () {
        when(() => signInUsecase(any()))
            .thenAnswer((_) async => const Right(tUser));
        return authenticationBloc;

        // act
      },
      act: (bloc) => bloc.add(
        SignInEvent(
          email: tSignInParams.email,
          password: tSignInParams.password,
        ),
      ),
      expect: () => [
        const AuthenticationLoading(),
        const SignedIn(tUser),
      ],
      verify: (_) {
        verify(() => signInUsecase(tSignInParams)).called(1);
        verifyNoMoreInteractions(signInUsecase);
      },
    );
    blocTest<AuthenticationBloc, AuthenticationState>(
      'should emit [AuthenticationLoading, AuthenticationError] '
      'when SignIn fails',
      build: () {
        when(() => signInUsecase(any()))
            .thenAnswer((_) async => Left(tServerFailure));
        return authenticationBloc;
      },
      act: (bloc) => bloc.add(
        SignInEvent(
          email: tSignInParams.email,
          password: tSignInParams.password,
        ),
      ),
      expect: () => [
        const AuthenticationLoading(),
        AuthenticationError(tServerFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => signInUsecase(tSignInParams)).called(1);
        verifyNoMoreInteractions(signInUsecase);
      },
    );
  });
}
