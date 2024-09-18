import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_education_app/core/common/widgets/nested_back_button.dart';
import 'package:tdd_education_app/core/common/widgets/popup_item.dart';
import 'package:tdd_education_app/core/res/colours.dart';
import 'package:tdd_education_app/core/services/injection_container.dart';

import 'package:tdd_education_app/src/chat/domain/entities/group.dart';
import 'package:tdd_education_app/src/chat/presentation/cubit/chat_cubit.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({required this.group, super.key});

  final Group group;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const NestedBackButton(),
      titleSpacing: 0,
      title: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(group.groupImageUrl!),
            backgroundColor: Colors.transparent,
          ),
          const SizedBox(width: 7),
          Text(group.name),
        ],
      ),
      foregroundColor: Colors.white,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.blue, Colors.green]),
        ),
      ),
      actions: [
        PopupMenuButton(
          offset: const Offset(0, 50),
          surfaceTintColor: Colors.white,
          icon: const Icon(Icons.more_horiz),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          itemBuilder: (_) => [
            PopupMenuItem<void>(
              child: const PopupItem(
                title: 'Exit Group',
                icon: Icon(
                  Icons.exit_to_app,
                  color: Colours.redColour,
                ),
              ),
              onTap: () async {
                final chatCubit = context.read<ChatCubit>();
                final result = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog.adaptive(
                      title: const Text('Exit Group'),
                      content: const Text(
                        'Are you sure you want to leave the group?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          child: const Text('Exit group'),
                        ),
                      ],
                    );
                  },
                );
                if (result ?? false) {
                  await chatCubit.leaveGroup(
                    groupId: group.id,
                    userId: serviceLocator<FirebaseAuth>().currentUser!.uid,
                  );
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
