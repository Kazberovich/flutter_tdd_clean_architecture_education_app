import 'package:tdd_education_app/core/usecases/usecases.dart';
import 'package:tdd_education_app/core/utils/typedefs.dart';
import 'package:tdd_education_app/src/authentication/domain/entities/user.dart';
import 'package:tdd_education_app/src/chat/domain/repositories/chat_repository.dart';

class GetUserById extends FutureUsecaseWithParams<LocalUser, String> {
  const GetUserById(this._repo);

  final ChatRepo _repo;

  @override
  ResultFuture<LocalUser> call(String params) => _repo.getUserById(params);
}
