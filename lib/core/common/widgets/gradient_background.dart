import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

import 'package:tdd_education_app/core/res/media_resources.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({
    required this.image,
    required this.child,
    super.key,
  });

  final String image;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(child: child),
    );
  }
}