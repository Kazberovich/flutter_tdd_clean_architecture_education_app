import 'dart:js_interop';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:tdd_education_app/core/common/widgets/course_picker.dart';
import 'package:tdd_education_app/core/common/widgets/information_field.dart';
import 'package:tdd_education_app/core/extensions/context_extension.dart';
import 'package:tdd_education_app/core/res/colours.dart';

import 'package:tdd_education_app/src/course/domain/entities/course.dart';
import 'package:tdd_education_app/src/course/features/materials/domain/entities/picked_resource.dart';
import 'package:tdd_education_app/src/course/features/materials/domain/entities/resource.dart';

class AddMaterialsView extends StatefulWidget {
  const AddMaterialsView({super.key});

  static const routeName = '/add-materials';

  @override
  State<AddMaterialsView> createState() => _AddMaterialsViewState();
}

class _AddMaterialsViewState extends State<AddMaterialsView> {
  final resources = <PickedResource>[];

  final formKey = GlobalKey<FormState>();
  final courseController = TextEditingController();
  final authorController = TextEditingController();
  final courseNotifier = ValueNotifier<Course?>(null);

  bool authorSet = false;

  Future<void> pickResource() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() {
        resources.addAll(
          result.paths.map(
            (path) => PickedResource(
              path: path!,
              author: authorController.text.trim(),
              title: path.split('/').last,
            ),
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    courseNotifier.dispose();
    courseController.dispose();
    authorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Add Materials'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: [
                Form(
                  key: formKey,
                  child: CoursePicker(
                    controller: courseController,
                    notifier: courseNotifier,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                InformationField(
                  controller: authorController,
                  border: true,
                  hintText: 'General Author',
                  onChanged: (_) {
                    if (authorSet) {
                      setState(() {
                        authorSet = false;
                      });
                    }
                  },
                  suffixIcon: IconButton(
                    icon: Icon(
                      authorSet
                          ? Icons.check_circle
                          : Icons.check_circle_outline,
                    ),
                    color: authorSet ? Colors.green : Colors.grey,
                    onPressed: () {},
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'You can upload multiple materials at once.',
                  style: context.theme.textTheme.bodySmall
                      ?.copyWith(color: Colours.neutralTextColour),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
