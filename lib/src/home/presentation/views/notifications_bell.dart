import 'package:badges/badges.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:tdd_education_app/src/notifications/presentation/cubit/notification_cubit.dart';

class NotificationBell extends StatefulWidget {
  const NotificationBell({super.key});

  @override
  State<NotificationBell> createState() => _NotificationBellState();
}

class _NotificationBellState extends State<NotificationBell> {
  @override
  void initState() {
    super.initState();

    context.read<NotificationCubit>().getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        if (state is NotificationsLoaded) {
          final unseenNotificationsLength = state.notifications
              .where((notification) => !notification.seen)
              .length;
          final showBadge = unseenNotificationsLength > 0;
          return GestureDetector(
            // TODO(Notifications): Push to Notifications
            onTap: (){},
            child: Badge(
              showBadge: showBadge,
              position: BadgePosition.topEnd(top: -16, end: -11),
              badgeContent: Text(
                unseenNotificationsLength.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              child: const Icon(IconlyLight.notification),
            ),
          );
        }
        return const Icon(IconlyLight.notification);
      },
    );
  }
}
