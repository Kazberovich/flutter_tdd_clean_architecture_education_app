import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tdd_education_app/core/common/widgets/gradient_background.dart';
import 'package:tdd_education_app/core/res/media_resources.dart';

class PageUnderConstruction extends StatelessWidget {
  const PageUnderConstruction({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        image: MediaRes.onBoardingBackground,
        child: Lottie.asset(MediaRes.pageUnderConstruction),
      ),
    );
  }
}
