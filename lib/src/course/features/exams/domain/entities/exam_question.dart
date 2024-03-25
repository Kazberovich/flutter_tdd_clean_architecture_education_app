import 'package:equatable/equatable.dart';
import 'package:tdd_education_app/src/course/features/exams/domain/entities/question_choice.dart';

class ExamQuestion extends Equatable {
  const ExamQuestion({
    required this.id,
    required this.courseId,
    required this.examId,
    required this.questionText,
    required this.choices,
    this.correctAnswer,
  });

  const ExamQuestion.empty()
      : this(
          id: 'empty.id',
          courseId: 'empty.courseId',
          examId: 'empty.examId',
          questionText: 'empty.examText',
          choices: const [],
        );

  final String id;
  final String courseId;
  final String examId;
  final String questionText;
  final String? correctAnswer;
  final List<QuestionChoice> choices;

  @override
  List<Object?> get props => [id, examId, courseId];
}
