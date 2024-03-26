import 'package:tdd_education_app/core/usecases/usecases.dart';
import 'package:tdd_education_app/core/utils/typedefs.dart';
import 'package:tdd_education_app/src/course/features/exams/domain/entities/user_exam.dart';

import 'package:tdd_education_app/src/course/features/exams/domain/repositories/exam_repository.dart';

class SubmitExam extends UsecaseWithParams<void, UserExam> {
  const SubmitExam(this._repository);

  final ExamRepository _repository;

  @override
  ResultFuture<void> call(UserExam params) => _repository.submitExam(params);
}
