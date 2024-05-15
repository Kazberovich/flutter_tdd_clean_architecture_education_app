import 'package:tdd_education_app/core/usecases/usecases.dart';
import 'package:tdd_education_app/core/utils/typedefs.dart';
import 'package:tdd_education_app/src/chat/domain/entities/message.dart';
import 'package:tdd_education_app/src/chat/domain/repositories/chat_repository.dart';

class SendMessage extends FutureUsecaseWithParams<void, Message> {
  const SendMessage(this._repo);

  final ChatRepo _repo;

  @override
  ResultFuture<void> call(Message params) async => _repo.sendMessage(params);
}
