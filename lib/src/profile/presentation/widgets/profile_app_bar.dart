import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_education_app/core/common/app/providers/tab_navigator.dart';
import 'package:tdd_education_app/core/common/widgets/popup_item.dart';
import 'package:tdd_education_app/core/extensions/context_extension.dart';
import 'package:tdd_education_app/core/res/colours.dart';
import 'package:provider/provider.dart';
import 'package:iconly/iconly.dart';
import 'package:tdd_education_app/core/services/injection_container.dart';
import 'package:tdd_education_app/src/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:tdd_education_app/src/profile/presentation/views/edit_profile_view.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Account',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
      ),
      actions: [
        PopupMenuButton(
          icon: const Icon(Icons.more_horiz_outlined),
          surfaceTintColor: Colors.white,
          itemBuilder: (context) => [
            PopupMenuItem<void>(
              child: const PopupItem(
                title: 'Edit profile',
                icon: Icon(
                  Icons.edit_outlined,
                  color: Colours.neutralTextColour,
                ),
              ),
              onTap: () => context.push(
                BlocProvider(
                  create: (_) => serviceLocator<AuthenticationBloc>(),
                  child: const EditProfileView(),
                ),
              ),
            ),
            PopupMenuItem<void>(
              child: const PopupItem(
                title: 'Notifications',
                icon: Icon(
                  IconlyLight.notification,
                  color: Colours.neutralTextColour,
                ),
              ),
              onTap: () => context.push(const Placeholder()),
            ),
            PopupMenuItem<void>(
              child: const PopupItem(
                title: 'Help',
                icon: Icon(
                  Icons.help_outline_outlined,
                  color: Colours.neutralTextColour,
                ),
              ),
              onTap: () => context.push(const Placeholder()),
            ),
            PopupMenuItem<void>(
              padding: EdgeInsets.zero,
              height: 3,
              child: Divider(
                height: 3,
                color: Colors.grey.shade300,
                endIndent: 16,
                indent: 16,
              ),
            ),
            PopupMenuItem<void>(
              child: const PopupItem(
                title: 'Logout',
                icon: Icon(
                  Icons.logout_rounded,
                  color: Colors.black,
                ),
              ),
              onTap: () async {
                final navigator = Navigator.of(context);
                await FirebaseAuth.instance.signOut();
                unawaited(
                  navigator.pushNamedAndRemoveUntil('/', (route) => false),
                );
              },
            ),
          ],
          offset: const Offset(0, 50),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
