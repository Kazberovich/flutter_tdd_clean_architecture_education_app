import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tdd_education_app/src/notifications/presentation/cubit/notification_cubit.dart';

class NotificationWrapper extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return BlocListener<NotificationCubit, NotificationState>(
      listener: (context, state) {
        if (state is NotificationSent) {
          extraActivity?.call();
          onNotificationSent();
        }
      },
      child: child,
    );
  }
}
