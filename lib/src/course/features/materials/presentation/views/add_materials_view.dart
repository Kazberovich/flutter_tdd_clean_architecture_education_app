import 'package:flutter/material.dart';
import 'package:tdd_education_app/core/common/widgets/course_picker.dart';
import 'package:tdd_education_app/core/common/widgets/information_field.dart';

import 'package:tdd_education_app/src/course/domain/entities/course.dart';

class AddMaterialsView extends StatefulWidget {
  const AddMaterialsView({super.key});

  static const routeName = '/add-materials';

  @override
  State<AddMaterialsView> createState() => _AddMaterialsViewState();
}

class _AddMaterialsViewState extends State<AddMaterialsView> {
  final formKey = GlobalKey<FormState>();
  final courseController = TextEditingController();
  final authorController = TextEditingController();
  final courseNotifier = ValueNotifier<Course?>(null);

  bool authorSet = false;

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
                    onPressed: () {
                      
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
