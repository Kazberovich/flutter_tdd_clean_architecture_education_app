import 'package:flutter/material.dart';

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

  @override
  void dispose() {
    courseNotifier.dispose();
    courseController.dispose();
    authorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
