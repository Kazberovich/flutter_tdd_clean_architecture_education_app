import 'package:flutter/material.dart';
import 'package:tdd_education_app/src/chat/domain/entities/group.dart';

class ChatView extends StatefulWidget {
  const ChatView({required this.group, super.key});

  final Group group;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
