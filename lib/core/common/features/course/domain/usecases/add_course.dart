import 'package:tdd_education_app/core/common/features/course/domain/entities/course.dart';
import 'package:tdd_education_app/core/common/features/course/domain/repositories/course_repository.dart';
import 'package:tdd_education_app/core/usecases/usecases.dart';
import 'package:tdd_education_app/core/utils/typedefs.dart';

class AddCourse extends UsecaseWithParams<void, Course> {
  const AddCourse(this._repository);

  final CourseRepository _repository;

  @override
  ResultFuture<void> call(Course params) async => _repository.addCourse(params);
}
