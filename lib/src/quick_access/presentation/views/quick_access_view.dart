import 'package:flutter/material.dart';
import 'package:tdd_education_app/core/common/widgets/gradient_background.dart';
import 'package:tdd_education_app/core/res/media_resources.dart';
import 'package:tdd_education_app/src/quick_access/presentation/refactors/quick_access_app_bar.dart';
import 'package:tdd_education_app/src/quick_access/presentation/refactors/quick_access_header.dart';
import 'package:tdd_education_app/src/quick_access/presentation/refactors/quick_access_tab_bar.dart';
import 'package:tdd_education_app/src/quick_access/presentation/refactors/quick_access_tab_body.dart';

class QuickAccessView extends StatelessWidget {
  const QuickAccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: QuickAccessAppBar(),
      body: GradientBackground(
        image: MediaRes.documentsGradientBackground,
        child: Center(
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: QuickAccessHeader(),
              ),
              Expanded(
                child: QuickAccessTabBar(),
              ),
              Expanded(
                child: QuickAccessTabBody(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
