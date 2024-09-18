import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_education_app/core/common/views/loading_view.dart';
import 'package:tdd_education_app/core/extensions/context_extension.dart';
import 'package:tdd_education_app/core/services/injection_container.dart';
import 'package:tdd_education_app/core/utils/core_utils.dart';
import 'package:tdd_education_app/src/chat/domain/entities/group.dart';
import 'package:tdd_education_app/src/chat/domain/entities/message.dart';
import 'package:tdd_education_app/src/chat/presentation/cubit/chat_cubit.dart';
import 'package:tdd_education_app/src/chat/presentation/refactors/chat_app_bar.dart';
import 'package:tdd_education_app/src/chat/presentation/widgets/chat_input_field.dart';
import 'package:tdd_education_app/src/chat/presentation/widgets/message_bubble.dart';

class ChatView extends StatefulWidget {
  const ChatView({required this.group, super.key});

  final Group group;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  bool showingDialog = false;
  List<Message> messages = [];
  bool showInputField = false;

  @override
  void initState() {
    context.read<ChatCubit>().getMessages(widget.group.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ChatAppBar(group: widget.group),
      body: BlocConsumer<ChatCubit, ChatState>(
        listener: (_, state) {
          if (showingDialog) {
            Navigator.of(context).pop();
            showingDialog = false;
          }
          if (state is ChatError) {
            CoreUtils.showSnackBar(context, state.message);
          } else if (state is LeavingGroup) {
            showingDialog = true;
            CoreUtils.showLoadingDialog(context);
          } else if (state is LeftGroup) {
            context.pop();
          } else if (state is MessagesLoaded) {
            setState(() {
              messages = state.messages;
              showInputField = true;
            });
          }
        },
        builder: (context, state) {
          if (state is LoadingMessages) {
            return const LoadingView();
          } else if (state is MessagesLoaded ||
              showInputField ||
              messages.isNotEmpty) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (_, index) {
                      final message = messages[index];
                      final previousMessage =
                          index > 0 ? messages[index - 1] : null;
                      final showSenderInfo = previousMessage == null ||
                          previousMessage.senderId != message.senderId;
                      return BlocProvider(
                        create: (_) => serviceLocator<ChatCubit>(),
                        child: MessageBubble(
                          key: ValueKey(message.id),
                          message,
                          showSenderInfo: showSenderInfo,
                        ),
                      );
                    },
                  ),
                ),
                const Divider(height: 1),
                BlocProvider(
                  create: (_) => serviceLocator<ChatCubit>(),
                  child: ChatInputField(groupId: widget.group.id),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
