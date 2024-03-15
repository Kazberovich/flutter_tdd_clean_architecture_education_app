import 'package:flutter/material.dart';
import 'package:tdd_education_app/core/res/colours.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.sectionTitle,
    required this.seAll,
    required this.onSeeAll,
    super.key,
  });

  final String sectionTitle;
  final bool seAll;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          sectionTitle,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (seAll)
          TextButton(
            onPressed: onSeeAll,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              splashFactory: NoSplash.splashFactory,
            ),
            child: const Text(
              'See All',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colours.primaryColour,
              ),
            ),
          )
      ],
    );
  }
}
