import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:tdd_education_app/core/common/app/providers/user_provider.dart';
import 'package:tdd_education_app/core/res/media_resources.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('My Classes'),
      centerTitle: false,
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search),
        ),
        const Icon(IconlyLight.notification),
        const SizedBox(
          width: 16,
        ),
        Consumer<UserProvider>(
          builder: (_, provider, __) {
            return Padding(
              padding: const EdgeInsets.only(right: 16),
              child: CircleAvatar(
                radius: 24,
                backgroundImage: provider.user!.profilePicture != null
                    ? NetworkImage(provider.user!.profilePicture!)
                    : const AssetImage(MediaRes.user) as ImageProvider,
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
