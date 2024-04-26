import 'package:flutter/material.dart';
import 'package:tdd_education_app/core/common/widgets/information_field.dart';

import 'package:tdd_education_app/src/course/features/materials/domain/entities/picked_resource.dart';

class EditResourceDialog extends StatefulWidget {
  const EditResourceDialog({required this.resource, super.key});

  final PickedResource resource;

  @override
  State<EditResourceDialog> createState() => _EditResourceDialogState();
}

class _EditResourceDialogState extends State<EditResourceDialog> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final authorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.resource.title.trim();
    descriptionController.text = widget.resource.description.trim();
    authorController.text = widget.resource.author.trim();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    authorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InformationField(
                controller: titleController,
                border: true,
                hintText: 'Title',
              ),
              const SizedBox(height: 10),
              InformationField(
                controller: descriptionController,
                border: true,
                hintText: 'Description',
              ),
              const SizedBox(height: 10),
              InformationField(
                controller: authorController,
                border: true,
                hintText: 'Author',
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      final newResource = widget.resource.copyWith(
                        title: titleController.text.trim(),
                        description: descriptionController.text.trim(),
                        author: authorController.text.trim(),
                        authorManuallySet: authorController.text.trim() !=
                            widget.resource.author,
                      );
                      Navigator.pop(context, newResource);
                    },
                    child: const Text('Confirm'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
