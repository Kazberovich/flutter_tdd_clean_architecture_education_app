import 'package:tdd_education_app/core/usecases/usecases.dart';
import 'package:tdd_education_app/core/utils/typedefs.dart';
import 'package:tdd_education_app/src/course/features/exams/domain/entities/user_exam.dart';
import 'package:tdd_education_app/src/course/features/exams/domain/repositories/exam_repository.dart';

class GetUserExams extends FutureUsecaseWithoutParams<List<UserExam>> {
  const GetUserExams(this._repository);

  final ExamRepository _repository;

  @override
  ResultFuture<List<UserExam>> call() => _repository.getUserExams();
}
