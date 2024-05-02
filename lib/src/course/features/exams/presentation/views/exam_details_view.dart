import 'package:flutter/material.dart';
import 'package:tdd_education_app/src/course/features/exams/domain/entities/exam.dart';

class ExamDetailsView extends StatelessWidget {
  const ExamDetailsView(this.exam, {super.key});

  static const routeName = 'exam-details';

  final Exam exam;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
