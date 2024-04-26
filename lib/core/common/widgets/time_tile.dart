import 'package:flutter/material.dart';
import 'package:tdd_education_app/core/common/widgets/time_text.dart';
import 'package:tdd_education_app/core/res/colours.dart';

class TimeTile extends StatelessWidget {
  const TimeTile({
    required this.time,
    this.prefixText,
    super.key,
  });

  final String? prefixText;
  final DateTime time;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colours.primaryColour,
        borderRadius: BorderRadius.circular(90),
      ),
      child: TimeText(
        time,
        prefixText: prefixText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
