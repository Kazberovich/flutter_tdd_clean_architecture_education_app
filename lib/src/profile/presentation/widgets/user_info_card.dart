import 'package:flutter/material.dart';

class UserInfoCard extends StatelessWidget {
  const UserInfoCard({
    required this.infoThemeColor,
    required this.infoIcon,
    required this.infoTitle,
    required this.infoValue,
    super.key,
  });

  final Color infoThemeColor;
  final Widget infoIcon;
  final String infoTitle;
  final String infoValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      width: 140,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE4E6EA)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: infoThemeColor,
                shape: BoxShape.circle,
              ),
              child: Center(child: infoIcon),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  infoTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                  ),
                ),
                Text(
                  infoValue,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
