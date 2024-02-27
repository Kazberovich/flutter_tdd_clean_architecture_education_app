import 'package:dartz/dartz.dart';
import 'package:tdd_education_app/core/common/features/course/data/datasources/course_remote_datasource.dart';
import 'package:tdd_education_app/core/common/features/course/domain/entities/course.dart';
import 'package:tdd_education_app/core/common/features/course/domain/repositories/course_repository.dart';
import 'package:tdd_education_app/core/utils/typedefs.dart';

class CourseRepositoryImplementation implements CourseRepository {
  const CourseRepositoryImplementation(this.remoteDataSource);

  final CourseRemoteDataSource remoteDataSource;

  @override
  ResultFuture<void> addCourse(Course course) async {
    await remoteDataSource.addCourse(course);
    return const Right(null);
  }

  @override
  ResultFuture<List<Course>> getCourses() async {
    // TODO: implement getCourses
    throw UnimplementedError();
  }
}
