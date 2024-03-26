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

  const Exam.empty()
      : this(
          id: 'empty.id',
          courseId: 'empty.courseId',
          title: 'empty.title',
          description: 'empty.description',
          timeLimit: 0,
          questions: const [],
        );

  final String id;
  final String courseId;
  final String title;
  final String? imageUrl;
  final String description;
  final int timeLimit;
  final List<ExamQuestion> questions;

  @override
  List<Object?> get props => [id, courseId];
}
