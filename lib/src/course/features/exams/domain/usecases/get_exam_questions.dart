import 'package:tdd_education_app/core/usecases/usecases.dart';
import 'package:tdd_education_app/core/utils/typedefs.dart';
import 'package:tdd_education_app/src/course/features/exams/domain/entities/exam.dart';
import 'package:tdd_education_app/src/course/features/exams/domain/entities/exam_question.dart';
import 'package:tdd_education_app/src/course/features/exams/domain/repositories/exam_repository.dart';

class GetExamQuestions extends UsecaseWithParams<List<ExamQuestion>, Exam> {
  const GetExamQuestions(this._repository);

  final ExamRepository _repository;

  @override
  ResultFuture<List<ExamQuestion>> call(Exam params) =>
      _repository.getExamQuestions(params);
}
