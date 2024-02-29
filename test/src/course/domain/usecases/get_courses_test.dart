import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_education_app/src/course/domain/entities/course.dart';
import 'package:tdd_education_app/src/course/domain/repositories/course_repository.dart';
import 'package:tdd_education_app/src/course/domain/usecases/get_courses.dart';

import 'course_repository.mock.dart';

void main() {
  late CourseRepository repo;
  late GetCourses usecase;

  setUp(() {
    repo = MockCourseRepository();
    usecase = GetCourses(repo);
  });

  test('should get courses from the repo', () async {
    // arrange
    when(() => repo.getCourses()).thenAnswer((_) async => const Right([]));
    // act
    final result = await usecase();
    // assert
    expect(result, const Right<dynamic, List<Course>>([]));
    verify(() => repo.getCourses()).called(1);
    verifyNoMoreInteractions(repo);
  });
}
