import 'package:tdd_education_app/core/usecases/usecases.dart';
import 'package:tdd_education_app/core/utils/typedefs.dart';
import 'package:tdd_education_app/src/course/domain/entities/course.dart';
import 'package:tdd_education_app/src/course/domain/repositories/course_repository.dart';

class AddCourse extends FutureUsecaseWithParams<void, Course> {
  const AddCourse(this._repository);

  final CourseRepository _repository;

  @override
  ResultFuture<void> call(Course params) async => _repository.addCourse(params);
}
