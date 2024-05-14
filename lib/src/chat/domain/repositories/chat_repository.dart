import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:tdd_education_app/core/utils/typedefs.dart';
import 'package:tdd_education_app/src/authentication/domain/entities/user.dart';
import 'package:tdd_education_app/src/chat/domain/entities/group.dart';

abstract class ChatRepo {
  const ChatRepo();

  ResultFuture<void> sendMessage(Message message);

  ResultStream<List<Group>> getGroups();

  ResultStream<List<Message>> getMessages(String groupId);

  ResultFuture<void> joinGroup({
    required String groupId,
    required String userId,
  });

  ResultFuture<void> leaveGroup({
    required String groupId,
    required String userId,
  });

  ResultFuture<LocalUser> getUserById(String userId);
}
