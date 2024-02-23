import 'package:tdd_education_app/core/common/features/course/domain/entities/course.dart';
import 'package:tdd_education_app/core/utils/typedefs.dart';

abstract class CourseRepository {
  const CourseRepository();

  ResultFuture<List<Course>> getCourses();

  ResultFuture<void> addCourse(Course course);
}