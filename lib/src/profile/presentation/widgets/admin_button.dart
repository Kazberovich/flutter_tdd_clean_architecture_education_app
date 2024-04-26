import 'package:flutter/material.dart';
import 'package:tdd_education_app/core/res/colours.dart';

class AdminButton extends StatelessWidget {
  const AdminButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    super.key,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      label: Text(label),
      icon: Icon(icon),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colours.primaryColour,
        foregroundColor: Colors.white,
      ),
    );
  }
}
