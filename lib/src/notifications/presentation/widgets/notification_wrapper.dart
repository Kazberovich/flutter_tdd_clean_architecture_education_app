import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_education_app/core/utils/core_utils.dart';

import 'package:tdd_education_app/src/notifications/presentation/cubit/notification_cubit.dart';

class NotificationWrapper extends StatefulWidget {
  const NotificationWrapper({
    required this.child,
    required this.onNotificationSent,
    super.key,
    this.extraActivity,
  });

  final Widget child;
  final VoidCallback? extraActivity;
  final VoidCallback onNotificationSent;

  @override
  State<NotificationWrapper> createState() => _NotificationWrapperState();
}

class _NotificationWrapperState extends State<NotificationWrapper> {
  bool showLoadingDialog = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationCubit, NotificationState>(
      listener: (context, state) {
        if(showLoadingDialog){
          Navigator.pop(context);
          showLoadingDialog = false;
        }
        if (state is NotificationSent) {
          widget.extraActivity?.call();
          widget.onNotificationSent();
        } else if (state is SendingNotification) {
          showLoadingDialog = true;
          CoreUtils.showLoadingDialog(context);
        }
      },
      child: widget.child,
    );
  }
}
