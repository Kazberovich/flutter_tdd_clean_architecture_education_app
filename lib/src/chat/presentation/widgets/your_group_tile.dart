import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_education_app/core/common/widgets/time_text.dart';
import 'package:tdd_education_app/core/extensions/context_extension.dart';
import 'package:tdd_education_app/core/services/injection_container.dart';
import 'package:tdd_education_app/src/chat/domain/entities/group.dart';
import 'package:tdd_education_app/src/chat/presentation/cubit/chat_cubit.dart';
import 'package:tdd_education_app/src/chat/presentation/views/chat_view.dart';

class YourGroupTile extends StatelessWidget {
  const YourGroupTile(this.group, {super.key});

  final Group group;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(group.name),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(360),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Image.network(
            group.groupImageUrl!,
          ),
        ),
      ),
      subtitle: group.lastMessage != null
          ? RichText(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                text: '~ ${group.lastMessageSenderName}: ',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                children: [
                  TextSpan(
                    text: '${group.lastMessage}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          : null,
      trailing: group.lastMessage != null
          ? TimeText(
              group.lastMessageTimeStamp!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      onTap: () {
        context.push(
          BlocProvider(
            create: (_) => serviceLocator<ChatCubit>(),
            child: ChatView(
              group: group,
            ),
          ),
        );
      },
    );
  }
}
