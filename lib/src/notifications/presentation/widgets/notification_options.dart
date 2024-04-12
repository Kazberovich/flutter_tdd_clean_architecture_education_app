import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tdd_education_app/core/common/app/providers/notifications_notifier.dart';
import 'package:tdd_education_app/core/common/widgets/popup_item.dart';
import 'package:tdd_education_app/core/res/colours.dart';
import 'package:tdd_education_app/src/notifications/presentation/cubit/notification_cubit.dart';

class NotificationOptions extends StatefulWidget {
  const NotificationOptions({super.key});

  @override
  State<NotificationOptions> createState() => _NotificationOptionsState();
}

class _NotificationOptionsState extends State<NotificationOptions> {
  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationsNotifier>(
      builder: (_, NotificationsNotifier notificationsNotifier, __) {
        return PopupMenuButton(
          offset: const Offset(0, 50),
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          itemBuilder: (context) => [
            PopupMenuItem<void>(
              onTap: () {
                notificationsNotifier.toggleMuteNotifications();
              },
              child: PopupItem(
                title: notificationsNotifier.muteNotifications
                    ? 'Un mute Notifications'
                    : 'Mute Notifications',
                icon: Icon(
                  notificationsNotifier.muteNotifications
                      ? Icons.notifications_off_outlined
                      : Icons.notifications_outlined,
                  color: Colours.neutralTextColour,
                ),
              ),
            ),
            PopupMenuItem<void>(
              onTap: () {
                context.read<NotificationCubit>().clearAll();
              },
              child: const PopupItem(
                title: 'Clear All',
                icon: Icon(
                  Icons.check_circle_outline,
                  color: Colours.neutralTextColour,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
