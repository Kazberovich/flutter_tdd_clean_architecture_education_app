import 'package:flutter/material.dart';
import 'package:tdd_education_app/src/course/features/exams/domain/entities/user_exam.dart';

class ExamHistoryDetailScreen extends StatelessWidget {
  const ExamHistoryDetailScreen({
    required this.exam,
    super.key,
  });

  static const routeName = '/exam-history-details';

  final UserExam exam;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
