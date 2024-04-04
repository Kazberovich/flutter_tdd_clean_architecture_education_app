import 'package:equatable/equatable.dart';
import 'package:tdd_education_app/core/enums/update_user.dart';
import 'package:tdd_education_app/core/usecases/usecases.dart';
import 'package:tdd_education_app/core/utils/typedefs.dart';
import 'package:tdd_education_app/src/authentication/domain/repositories/authentication_repository.dart';

class UpdateUserUsecase extends FutureUsecaseWithParams<void, UpdateUserParams> {
  UpdateUserUsecase(this._repository);

  final AuthenticationRepository _repository;

  @override
  ResultFuture<void> call(UpdateUserParams params) => _repository.updateUser(
        action: params.action,
        userData: params.userData,
      );
}

class UpdateUserParams extends Equatable {
  const UpdateUserParams({required this.userData, required this.action});

  const UpdateUserParams.empty()
      : this(action: UpdateUserAction.displayName, userData: '');

  final dynamic userData;
  final UpdateUserAction action;

  @override
  List<Object?> get props => [action, userData];
}
