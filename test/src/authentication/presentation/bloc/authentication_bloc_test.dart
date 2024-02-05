import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
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

  // after each individual test, the state gets reset
  tearDown(() => authenticationBloc.close());
}
