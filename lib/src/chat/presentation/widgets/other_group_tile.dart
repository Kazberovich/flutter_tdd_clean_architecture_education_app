import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_education_app/core/common/widgets/time_text.dart';
import 'package:tdd_education_app/core/extensions/context_extension.dart';
import 'package:tdd_education_app/core/res/colours.dart';
import 'package:tdd_education_app/core/services/injection_container.dart';
import 'package:tdd_education_app/src/chat/domain/entities/group.dart';
import 'package:tdd_education_app/src/chat/presentation/cubit/chat_cubit.dart';
import 'package:tdd_education_app/src/chat/presentation/views/chat_view.dart';

class OtherGroupTile extends StatelessWidget {
  const OtherGroupTile(this.group, {super.key});

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
      trailing: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colours.primaryColour,
          foregroundColor: Colors.white,
        ),
        onPressed: () {
          context.read<ChatCubit>().joinGroup(
                groupId: group.id,
                userId: context.currentUser!.uid,
              );
        },
        child: const Text('Join'),
      ),
    );
  }
}
