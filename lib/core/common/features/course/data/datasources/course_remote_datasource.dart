import 'package:tdd_education_app/core/common/features/course/data/models/course_model.dart';
import 'package:tdd_education_app/core/common/features/course/domain/entities/course.dart';

abstract class CourseRemoteDataSource {
  const CourseRemoteDataSource();

  Future<List<CourseModel>> getCourses();

  Future<void> addCourse(Course course);
}
