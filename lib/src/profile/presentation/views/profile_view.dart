import 'package:flutter/material.dart';
import 'package:tdd_education_app/core/common/widgets/gradient_background.dart';
import 'package:tdd_education_app/core/res/media_resources.dart';
import 'package:tdd_education_app/src/profile/presentation/refactors/profile_header.dart';
import 'package:tdd_education_app/src/profile/presentation/widgets/profile_app_bar.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: const ProfileAppBar(),
      body: GradientBackground(
        image: MediaRes.profileGradientBackground,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: const [ProfileHeader()],
        ),
      ),
    );
  }
}
