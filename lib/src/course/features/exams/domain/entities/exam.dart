import 'package:equatable/equatable.dart';

import 'package:tdd_education_app/src/course/features/exams/domain/entities/exam_question.dart';

class Exam extends Equatable {
  const Exam({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.timeLimit,
    required this.questions,
    this.imageUrl,
  });

  final String id;
  final String courseId;
  final String title;
  final String? imageUrl;
  final String description;
  final String timeLimit;
  final List<ExamQuestion> questions;

  @override
  List<Object?> get props => [id, courseId];
}
