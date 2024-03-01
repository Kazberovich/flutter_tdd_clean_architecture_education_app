import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_education_app/core/errors/exceptions.dart';
import 'package:tdd_education_app/core/errors/failures.dart';
import 'package:tdd_education_app/src/course/data/datasources/course_remote_datasource.dart';
import 'package:tdd_education_app/src/course/data/models/course_model.dart';
import 'package:tdd_education_app/src/course/data/repositories/course_repository_implementation.dart';
import 'package:tdd_education_app/src/course/domain/entities/course.dart';

class MockCourseRemoteDataSource extends Mock
    implements CourseRemoteDataSource {}

void main() {
  late CourseRemoteDataSource remoteDataSource;
  late CourseRepositoryImplementation repositoryImplementation;

  final tCourse = CourseModel.empty();

  setUp(() {
    remoteDataSource = MockCourseRemoteDataSource();
    repositoryImplementation = CourseRepositoryImplementation(remoteDataSource);
    registerFallbackValue(tCourse);
  });

  const tException =
      ServerException(message: 'Something went wrong', statusCode: '500');

  group('addCourse', () {
    test(
        'should complete successfully when call '
        'to remote datasource is successful', () async {
      when(() => remoteDataSource.addCourse(any())).thenAnswer(
        (_) async => Future.value(),
      );
      final result = await repositoryImplementation.addCourse(tCourse);
      expect(result, const Right<dynamic, void>(null));
      verify(() => remoteDataSource.addCourse(tCourse)).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test(
        'should return [ServerFailure] when call '
        'to remote datasource is unsuccessful', () async {
      when(() => remoteDataSource.addCourse(any())).thenThrow(tException);

      final result = await repositoryImplementation.addCourse(tCourse);

      expect(
        result,
        Left<Failure, void>(ServerFailure.fromException(tException)),
      );
      verify(() => remoteDataSource.addCourse(tCourse)).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });

  group('getCourses', () {
    test(
        'should return [List<Course>] when call to remote source is successful',
        () async {
      when(() => remoteDataSource.getCourses()).thenAnswer(
        (invocation) async => [tCourse],
      );

      final result = await repositoryImplementation.getCourses();
      expect(result, isA<Right<dynamic, List<Course>>>());
      verify(() => remoteDataSource.getCourses()).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test(
        'should return [ServerFailure] when call '
        'to remote source is unsuccessful', () async {
      when(() => remoteDataSource.getCourses()).thenThrow(tException);

      final result = await repositoryImplementation.getCourses();
      expect(
        result,
        Left<Failure, void>(ServerFailure.fromException(tException)),
      );

      verify(() => remoteDataSource.getCourses()).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });
}
