import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tdd_education_app/core/common/app/providers/user_provider.dart';
import 'package:tdd_education_app/core/res/media_resources.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (_, provider, __) {
        final user = provider.user;
        final image =
            user?.profilePicture == null || user!.profilePicture!.isEmpty
                ? null
                : user.profilePicture;
        return Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: image != null
                  ? NetworkImage(image)
                  : const AssetImage(MediaRes.user) as ImageProvider,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              user?.fullName ?? 'No user',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        );
      },
    );
  }
}
