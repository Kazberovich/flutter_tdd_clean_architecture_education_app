import 'package:badges/badges.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_education_app/core/common/views/loading_view.dart';
import 'package:tdd_education_app/core/common/widgets/nested_back_button.dart';
import 'package:tdd_education_app/core/extensions/context_extension.dart';
import 'package:tdd_education_app/core/services/injection_container.dart';
import 'package:tdd_education_app/core/utils/core_utils.dart';
import 'package:tdd_education_app/src/notifications/presentation/cubit/notification_cubit.dart';
import 'package:tdd_education_app/src/notifications/presentation/widgets/no_notifications.dart';
import 'package:tdd_education_app/src/notifications/presentation/widgets/notification_options.dart';
import 'package:tdd_education_app/src/notifications/presentation/widgets/notification_tile.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  @override
  void initState() {
    super.initState();

    context.read<NotificationCubit>().getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: false,
        titleSpacing: 0,
        leading: const NestedBackButton(),
        actions: const [NotificationOptions()],
      ),
      body: BlocConsumer<NotificationCubit, NotificationState>(
        listener: (context, state) {
          if (state is NotificationError) {
            CoreUtils.showSnackBar(context, state.message);
            context.pop();
          }
        },
        builder: (context, state) {
          if (state is GettingNotifications) {
            return const LoadingView();
          } else if (state is NotificationsLoaded &&
              state.notifications.isEmpty) {
            return const NoNotifications();
          } else if (state is NotificationsLoaded) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final notification = state.notifications[index];

                return Badge(
                  showBadge: !notification.seen,
                  position: BadgePosition.topEnd(top: 30, end: 20),
                  child: BlocProvider(
                    create: (context) => serviceLocator<NotificationCubit>(),
                    child: NotificationTile(
                      notification: notification,
                    ),
                  ),
                );
              },
              itemCount: state.notifications.length,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
