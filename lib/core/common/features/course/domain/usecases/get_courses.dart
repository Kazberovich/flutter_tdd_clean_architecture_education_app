import 'package:tdd_education_app/core/common/features/course/domain/entities/course.dart';
import 'package:tdd_education_app/core/common/features/course/domain/repositories/course_repository.dart';
import 'package:tdd_education_app/core/usecases/usecases.dart';
import 'package:tdd_education_app/core/utils/typedefs.dart';

class GetCourses extends UsecaseWithoutParams<List<Course>> {
  const GetCourses(this._repository);

  final CourseRepository _repository;

  @override
  ResultFuture<List<Course>> call() async => _repository.getCourses();
}
