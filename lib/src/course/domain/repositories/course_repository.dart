import 'package:tdd_education_app/core/utils/typedefs.dart';
import 'package:tdd_education_app/src/course/domain/entities/course.dart';

abstract class CourseRepository {
  const CourseRepository();

  ResultFuture<List<Course>> getCourses();

  ResultFuture<void> addCourse(Course course);
}
