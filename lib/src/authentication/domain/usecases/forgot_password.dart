import 'package:tdd_education_app/core/usecases/usecases.dart';
import 'package:tdd_education_app/core/utils/typedefs.dart';
import 'package:tdd_education_app/src/authentication/domain/repositories/authentication_repository.dart';

class ForgotPasswordUsecase extends FutureUsecaseWithParams<void, String> {
  const ForgotPasswordUsecase(this._repository);

  final AuthenticationRepository _repository;

  @override
  ResultFuture<void> call(String params) => _repository.forgotPassword(params);
}
