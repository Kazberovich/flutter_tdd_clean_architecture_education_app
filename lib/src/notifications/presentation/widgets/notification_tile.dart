import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_education_app/core/common/widgets/time_text.dart';
import 'package:tdd_education_app/src/notifications/domain/entities/notification.dart';
import 'package:tdd_education_app/src/notifications/presentation/cubit/notification_cubit.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    required this.notification,
    super.key,
  });

  final Notification notification;

  @override
  Widget build(BuildContext context) {
    if (!notification.seen) {
      context.read<NotificationCubit>().markAsRead(notification.id);
    }
    return BlocListener<NotificationCubit, NotificationState>(
      listener: (context, state) {},
      child: Dismissible(
        key: Key(notification.id),
        direction: DismissDirection.endToStart,
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 16),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        child: ListTile(
          leading: CircleAvatar(
            radius: 24,
            backgroundColor: Colors.transparent,
            backgroundImage: AssetImage(notification.category.image),
          ),
          title: Text(
            notification.title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          subtitle: TimeText(notification.sentAt),
        ),
      ),
    );
  }
}
