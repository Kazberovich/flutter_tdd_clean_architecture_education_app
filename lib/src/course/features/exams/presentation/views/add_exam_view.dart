import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_education_app/core/common/widgets/course_picker.dart';
import 'package:tdd_education_app/core/enums/notification_enum.dart';
import 'package:tdd_education_app/core/utils/core_utils.dart';
import 'package:tdd_education_app/core/utils/typedefs.dart';
import 'package:tdd_education_app/src/course/domain/entities/course.dart';
import 'package:tdd_education_app/src/course/features/exams/data/models/exam_model.dart';
import 'package:tdd_education_app/src/course/features/exams/presentation/cubit/exam_cubit.dart';
import 'package:tdd_education_app/src/notifications/presentation/widgets/notification_wrapper.dart';

class AddExamView extends StatefulWidget {
  const AddExamView({super.key});

  static const routeName = '/add-exams';

  @override
  State<AddExamView> createState() => _AddExamViewState();
}

class _AddExamViewState extends State<AddExamView> {
  File? examFile;

  final formKey = GlobalKey<FormState>();
  final courseController = TextEditingController();
  final courseNotifier = ValueNotifier<Course?>(null);

  Future<void> pickExamFile() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['json']);
    if (result != null) {
      setState(() {
        examFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> uploadExam() async {
    if (examFile == null) {
      return CoreUtils.showSnackBar(context, 'Please pick an exam to upload');
    }
    if (formKey.currentState!.validate()) {
      final json = examFile!.readAsStringSync();
      final jsonMap = jsonDecode(json) as DataMap;
      final exam = ExamModel.fromUploadMap(jsonMap)
        ..copyWith(
          courseId: courseNotifier.value!.id,
        );
      await context.read<ExamCubit>().uploadExam(exam);
    }
  }

  bool showingDialog = false;

  @override
  void dispose() {
    courseNotifier.dispose();
    courseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationWrapper(
      child: BlocListener<ExamCubit, ExamState>(
        listener: (context, state) {
          if (showingDialog == true) {
            Navigator.pop(context);
            showingDialog = false;
          }
          if (state is UploadingExam) {
            CoreUtils.showLoadingDialog(context);
            showingDialog = true;
          } else if (state is ExamError) {
            CoreUtils.showSnackBar(context, state.message);
          } else if (state is ExamUploaded) {
            CoreUtils.showSnackBar(context, 'Exam added successfully');
            CoreUtils.sendNotification(
              context,
              title: 'New (${courseNotifier.value!.title.trim()} exam)',
              body: 'A new exam has been added',
              category: NotificationCategory.TEST,
            );
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(title: const Text('Add Exam')),
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      onNotificationSent: () {
        Navigator.pop(context);
      },
    );
  }
}
