import 'package:tdd_education_app/core/usecases/usecases.dart';
import 'package:tdd_education_app/core/utils/typedefs.dart';
import 'package:tdd_education_app/src/course/features/exams/domain/entities/user_exam.dart';
import 'package:tdd_education_app/src/course/features/exams/domain/repositories/exam_repository.dart';

class GetUserCourseExams
    extends FutureUsecaseWithParams<List<UserExam>, String> {
  const GetUserCourseExams(this._repository);

  final ExamRepository _repository;

  @override
  ResultFuture<List<UserExam>> call(String params) =>
      _repository.getUserCourseExams(params);
}
