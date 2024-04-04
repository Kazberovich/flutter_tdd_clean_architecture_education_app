import 'package:equatable/equatable.dart';
import 'package:tdd_education_app/core/usecases/usecases.dart';
import 'package:tdd_education_app/core/utils/typedefs.dart';
import 'package:tdd_education_app/src/authentication/domain/repositories/authentication_repository.dart';

class SignUpUsecase extends FutureUsecaseWithParams<void, SignUpParams> {
  const SignUpUsecase(this._repository);

  final AuthenticationRepository _repository;

  @override
  ResultFuture<void> call(SignUpParams params) => _repository.signUp(
        email: params.email,
        fullName: params.fullName,
        password: params.password,
      );
}

class SignUpParams extends Equatable {
  const SignUpParams({
    required this.email,
    required this.password,
    required this.fullName,
  });

  const SignUpParams.empty() : this(email: '', password: '', fullName: '');

  final String email;
  final String password;
  final String fullName;

  @override
  List<Object?> get props => [email, password, fullName];
}
