import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tdd_education_app/core/res/media_resources.dart';

class PageUnderConstruction extends StatelessWidget {
  const PageUnderConstruction({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              MediaRes.onBoardingBackground,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Lottie.asset(
              MediaRes.pageUnderConstruction,
            ),
          ),
        ),
      ),
    );
  }
}
