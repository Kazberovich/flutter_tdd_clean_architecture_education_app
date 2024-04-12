import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tdd_education_app/core/res/media_resources.dart';

class NoNotifications extends StatelessWidget {
  const NoNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(MediaRes.noNotifications),
    );
  }
}
