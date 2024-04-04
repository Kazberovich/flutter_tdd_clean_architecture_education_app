import 'package:tdd_education_app/core/usecases/usecases.dart';
import 'package:tdd_education_app/core/utils/typedefs.dart';
import 'package:tdd_education_app/src/course/domain/entities/course.dart';
import 'package:tdd_education_app/src/course/domain/repositories/course_repository.dart';

class GetCourses extends FutureUsecaseWithoutParams<List<Course>> {
  const GetCourses(this._repository);

  final CourseRepository _repository;

  @override
  ResultFuture<List<Course>> call() async => _repository.getCourses();
}
