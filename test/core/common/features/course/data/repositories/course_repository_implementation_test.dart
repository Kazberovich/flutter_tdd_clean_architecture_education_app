import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_education_app/core/common/features/course/data/datasources/course_remote_datasource.dart';
import 'package:tdd_education_app/core/common/features/course/data/models/course_model.dart';
import 'package:tdd_education_app/core/common/features/course/data/repositories/course_repository_implementation.dart';
import 'package:tdd_education_app/core/common/features/course/domain/entities/course.dart';
import 'package:tdd_education_app/core/errors/exceptions.dart';

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
        'should complete successfully when call to remote datasource is successfull',
        () async {
      when(() => remoteDataSource.addCourse(any())).thenAnswer(
        (_) async => Future.value(),
      );
      final result = await repositoryImplementation.addCourse(tCourse);
      expect(result, const Right<dynamic, void>(null));
      verify(() => remoteDataSource.addCourse(tCourse)).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });
}
