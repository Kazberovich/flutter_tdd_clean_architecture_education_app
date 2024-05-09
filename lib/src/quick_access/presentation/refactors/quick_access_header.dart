import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tdd_education_app/core/res/media_resources.dart';
import 'package:tdd_education_app/src/quick_access/presentation/provider/quick_access_tab_controller.dart';

class QuickAccessHeader extends StatelessWidget {
  const QuickAccessHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<QuickAccessTabController>(
      builder: (_, controller, __) {
        return Center(
          child: Image.asset(
            fit: BoxFit.cover,
            controller.currentIndex == 0
                ? MediaRes.bluePotPlant
                : controller.currentIndex == 1
                    ? MediaRes.turquoisePotPlant
                    : MediaRes.steamCup,
          ),
        );
      },
    );
  }
}
