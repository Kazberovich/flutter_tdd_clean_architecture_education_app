import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_education_app/core/common/widgets/gradient_background.dart';
import 'package:tdd_education_app/core/res/media_resources.dart';
import 'package:tdd_education_app/core/utils/core_utils.dart';
import 'package:tdd_education_app/src/course/features/exams/data/models/exam_model.dart';
import 'package:tdd_education_app/src/course/features/exams/domain/entities/exam.dart';
import 'package:tdd_education_app/src/course/features/exams/presentation/cubit/exam_cubit.dart';

class ExamDetailsView extends StatefulWidget {
  const ExamDetailsView(this.exam, {super.key});

  static const routeName = 'exam-details';

  final Exam exam;

  @override
  State<ExamDetailsView> createState() => _ExamDetailsViewState();
}

class _ExamDetailsViewState extends State<ExamDetailsView> {
  late Exam completeExam;

  void getQuestions() {
    context.read<ExamCubit>().getExamQuestions(widget.exam);
  }

  @override
  void initState() {
    super.initState();
    getQuestions();
    completeExam = widget.exam;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      appBar: AppBar(
        title: Text(widget.exam.title),
      ),
      body: GradientBackground(
        image: MediaRes.documentsGradientBackground,
        child: BlocConsumer<ExamCubit, ExamState>(
          listener: (context, state) {
            if (state is ExamError) {
              CoreUtils.showSnackBar(context, state.message);
            } else if (state is ExamQuestionsLoaded) {
              completeExam = (completeExam as ExamModel).copyWith(
                questions: state.questions,
              );
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
