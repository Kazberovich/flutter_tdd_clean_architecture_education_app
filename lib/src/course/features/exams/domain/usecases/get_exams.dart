import 'package:tdd_education_app/core/usecases/usecases.dart';
import 'package:tdd_education_app/core/utils/typedefs.dart';
import 'package:tdd_education_app/src/course/features/exams/domain/entities/exam.dart';
import 'package:tdd_education_app/src/course/features/exams/domain/repositories/exam_repository.dart';

class GetExams extends UsecaseWithParams<List<Exam>, String> {
  const GetExams(this._repository);

  final ExamRepository _repository;

  @override
  ResultFuture<List<Exam>> call(String params) => _repository.getExams(params);
}
