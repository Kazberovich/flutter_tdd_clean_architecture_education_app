import 'package:flutter/material.dart';
import 'package:tdd_education_app/src/quick_access/presentation/tab_tile.dart';

class QuickAccessTabBar extends StatelessWidget {
  const QuickAccessTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TabTile(index: 0, title: 'Document'),
        TabTile(index: 1, title: 'Exam'),
        TabTile(index: 2, title: 'Passed'),
      ],
    );
  }
}
