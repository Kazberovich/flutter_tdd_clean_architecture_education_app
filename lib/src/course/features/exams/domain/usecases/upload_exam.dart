import 'package:tdd_education_app/core/usecases/usecases.dart';
import 'package:tdd_education_app/core/utils/typedefs.dart';
import 'package:tdd_education_app/src/course/features/exams/domain/entities/exam.dart';
import 'package:tdd_education_app/src/course/features/exams/domain/repositories/exam_repository.dart';

class UploadExam extends FutureUsecaseWithParams<void, Exam> {
  const UploadExam(this._repository);

  final ExamRepository _repository;

  @override
  ResultFuture<void> call(Exam params) => _repository.uploadExam(params);
}
