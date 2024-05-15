
import 'package:equatable/equatable.dart';
import 'package:tdd_education_app/core/usecases/usecases.dart';
import 'package:tdd_education_app/core/utils/typedefs.dart';
import 'package:tdd_education_app/src/chat/domain/repositories/chat_repository.dart';

class JoinGroup extends FutureUsecaseWithParams<void, JoinGroupParams> {
  const JoinGroup(this._repo);

  final ChatRepo _repo;

  @override
  ResultFuture<void> call(JoinGroupParams params) => _repo.joinGroup(
        groupId: params.groupId,
        userId: params.userId,
      );
}

class JoinGroupParams extends Equatable {
  const JoinGroupParams({required this.groupId, required this.userId});

  const JoinGroupParams.empty()
      : groupId = '',
        userId = '';

  final String groupId;
  final String userId;

  @override
  List<String> get props => [groupId, userId];
}
