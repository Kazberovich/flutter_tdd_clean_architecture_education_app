import 'package:equatable/equatable.dart';
import 'package:tdd_education_app/core/usecases/usecases.dart';
import 'package:tdd_education_app/core/utils/typedefs.dart';
import 'package:tdd_education_app/src/authentication/domain/entities/user.dart';
import 'package:tdd_education_app/src/authentication/domain/repositories/authentication_repository.dart';

class SignInUsecase extends FutureUsecaseWithParams<LocalUser, SignInParams> {
  SignInUsecase(this._repository);

  final AuthenticationRepository _repository;

  @override
  ResultFuture<LocalUser> call(SignInParams params) =>
      _repository.signIn(email: params.email, password: params.password);
}

class SignInParams extends Equatable {
  const SignInParams({
    required this.email,
    required this.password,
  });

  const SignInParams.empty()
      : email = '',
        password = '';

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}
