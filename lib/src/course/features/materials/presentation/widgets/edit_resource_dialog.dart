import 'package:flutter/material.dart';
import 'package:tdd_education_app/src/course/features/materials/domain/entities/picked_resource.dart';

class EditResourceDialog extends StatefulWidget {
  const EditResourceDialog({required this.resource, super.key});

  final PickedResource resource;

  @override
  State<EditResourceDialog> createState() => _EditResourceDialogState();
}

class _EditResourceDialogState extends State<EditResourceDialog> {
  @override
  Widget build(BuildContext context) {
    return const Material(
      child: Placeholder(),
    );
  }
}
