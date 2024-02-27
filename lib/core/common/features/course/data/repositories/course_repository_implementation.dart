import 'package:dartz/dartz.dart';
import 'package:tdd_education_app/core/common/features/course/data/datasources/course_remote_datasource.dart';
import 'package:tdd_education_app/core/common/features/course/domain/entities/course.dart';
import 'package:tdd_education_app/core/common/features/course/domain/repositories/course_repository.dart';
import 'package:tdd_education_app/core/errors/exceptions.dart';
import 'package:tdd_education_app/core/errors/failures.dart';
import 'package:tdd_education_app/core/utils/typedefs.dart';

class CourseRepositoryImplementation implements CourseRepository {
  const CourseRepositoryImplementation(this.remoteDataSource);

  final CourseRemoteDataSource remoteDataSource;

  @override
  ResultFuture<void> addCourse(Course course) async {
    try {
      await remoteDataSource.addCourse(course);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<Course>> getCourses() async {
    final result = await remoteDataSource.getCourses();
    return Right(result);
  }
}
