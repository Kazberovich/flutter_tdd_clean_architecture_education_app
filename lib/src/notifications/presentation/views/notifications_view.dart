import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_education_app/core/common/widgets/nested_back_button.dart';
import 'package:tdd_education_app/core/utils/core_utils.dart';

import 'package:tdd_education_app/src/notifications/presentation/cubit/notification_cubit.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  bool loading = false;

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
        leading: const NestedBackButton(),
        actions: [],
      ),
      body: BlocConsumer<NotificationCubit, NotificationState>(
        builder: (context, state) {
          // if (loading) {}
          return Placeholder();
        },
        listener: (context, state) {
          if (loading) {
            loading = false;
            Navigator.of(context).pop();
          }

          if (state is NotificationError) {
            CoreUtils.showSnackBar(context, state.message);
          } else if (state is ClearingNotifications) {
            loading = true;
            CoreUtils.showLoadingDialog(context);
          }
        },
      ),
    );
  }
}
