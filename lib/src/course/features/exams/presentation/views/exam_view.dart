import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tdd_education_app/core/utils/core_utils.dart';
import 'package:tdd_education_app/src/course/features/exams/presentation/app/cubit/exam_cubit.dart';
import 'package:tdd_education_app/src/course/features/exams/presentation/app/providers/exam_controller.dart';

class ExamView extends StatefulWidget {
  const ExamView({super.key});

  static const routeName = '/exam';

  @override
  State<ExamView> createState() => _ExamViewState();
}

class _ExamViewState extends State<ExamView> {
  bool showingLoader = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ExamController>(
      builder: (_, controller, __) {
        return BlocListener(
          listener: (_, state) {
            if (showingLoader) {
              Navigator.pop(context);
              showingLoader = false;
            }
            if (state is ExamError) {
              CoreUtils.showSnackBar(context, state.message);
            } else if (state is SubmittingExam) {
              CoreUtils.showLoadingDialog(context);
              showingLoader = true;
            } else if (state is ExamSubmitted) {
              CoreUtils.showSnackBar(context, 'Exam Submitted');
              Navigator.pop(context);
            }
          },
        );
      },
    );
  }
}
